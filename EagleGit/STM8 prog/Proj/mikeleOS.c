/*	MikeleOS.c
 *	Compiler:	COSMIC C, ASM
 */
#include "mikeleOS.h"

//inicializace SP pro dany ukol
//1. parametr je handler funkce tasku
//2. parametr je pocatecni adresa stacku pro dany ukol
//Navratova hodnota je adresa stacku s inicializovnym 
//obsahem
extern int* osInitTask(osTaskHandler handler, 
				unsigned int stackOffset);
//prehozeni dvou SP s inicializovanym obsahem
//1. parametr je novy ukayatel na stack (novy obsah)
//Navratova hodnota je dosavadni ukazatel na stack
extern int* osContextSwitch(int *newContext);


typedef struct{
	os_taskStates state;
	int *context;
}os_task;

//pole vlaken, 0 index je vzhrazen pro hlavni smycku
//oocet tasku tak musi byt o 1 vyssi
os_task taskArray[OS_TASKCOUNTMAX +1];

//promenne v RAM
struct{
	int stackOffset;//zbyvajici offset v pameti
	char taskLeft;	//zbyvajici ukoly
	char currTask;	//momentalne bezici ukol
	char tskIdx; 	//poctadlo
}osSysVar;

void osInit(void)
{
	osSysVar.stackOffset = OS_STACKTASKBASE;
	osSysVar.taskLeft = OS_TASKCOUNTMAX;
	osSysVar.currTask = 0; //prvni je ukol s nejnizsi prioritou
	taskArray[0].state = run;
}

//prioritu tasku urcuje poradi inicializace
int osNewTask(osTaskHandler handler, unsigned int memorySize)
{	
	//kontrola, zda je mozne ukol vytvorit
	if(osSysVar.taskLeft <= 0) return 0;
	if((osSysVar.stackOffset - memorySize) < OS_STACKADDRESSMIN) 
	{
		//priradit zbyvajici pamet
		memorySize = osSysVar.stackOffset - OS_STACKADDRESSMIN;
		if(memorySize <= 0) return 0;
	}
	
	//vytvoreni noveho ukolu na indexu j, ktery je posunut 
	//o 1 tj. o ukol hlavni smycky, ktery ma index 0
	osSysVar.taskLeft--;
	osSysVar.tskIdx = OS_TASKCOUNTMAX - osSysVar.taskLeft;
	taskArray[osSysVar.tskIdx].state = idle;
	taskArray[osSysVar.tskIdx].context = osInitTask(handler, osSysVar.stackOffset);
	
	//novy offset
	osSysVar.stackOffset -= memorySize;
	
	return 1;
}

@far @interrupt void osScheduler (void)
{
	//nejvyssi priorita
	osSysVar.tskIdx = OS_TASKCOUNTMAX - osSysVar.taskLeft;
	
	//nalezeni beziciho ukolu s nejvyssi prioritou
	while(osSysVar.tskIdx > 0 && taskArray[osSysVar.tskIdx].state == idle)
	{
		osSysVar.tskIdx--;
	}
	
	//vyber noveho ukolu
	if(osSysVar.tskIdx != osSysVar.currTask)
	{
		taskArray[osSysVar.currTask].context = osContextSwitch(taskArray[osSysVar.tskIdx].context);
		osSysVar.currTask = osSysVar.tskIdx;
	}
	
	return;
}