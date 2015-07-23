/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */

#include <iostm8s105.h>
#include "mikeleOS.h"
#include "Peripheral.h"

void func1(void);
void func2(void);

main()
{
	int i, j;
	
	osInit();
	InitPeripherals();
	
	osNewTask(&func1, 56);
	osSetRun(1);
	_asm("trap");

	while (1)
	{
		i++;
		j += i;
	}
}

void func1(void)
{
	int i;
	for(i= 0; i < 100; i++);
	osSetIdle();
	_asm("trap");
}

void func2(void)
{
	int i;
	for(i= 0; i < 150; i++);
	osSetIdle();
}