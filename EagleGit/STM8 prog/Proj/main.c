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
		i++;
		j += i;
	}
}