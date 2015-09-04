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
  char days;
  char weekdays;
  char months;
  char years;
  enum timeState
  {
    IDLE, 
    START_WR, 
    START_RD,
    RESTART_RD, 
    ADDR_WR, 
    ADDR_RDWR, 
    ADDR_RDRD,
    RXNE_YARRD,
    BTF_VALWR,
    BTF_STOPWR,
    BTF_SECRD,
    BTF_MINRD,
    BTF_HORRD,
    BTF_DAYRD,
    BTF_WDYRD
  }state;
  char request;
  char writeAddr;
  char writeVal;
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
  CLK_ECKCR = 0x01;    //povoleni externiho oscilatoru
  while(!(CLK_ECKCR & 0x02));//cekani na stabilni hodinovy
              //signal
  CLK_SWCR |= 0x02;    //povoleni prepnuti hodin
  CLK_SWR = 0xB4;      //ID externiho oscilatoru
  while(CLK_SWCR & 0x01); //cekani na prepnuti hodin
  CLK_SWCR &= ~0x02;    //zakazani prepnuti hodin

//---------------------------------------------------------
//nastaveni smeru bran
  //PA - obvod 74HC595 
  PA_DDR = P_B3 | P_B4 | P_B5 | P_B6;
  PA_CR1 = P_B3 | P_B4 | P_B5 | P_B6;
  PA_CR2 = P_B3 | P_B4 | P_B5 | P_B6; //fast output
  PA_ODR = P_B4; //SCL je aktivni v nule
  
  //PB - analogove vstupy
  PB_DDR =    0x00;
  PB_CR1 =    0x00;
  PB_CR2 =    0x00;
  ADC_TDRL =  0xFF;
  
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
  I2C_CR1 =     0x81;//enable
  I2C_CR2 =     0x04;//ACK
  I2C_FREQR =   0x10;//16MHz
  I2C_OARL =    0x00;
  I2C_OARH =    0x40;
  I2C_ITR =     0x03;//ITEVTEN a ITERRN
  
  I2C_CCRL =    0x0D;//400 kHz
  I2C_CCRH =    0x80;//fast mode
  I2C_TRISER =  0x04;
//---------------------------------------------------------
//nastaveni UART
  UART2_BRR2 =  0x0B;
  UART2_BRR1 =  0x08;//115200
  UART2_CR1 =   0x00;//no parity
  UART2_CR2 =   0x2C;//rx int, tx, rx enable
  UART2_CR3 =   0x00;//1 stopbit, 0 clock polarity
  UART2_CR4 =   0x00;//nic
  UART2_CR6 =   0x00;//nic
  UART2_GTR =   0x00;//nic
  UART2_PSCR =  0x01;//nic, nema vliv
//---------------------------------------------------------
//nastaveni TIM2 CLK = 16 MHz
  TIM2_IER =    0x01;
  TIM2_SR1 =    0x00;
  TIM2_EGR =    0x00;
  TIM2_PSCR =   0x04; //1MHz
  TIM2_ARRH =   0x02; //1024 = 1 ms
  TIM2_ARRL =   0x00;
  TIM2_CR1 =    0x81;
  
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
  TIM2_SR1 =   0x00;
}

//Funkce pro zapis hodnoty na digitalni vystup desky
void setOutput(char val)
{
  char i;   //pocitadlo
  char vyst;   //vystupni hodnota
  
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
  char i;   //pocitadlo
  char vst;   //vystupni hodnota
  
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
  static char addr;
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
    else if(strComp(uartRxBf.buf, "wout,"))
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
    else if(strComp(uartRxBf.buf, "rtcr"))
    {
      rtcPrint();
    }
    else if(strComp(uartRxBf.buf, "rtcw,"))
    {
      if(uartRxBf.buf[5] != '\0' &&
         uartRxBf.buf[6] != '\0' &&
         uartRxBf.buf[7] == ',' &&
         uartRxBf.buf[8] != '\0' &&
         uartRxBf.buf[9] != '\0')
      {
        addr = ascii2Num(uartRxBf.buf[5]);
        addr <<= 4;
        addr |= ascii2Num(uartRxBf.buf[6]);
        val = ascii2Num(uartRxBf.buf[8]);
        val <<= 4;
        val |= ascii2Num(uartRxBf.buf[9]);
        if(rtcWrite(addr, val))
        {
          printMsg("Zapis hodnoty RTC registru\r\n");
        }
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
    else if(strComp(uartRxBf.buf, "ver"))
    {
      printMsg("+nastaveni hodin CPU - 16 MHz\r\n");
      printMsg("+funkcni vlakna\r\n");
      printMsg("+komunikace bluetooth\r\n");
      printMsg("+funkcni DIN, DOUT\r\n");
      printMsg("+funkcni RTC\r\n");
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
  static char val;
  static char strVal[24];
  
  while(1)
  {
    while((i2cTime.state == IDLE) && !rtcReqDone())
    {
      if(i2cTime.request & I2C_ST_UPDATE)
      {
        //stav automatu na zacatek
        i2cTime.state = START_RD;
        //zahajeni I2C prenosu
        I2C_CR2 |= I2C_CR2_START;
      }
      else if(i2cTime.request & I2C_ST_WRITE)
      {
        //stav automatu na zacatek
        i2cTime.state = START_WR;
        //zahajeni I2C prenosu
        I2C_CR2 |= I2C_CR2_START;
      }
      else if(i2cTime.request & I2C_ST_BCDCUT)
      {
        //oriznuti nevyznamnych bitu bcd kodu
        i2cTime.seconds &= 0x7F;
        i2cTime.minutes &= 0x7F;
        i2cTime.hours &= 0x3F;
        i2cTime.days &= 0x3F;
        i2cTime.weekdays &= 0x07;
        i2cTime.months &= 0x1F;
        i2cTime.request &= ~I2C_ST_BCDCUT;
      }
      else if(i2cTime.request & I2C_ST_PRINT)
      {
        //vytisknuti casu na terminal
        val = (i2cTime.hours >> 4);
        strVal[0] = num2Ascii(val);
        val = i2cTime.hours & 0x0F;
        strVal[1] = num2Ascii(val);
        strVal[2] = ':';
        val = (i2cTime.minutes >> 4);
        strVal[3] = num2Ascii(val);
        val = i2cTime.minutes & 0x0F;
        strVal[4] = num2Ascii(val);
        strVal[5] = ':';
        val = (i2cTime.seconds >> 4);
        strVal[6] = num2Ascii(val);
        val = i2cTime.seconds & 0x0F;
        strVal[7] = num2Ascii(val);
        strVal[8] = '\r';
        strVal[9] = '\n';//cas vytisten
        
        switch(i2cTime.weekdays)
        {
          case 0:
            strVal[10] = 'n';
            strVal[11] = 'e';
            break;
          case 1:
            strVal[10] = 'p';
            strVal[11] = 'o';
            break;
          case 2:
            strVal[10] = 'u';
            strVal[11] = 't';
            break;
          case 3:
            strVal[10] = 's';
            strVal[11] = 't';
            break;
          case 4:
            strVal[10] = 'c';
            strVal[11] = 't';
            break;
          case 5:
            strVal[10] = 'p';
            strVal[11] = 'a';
            break;
          default:
            strVal[10] = 's';
            strVal[11] = 'o';
        }
        
        strVal[12] = ' ';
        val = (i2cTime.days >> 4);
        strVal[13] = num2Ascii(val);
        val = i2cTime.days & 0x0F;
        strVal[14] = num2Ascii(val);
        strVal[15] = '/';
        val = (i2cTime.months >> 4);
        strVal[16] = num2Ascii(val);
        val = i2cTime.months & 0x0F;
        strVal[17] = num2Ascii(val);
        strVal[18] = '/';
        val = (i2cTime.years >> 4);
        strVal[19] = num2Ascii(val);
        val = i2cTime.years & 0x0F;
        strVal[20] = num2Ascii(val);
        strVal[21] = '\r';
        strVal[22] = '\n';
        strVal[23] = '\0';
        
        printMsg(strVal); 
        
        //smazat vsechny pozadavky
        i2cTime.request = 0x00;
      }
    }
    osSetIdle();//nastaveni necinneho stavu
    _asm("trap");//volani scheduleru
  }
}
//---------------------------------------------------------
//Pomocne funkce
//---------------------------------------------------------
//Porovnani dvou retezcu zakoncenych \0 nebo carkou
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
//Prevod 4 bit cisla do ASCII 
static char num2Ascii(char num)
{
  if(num > 9)
  {
    num += 0x37;
  }
  else if(num < 16)
  {
    num += 0x30;
  }
  else
  {
    num = 0;
  }
  return num;
}
//Prevod ASCII do 4 bit cisla
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
//Pridani retezce do buffer pro odeslani na terminal
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
  UART2_CR2 |= UART2_CR2_TXE;//txe int enable
  return 1;
}
//Preruseni UART pro vysilani znaku retezce ulozenych v bufferu
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
    UART2_CR2 &= ~(UART2_CR2_TXE);//txe int disable
  }
  return;
}
//Preruseni UART pro prijem znaku a jeho ulozeni do 
//prjimaciho buffer. Konec zpravz je treba ukoncit 
//znakem \n.
@far @interrupt void uartRx (void)
{
  char inputChar;
  //test zda nedoslo k chybe
  if(UART2_SR & UART2_SR_ERRMSK)
  {
    //zahozeni znaku v DR
    inputChar = UART2_DR;
    return;
  }
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
//I2C - RTC
//---------------------------------------------------------
//Vytisteni aktualniho casu na terminal
void rtcPrint(void)
{
  i2cTime.request |= I2C_ST_UPDATE | I2C_ST_PRINT;
  osSetRun(osTskIdx.rtc);
}
//Zapis urcite hodnoty do registru RTC
char rtcWrite(char addr, char val)
{
  if((i2cTime.request & I2C_ST_WRITE) || addr > 15)
  {
    //Zapis zrovna bezi, nelze menit promenne,
    //nebo je adresa neplatna
    return 0;
  }
  else
  {
    i2cTime.writeAddr = addr;
    i2cTime.writeVal = val;
    i2cTime.request |= I2C_ST_WRITE;
    osSetRun(osTskIdx.rtc);
    return 1;
  }
}
//Pozadavek na aktualizaci casu
void rtcUpdate(void)
{
  i2cTime.request |= I2C_ST_UPDATE;
  osSetRun(osTskIdx.rtc);
}
//Dotaz, zda byly vsechny pozadavky zpracovany
char rtcReqDone(void)
{
  //muze koncit i s chybou
  return ((i2cTime.request & ~I2C_ST_ERR) == 0);
}
//Dotaz, zda vznikla chyba
char rtcReqErr(void)
{
  return ((i2cTime.request & I2C_ST_ERR) == 0);
}

//Preruseni I2C, aktualizuje hodnoty promenych casu a
//zapisuje do registru cipu RTC
@far @interrupt void I2CRxTx(void)
{
  static char sr1;
  static char sr2;
  static char sr3;
  
  //cteni SR1, SR2
  sr1 = I2C_SR1;
  sr2 = I2C_SR2;
  
  //kontrola zda nenastala chyba
  if(sr2 != 0)
  {
    I2C_SR2 = 0;
    i2cTime.state = IDLE;
    //vsechny pozadavky smazat a nahlasit chybu
    i2cTime.request = I2C_ST_ERR;
  }
  
  //preruseni od startu
  if(sr1 & I2C_SR1_SB)
  {
    switch(i2cTime.state)
    {
      case START_WR:
        I2C_DR = I2C_ADDR_WRITE;
        i2cTime.state = ADDR_WR;
        break;
      case START_RD:
        I2C_DR = I2C_ADDR_WRITE;
        i2cTime.state = ADDR_RDWR;
        break;
      case RESTART_RD:
        I2C_DR = I2C_ADDR_READ;
        i2cTime.state = ADDR_RDRD;
        break;
    }
  }
  
  //preruseni po odeslani adresy
  if(sr1 & I2C_SR1_ADDR)
  {
    switch(i2cTime.state)
    {
      case ADDR_WR:
        //cteni SR3 maze vlajku preruseni
        sr3 = I2C_SR3;
        //zadani adresy registru
        I2C_DR = i2cTime.writeAddr;
        i2cTime.state = BTF_VALWR;
        break;
      case ADDR_RDWR:
        //cteni SR3 maze vlajku preruseni
        sr3 = I2C_SR3;
        //zadani adresy registru na sekundy
        I2C_DR = 0x02;
        //restart I2C
        I2C_CR2 = I2C_CR2_START | I2C_CR2_STOP;
        i2cTime.state = RESTART_RD;
        break;
      case ADDR_RDRD:
        //cteni SR3 maze vlajku preruseni
        sr3 = I2C_SR3;
        I2C_CR2 = I2C_CR2_ACK;//nastavuje ACK
        i2cTime.state = BTF_SECRD;
        break;
    }
  }
  //preruseni vyvolane prijetim jednoho byte
  if(sr1 & I2C_SR1_RXNE)
  {
    //ukonceni prijmu
    if(i2cTime.state == RXNE_YARRD)
    {
      //cte roky
      i2cTime.years = I2C_DR;
      i2cTime.state = IDLE;
      //pozadavek oriznuti nevyznamnych bitu
      i2cTime.request |= I2C_ST_BCDCUT;
      //smazani vlajky UPDATE
      i2cTime.request &= ~I2C_ST_UPDATE;
      osSetRun(osTskIdx.rtc);
    }
    //zakaz preruseni TXE a RXNE
    I2C_ITR &= ~I2C_ITR_ITBUFEN;
  }
  
  //preruseni po odeslani nebo prijeti bufferu
  if(sr1 & I2C_SR1_BTF)
  {
    switch(i2cTime.state)
    {
      case BTF_VALWR:
        if(sr1 & I2C_SR1_TXE)
        {
          //zadani hodnoty registru
          I2C_DR = i2cTime.writeVal;
          i2cTime.state = BTF_STOPWR;
        }
        break;
      case BTF_STOPWR:
        //nastavuje stop
        I2C_CR2 = I2C_CR2_STOP;
        i2cTime.state = IDLE;
        //smazani vlajky WRITE
        i2cTime.request &= ~I2C_ST_WRITE;
        break;
      case BTF_SECRD:
        //cte sekundy
        i2cTime.seconds = I2C_DR;
        I2C_CR2 = I2C_CR2_ACK;//nastavuje ACK
        i2cTime.state = BTF_MINRD;
        break;
      case BTF_MINRD:
        //cte minuty
        i2cTime.minutes = I2C_DR;
        I2C_CR2 = I2C_CR2_ACK;//nastavuje ACK
        i2cTime.state = BTF_HORRD;
        break;
      case BTF_HORRD:
        //cte hodiny
        i2cTime.hours = I2C_DR;
        I2C_CR2 = I2C_CR2_ACK;//nastavuje ACK
        i2cTime.state = BTF_DAYRD;
        break;
      case BTF_DAYRD:
        //cte dny
        i2cTime.days = I2C_DR;
        I2C_CR2 = I2C_CR2_ACK;//nastavuje ACK
        i2cTime.state = BTF_WDYRD;
        break;
      case BTF_WDYRD:
        //cte dny v tydnu
        i2cTime.weekdays = I2C_DR;
        I2C_CR2 = I2C_CR2_STOP;//nastavuje NACK + STOP
        //cte mesice
        i2cTime.months = I2C_DR;
        //povoleni preruseni
        I2C_ITR |= I2C_ITR_ITBUFEN;
        i2cTime.state = RXNE_YARRD;
        break;
    }
  }
}
