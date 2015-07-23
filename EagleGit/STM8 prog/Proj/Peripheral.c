/* Peripheral.c
 * Inicializace periferii pro STM8 discovery kit na desce
 * terarko.
 */

#include <iostm8s105.h>
#include "Peripheral.h"

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
	PB_DDR = 0x00;
	PB_CR1 = 0x00;
	PB_CR2 = 0x00;
	ADC_TDRL = 0xFF;
	
	//PC - nepouzivat
	
	//PD - UART
	
	//PE - obvod 74HC597 + I2C
	PE_DDR |= P_B3 | P_B6 | P_B7;
	PE_CR1 |= P_B3 | P_B5 | P_B6 | P_B7;
	PE_CR2 |= P_B3 | P_B6 | P_B7;
	
	//PG - nepouzito
	
//---------------------------------------------------------
//nastaveni I2C
	I2C_CR1 = 0x00;
	I2C_CR2 = 0x00;
	I2C_FREQR = 0x10;//16MHz
	I2C_OARL = 0x00;
	I2C_OARH = 0x00;
	I2C_ITR = 0x00;
	
	I2C_CCRL = 0x0D;//400 kHz
	I2C_CCRH = 0x80;//fast mode
	I2C_TRISER = 0x02;
//---------------------------------------------------------
//nastaveni UART
	UART2_BRR2 = 0x00;
	UART2_CR1 = 0x00;
	UART2_CR2 = 0x00;
	UART2_CR3 = 0x00;
	UART2_CR4 = 0x00;
	UART2_CR6 = 0x00;
	UART2_GTR = 0x00;
	UART2_PSCR = 0x00;
//---------------------------------------------------------
//nastaveni TIM2 CLK = 16 MHz
	TIM2_IER = P_B0;
	TIM2_SR1 &= ~P_B0;
	TIM2_EGR = 0x00;
	TIM2_PSCR = 0x04; //1MHz
	TIM2_ARRH = 0x02;
	TIM2_ARRL = 0x00;
	TIM2_CR1 = P_B7 | P_B0;
	
	_asm("rim");
}

void setOutput(char val)
{
	int i; 	//pocitadlo
	char vyst; //vystupni hodnota
	
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

char readInput(void)
{
	int i; 	//pocitadlo
	char vst; //vystupni hodnota
	
	//paralelni load
	PE_ODR &= ~P_B7; //SLD dolu - load
	PE_ODR |= P_B6; //RCK nahoru
	vst = 0; //nuluji tady kvuli prodleve
	PE_ODR |= P_B7; //SLD nahoru - load konec
	
	for(i= 0; i < 8; i++)
	{
		vst = vst << 1; //tady kvuli prodleve
		PE_ODR &= ~P_B3; //SRCK dolu
		vst = (PE_IDR & P_B5) >> 5; //ser. vstup
		PE_ODR |= P_B3; //SRCK nahoru
	}
	//zobrazeni vystupu pomoci RCK
	PE_ODR &= ~P_B6; //RCK dolu
	
	return vst;
}