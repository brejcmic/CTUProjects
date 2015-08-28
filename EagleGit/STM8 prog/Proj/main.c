/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */

#include <iostm8s105.h>
#include "osKernel.h"
#include "Peripheral.h"

void main(void)
{
	int i, j;
	
	InitPeripherals();

	while (1)
	{
		PD_ODR |= 0x01;
		while(i < 15000)
		{
			i++;
		}
		PD_ODR &= 0xFE;
		while(i > 0)
		{
			i--;
		}
	}
}