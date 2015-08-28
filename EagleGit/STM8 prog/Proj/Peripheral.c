/* Peripheral.c
 * Provadi se zde inicializace periferii pro obsluhu desky
 * terarko. Navic jsou zde funkce pro obsluhu techto
 * periferii a inicializace a obsluha vlaken operacniho
 * systemu
 */

#include <iostm8s105.h>
#include "osKernel.h"
#include "Peripheral.h"

static struct osSysTskIdx_st
{
	char uart;
	char rtc;
}osTskIdx;

static struct uartRxBuf_st
{
	char buf[UART_RX_BUF_LEN];
	char idx;
}uartRxBf;

static struct uartTxBuf_st
{
	char *buf[UART_TX_BUF_LEN];
	char idxr;//cteni ukazatele
	char idxw;//zapis ukazatele
	char len;//pocet platnych ukazatelu v poli
	char idxs;//cteni retezce
}uartTxBf;

static struct i2cTime_st
{
	char seconds;
	char minutes;
	char hours;
	char day;
	char weekday;
	char month;
	char year;
	enum timeState
	{
		free= 0, update, print, busy
	}state;
}i2cTime;

static void clrTIM2IntFlag(void);
static void osUart(void);
static void osRtc(void);
static char strComp(const char *arr1, const char *arr2);
static char num2Ascii(char num);
static char ascii2Num(char ascii);

void InitPeripherals(void)
{
//---------------------------------------------------------
//nastaveni hodin
	CLK_ECKCR = 0x01;		//povoleni externiho oscilatoru
	while(!(CLK_ECKCR & 0x02));//cekani na stabilni hodinovy
							//signal
	CLK_SWCR |= 0x02;		//povoleni prepnuti hodin
	CLK_SWR = 0xB4;			//ID externiho oscilatoru
	while(CLK_SWCR & 0x01); //cekani na prepnuti hodin
	CLK_SWCR &= ~0x02;		//zakazani prepnuti hodin

//---------------------------------------------------------
//nastaveni smeru bran
	//PA - obvod 74HC595 
	PA_DDR = P_B3 | P_B4 | P_B5 | P_B6;
	PA_CR1 = P_B3 | P_B4 | P_B5 | P_B6;
	PA_CR2 = P_B3 | P_B4 | P_B5 | P_B6; //fast output
	PA_ODR = P_B4; //SCL je aktivni v nule
	
	//PB - analogove vstupy
	PB_DDR = 	0x00;
	PB_CR1 = 	0x00;
	PB_CR2 = 	0x00;
	ADC_TDRL = 	0xFF;
	
	//PC - nepouzivat
	
	//PD - UART
	PD_DDR = P_B4 | P_B2 | P_B0; //CTS, RESET, LED
	PD_CR1 = P_B4 | P_B2 | P_B0;
	PD_CR2 = P_B4 | P_B2 | P_B0;
	PD_ODR = P_B2;//RESET disable
	
	//PE - obvod 74HC597 + I2C
	PE_DDR |= P_B3 | P_B6 | P_B7;
	PE_CR1 |= P_B3 | P_B5 | P_B6 | P_B7;
	PE_CR2 |= P_B3 | P_B6 | P_B7;
	
	//PG - nepouzito
	
//---------------------------------------------------------
//nastaveni I2C
	I2C_CR1 = 	0x01;//enable
	I2C_CR2 = 	0x04;//ACK
	I2C_FREQR = 0x10;//16MHz
	I2C_OARL = 	0x00;
	I2C_OARH = 	0x40;
	I2C_ITR = 	0x02;//ITEVTEN
	
	I2C_CCRL = 	0x0D;//400 kHz
	I2C_CCRH = 	0x80;//fast mode
	I2C_TRISER = 0x04;
//---------------------------------------------------------
//nastaveni UART
	UART2_BRR2 = 0x0B;
	UART2_BRR1 = 0x08;//115200
	UART2_CR1 = 0x00;//no parity
	UART2_CR2 = 0x2C;//rx int, tx, rx enable
	UART2_CR3 = 0x00;//1 stopbit, 0 clock polarity
	UART2_CR4 = 0x00;//nic
	UART2_CR6 = 0x00;//nic
	UART2_GTR = 0x00;//nic
	UART2_PSCR = 0x01;//nic, nema vliv
//---------------------------------------------------------
//nastaveni TIM2 CLK = 16 MHz
	TIM2_IER = 	0x01;
	TIM2_SR1 = 	0x00;
	TIM2_EGR = 	0x00;
	TIM2_PSCR = 0x04; //1MHz
	TIM2_ARRH = 0x02; //1024 = 1 ms
	TIM2_ARRL = 0x00;
	TIM2_CR1 = 	0x81;
	
	_asm("rim");
//---------------------------------------------------------
//inicializace promennych pro UART
	uartRxBf.idx = 0;
	uartTxBf.idxw = 0;
	uartTxBf.idxr = 0;
	uartTxBf.idxs = 0;
	uartTxBf.len = 0;

//---------------------------------------------------------
//inicializace operacniho systemu a ulozeni indexu vlaken
	osInit(&clrTIM2IntFlag);
	osTskIdx.uart = osNewTask(&osUart, 64);
	if(osTskIdx.uart == 0) 
	{
		while(1); //pri chybe nekonecna smycka
	}
	osTskIdx.rtc = osNewTask(&osRtc, 64);
	if(osTskIdx.rtc == 0) 
	{
		while(1); //pri chybe nekonecna smycka
	}
}

//Funkce pro mazani vlajky preruseni scheduleru
static void clrTIM2IntFlag(void)
{
	TIM2_SR1 = 	0x00;
}

//Funkce pro zapis hodnoty na digitalni vystup desky
void setOutput(char val)
{
	char i; 	//pocitadlo
	char vyst; 	//vystupni hodnota
	
	PA_ODR &= ~P_B5; //RCK dolu
	
	for(i= 0; i < 8; i++)
	{
		vyst = val & 0x01;
		PA_ODR = (vyst << 3) | P_B4;//na PA3, SCL stale v H
		PA_ODR |= P_B6; //SCK nahoru
		val = val >> 1; //kvuli zavedeni prodlevy posouvam 
						//tady
		PA_ODR &= ~P_B6;//SCK dolu
	}
	//zobrazeni vystupu pomoci RCK
	PA_ODR |= P_B5; //RCK nahoru
}

//Funkce pro cteni hodnoty z digitalniho vstupu desky
char readInput(void)
{
	char i; 	//pocitadlo
	char vst; 	//vystupni hodnota
	
	//paralelni load
	PE_ODR &= ~P_B7; //SLD dolu - load
	PE_ODR |= P_B6; //RCK nahoru
	vst = 0; //nuluji tady kvuli prodleve
	PE_ODR |= P_B7; //SLD nahoru - load konec
	
	for(i= 0; i < 8; i++)
	{
		vst = vst << 1; //tady kvuli prodleve
		PE_ODR &= ~P_B3; //SRCK dolu
		vst |= (PE_IDR & P_B5) >> 5; //ser. vstup
		PE_ODR |= P_B3; //SRCK nahoru
	}
	//zobrazeni vystupu pomoci RCK
	PE_ODR &= ~P_B6; //RCK dolu
	
	return vst;
}

//---------------------------------------------------------
//Vlakna operacniho systemu
//---------------------------------------------------------
static void osUart(void)
{
	static char val;
	static char strVal[5];
	
	while(1)
	{
		if(strComp(uartRxBf.buf, "rin"))
		{
			printMsg("DIN = ");
			val = readInput();
			strVal[1] = val & 0x0F;
			strVal[1] = num2Ascii(strVal[1]);
			strVal[0] = val >> 4;
			strVal[0] = num2Ascii(strVal[0]);
			strVal[2] = '\r';
			strVal[3] = '\n';
			strVal[4] = '\0';
			printMsg(strVal);
		}
		else if(strComp(uartRxBf.buf, "sout,"))
		{
			if(uartRxBf.buf[5] != '\0' &&
			   uartRxBf.buf[6] != '\0')
			{
				val = ascii2Num(uartRxBf.buf[5]);
				val <<= 4;
				val |= ascii2Num(uartRxBf.buf[6]);
				setOutput(val);
				printMsg("DOUT nastaven\r\n");
			}
		}
		else if(strComp(uartRxBf.buf, "id"))
		{
			printMsg("Testovaci pripravek pro podporu vyuky.\r\n");
			printMsg("Bluetooth: RN-41\r\n");
			printMsg("RTC:       PCF8563\r\n");
			printMsg("Kit:       STM8 Discovery\r\n");
			printMsg("Katedra:   Elektrotechnologie\r\n");
		}
		else if(strComp(uartRxBf.buf, "verze"))
		{
			printMsg("+nastaveni hodin CPU - 16 MHz\r\n");
			printMsg("+funkcni vlakna\r\n");
			printMsg("+komunikace bluetooth\r\n");
			printMsg("+funkcni DIN, DOUT\r\n");
		}
		else if(strComp(uartRxBf.buf, "uart"))
		{
			printMsg("baud:     115200\r\n");
			printMsg("data:     8 bit\r\n");
			printMsg("parita:   zadna\r\n");
			printMsg("stop bit: 1\r\n");
		}
		osSetIdle();//nastaveni necinneho stavu
		_asm("trap");//volani scheduleru
	}
}

static void osRtc(void)
{
	int i;
	while(1)
	{
		if(!(i2cTime.state & I2C_ST_BUSY))
		{
			if(i2cTime.state & I2C_ST_UPDATE)
			{
				I2C_CR2 |= 0x01; //start condition
			}
		}
		_asm("trap");//volani scheduleru
	}
}
//---------------------------------------------------------
//Pomocne funkce
//---------------------------------------------------------
static char strComp(const char *arr1, const char *arr2)
{
	char idx;
	idx = 0;
	
	while(arr1[idx] == arr2[idx])
	{
		if(arr1[idx] == '\0' || arr1[idx] == ',')
		{
			return idx;
		}
		else
		{
			idx++;
		}
	}
	return 0;
}

static char num2Ascii(char num)
{
	if(num > 9)
	{
		num += 0x37;
	}
	else
	{
		num += 0x30;
	}
	return num;
}

static char ascii2Num(char ascii)
{
	if(ascii > 0x60 && ascii < 0x67)//mala pismena
	{
		ascii -= 0x57;
	}
	else if(ascii > 0x40 && ascii < 0x47)//velka pismena
	{
		ascii -= 0x37;
	}
	else if(ascii > 0x2f && ascii < 0x3a)//cisla
	{
		ascii -= 0x30;
	}
	else
	{
		ascii = 0;
	}
	return ascii;
}

//---------------------------------------------------------
//UART
//---------------------------------------------------------

char printMsg(char *message)
{
	//zjisteni poctu ulozenych hodnot
	if(uartTxBf.len == UART_TX_BUF_LEN)
	{
		return 0;
	}
	//ulozeni nove zpravy do pole
	uartTxBf.buf[uartTxBf.idxw] = message;
	uartTxBf.idxw++;
	uartTxBf.idxw &= UART_TX_BUF_IDX_MSK;
	uartTxBf.len++;
	//nastaveni priznaku pro odesilani
	UART2_CR2 |= 0x80;//txe int enable
	return 1;
}

@far @interrupt void uartTx (void)
{
	while(uartTxBf.buf[uartTxBf.idxr][uartTxBf.idxs] == '\0' &&
	      uartTxBf.len > 0)
	{
		//prejit na dalsi ukazatel
		uartTxBf.idxr++;
		uartTxBf.idxr &= UART_TX_BUF_IDX_MSK;
		uartTxBf.len--;
		uartTxBf.idxs = 0;
	}
	
	if(uartTxBf.len > 0)
	{
		//zapis do registru zaroven maze vlajku preruseni
		UART2_DR = uartTxBf.buf[uartTxBf.idxr][uartTxBf.idxs];
		uartTxBf.idxs++;
	}
	else
	{
		UART2_CR2 &= ~(0x80);//txe int disable
	}
	return;
}

@far @interrupt void uartRx (void)
{
	char inputChar;
	//cteni znaku,
	//cteni datoveho registru by melo zaroven mazat vlajku
	//preruseni
	inputChar = UART2_DR;
	//kontrola ridiciho znaku
	switch(inputChar)
	{
		case 0x0A://spustit vlakno a najet na zacatek pole
			osSetRun(osTskIdx.uart);
		case 0x0D://najet na zacatek pole
			if(uartRxBf.idx != 0)
			{
				//pole je ukonceno znakem \0
				uartRxBf.buf[uartRxBf.idx] = '\0';
				uartRxBf.idx = 0;
			}
			break;
		default://zvysit index a oriznout dle masky
			uartRxBf.buf[uartRxBf.idx] = inputChar;
			uartRxBf.idx++;
			uartRxBf.idx &= UART_RX_BUF_IDX_MSK;
			break;
	}
	return;
}

//---------------------------------------------------------
//I2C
//---------------------------------------------------------
@far @interrupt void I2CRxTx(void)
{
	char val;
	//cteni SR1
	val = I2C_SR1;
	
	switch(i2cTime.state)
	{
		case start:
			if(val & I2C_SR1_SB)
			{
				I2C_DR = I2C_ADDR_WRITE;
				i2cTime.state = regaddr;
			}
			break;
		case regaddr:
			if(val & I2C_SR1_ADDR)
			{
				val = I2C_SR3;
				I2C_DR = 0x02;
				I2C_CR2 |= 0x02;//nastavuje stopku
				i2cTime.state = stop;
			}
			break;
		case stop:
			if(val & I2C_SR1_STOPF)
			{
				I2C_CR2 &= ~0x02;//maze stopku
			}
			break;
	}
}