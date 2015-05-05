/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */

#include <iostm8s105.h>
#include "mikeleOS.h"

void func(void);

main()
{
	osInit();

	while (1);
}

void func(void)
{
	int i;
	for(i= 0; i < 100; i++);
}