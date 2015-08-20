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
	char buf[UART_BUF_LEN];
	char idx;
}uartRxBf;

static struct uartRxBuf_st
{
	char *buf[UART_RX_BUF_LEN];
	char idx;
}uartTxBf;

static void clrTIM2IntFlag(void);
static void osUart(void);
static void osRtc(void);
static char strComp(const char *arr1, const char *arr2);

void InitPeripherals(void)
{
//---------------------------------------------------------
//nastaveni smeru bran
	//PA - obvod 74HC595 
	PA_DDR |= P_B3 | P_B4 | P_B5 | P_B6;
	PA_CR1 |= P_B3 | P_B4 | P_B5 | P_B6;
	PA_CR2 |= P_B3 | P_B4 | P_B5 | P_B6; //fast output
	PA_ODR |= P_B4; //SCL je aktivni v nule
	
	//PB - analogove vstupy
	PB_DDR = 	0x00;
	PB_CR1 = 	0x00;
	PB_CR2 = 	0x00;
	ADC_TDRL = 	0xFF;
	
	//PC - nepouzivat
	
	//PD - UART
	
	//PE - obvod 74HC597 + I2C
	PE_DDR |= P_B3 | P_B6 | P_B7;
	PE_CR1 |= P_B3 | P_B5 | P_B6 | P_B7;
	PE_CR2 |= P_B3 | P_B6 | P_B7;
	
	//PG - nepouzito
	
//---------------------------------------------------------
//nastaveni I2C
	I2C_CR1 = 	0x01;//enable
	I2C_CR2 = 	0x00;
	I2C_FREQR = 0x10;//16MHz
	I2C_OARL = 	0x00;
	I2C_OARH = 	0x40;
	I2C_ITR = 	0x00;
	
	I2C_CCRL = 	0x0D;//400 kHz
	I2C_CCRH = 	0x80;//fast mode
	I2C_TRISER = 0x02;
//---------------------------------------------------------
//nastaveni UART
	UART2_BRR2 = 0x0B;
	UART2_BRR1 = 0x08;//115200
	UART2_CR1 = 0x00;//no parity
	UART2_CR2 = 0x6C;//tx, rx int + tx, rx enable
	UART2_CR3 = 0x00;//1 stopbit, 0 clock polarity
	UART2_CR4 = 0x00;//nic
	UART2_CR6 = 0x00;//nic
	UART2_GTR = 0x00;//nic
	UART2_PSCR = 0x00;//nic
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

//Funkce pro zapis hodnotz na digitalni vystup desky
void setOutput(char val)
{
	char i; 	//pocitadlo
	char vyst; 	//vystupni hodnota
	
	PA_ODR &= ~P_B5; //RCK dolu
	
	for(i= 0; i < 8; i++)
	{
		vyst = val & 0x01;
		PA_ODR = vyst << 3; //na PA3
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
	int idx;
	
	while(1)
	{
		if(osDoesTaskRun())
		{
			idx = strComp(uartRxBf.buf, "Ahoj");
			if(idx > 0)
			{
				
			}
			osSetIdle();
		}
	}
}

static void osRtc(void)
{
	int i;
	while(1)
	{
		if(osDoesTaskRun())
		{
			for(i= 0; i < 100; i++);
			osSetIdle();
		}
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

//---------------------------------------------------------
//Preruseni UARTu
//---------------------------------------------------------

@far @interrupt void uartTx (void)
{
	
	return;
}

@far @interrupt void uartRx (void)
{
	//cteni znaku a jeho uloyeni do pole,
	//cteni datoveho registru by melo zaroven mazat vlajku
	//preruseni
	uartRxBf.buf[uartRxBf.idx] = UART2_DR;
	//kontrola ridiciho znaku
	switch(uartRxBf.buf[uartRxBf.idx])
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
			uartRxBf.idx++;
			uartRxBf.idx &= UART_BUF_IDX_MSK;
			break;
	}
	
	return;
}