/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */

#include <iostm8s105.h>
#include <mikeleos.h>

void func(void);

main()
{
	osInit();
	int *j;
	j = (int*)(0x7FF - 0x40);
	//j = osContextSwitch(j);
	//j = osContextSwitch(j);
	for(;*j < 0; *j-- );
	while (1);
}

void func(void)
{
	int i;
	for(i= 0; i < 100; i++);
}