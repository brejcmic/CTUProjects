/*  osKernel.c
 *  Compiler:  COSMIC C, ASM
 */

#include <iostm8s105.h>
#include "osKernel.h"

//inicializace SP pro dany ukol
//1. parametr je handler funkce tasku
//2. parametr je pocatecni adresa stacku pro dany ukol
//Navratova hodnota je adresa stacku s inicializovnym 
//obsahem
extern int* osInitTask(osTaskHandler handler, 
        unsigned int stackOffset);
//prehozeni dvou SP s inicializovanym obsahem
//1. parametr je novy ukazatel na stack (novy obsah)
//Navratova hodnota je dosavadni ukazatel na stack
extern int* osContextSwitch(int *newContext);


typedef struct{
  os_taskStates state;
  int *context;
}os_task;

//pole vlaken, 0 index je vzhrazen pro hlavni smycku
//oocet tasku tak musi byt o 1 vyssi
static os_task taskArray[OS_TASKCOUNTMAX +1];

//promenne v RAM
static struct{
  int stackOffset;//zbyvajici offset v pameti
  char taskLeft;  //zbyvajici ukoly
  char currTask;  //momentalne bezici ukol
  char tskIdx;   //pocitadlo
  //ukazatel na funkci pro mazani vlajky preruseni
  //scheduleru
  osTaskHandler schedCIF;//clear Interrupt Flag
}osSysVar;

void osInit(osTaskHandler schedCIF)
{
  osSysVar.schedCIF = schedCIF;
  osSysVar.stackOffset = OS_STACKTASKBASE;
  osSysVar.taskLeft = OS_TASKCOUNTMAX;
  //prvni je ukol s nejnizsi prioritou
  osSysVar.currTask = 0; 
  taskArray[0].state = run;
}

//prioritu tasku urcuje poradi inicializace
char osNewTask(osTaskHandler handler, unsigned int memorySize)
{  
  //kontrola, zda je mozne ukol vytvorit
  if(osSysVar.taskLeft <= 0) return 0;
  if((osSysVar.stackOffset - memorySize) < OS_STACKADDRESSMIN) 
  {
    //priradit zbyvajici pamet
    memorySize = osSysVar.stackOffset - OS_STACKADDRESSMIN;
    //pokud jiz neni zadna pamet
    if(memorySize <= 0) return 0;
  }
  
  //vytvoreni noveho ukolu na indexu idx, ktery je posunut 
  //o 1 tj. o ukol hlavni smycky, ktery ma index 0
  osSysVar.taskLeft--;
  osSysVar.tskIdx = OS_TASKCOUNTMAX - osSysVar.taskLeft;
  taskArray[osSysVar.tskIdx].state = idle;
  taskArray[osSysVar.tskIdx].context = osInitTask(handler, osSysVar.stackOffset);
  
  //novy offset
  osSysVar.stackOffset -= memorySize;
  
  return osSysVar.tskIdx;
}

void osSetIdle(void)
{
  taskArray[osSysVar.currTask].state = idle;
}

void osSetRun(char idx)
{
  taskArray[idx].state = run;
}

char osDoesTaskRun(char idx)
{
  return (taskArray[idx].state == run);
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
  
  //smazani vlajky preruseni
  osSysVar.schedCIF();
  
  return;
}