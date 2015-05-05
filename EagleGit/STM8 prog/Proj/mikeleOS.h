/*	MikeleOS.h
 *
 */
 
//maximalni pocet vlaken
#define OS_TASKCOUNTMAX				3

//---------------------------------------------------------
//vrchol pameti STACK +
//pocatek pameti STACK pro ukoly ve vlaknech
#define OS_STACKBASE					0x7FF
//offset pameti STACK v idle vlakne
#define OS_STACKIDLEOFFSET				32
//pocatecni adresa prvniho vlakna ve stacku
#define OS_STACKTASKBASE				(OS_STACKBASE-OS_STACKIDLEOFFSET)
//maximalni velikost pameti STACK v bytech
#define OS_STACKSIZEMAX					512
//minimalni adresa pameti STACK
#define OS_STACKADDRESSMIN				(OS_STACKBASE-OS_STACKSIZEMAX)
//---------------------------------------------------------

//stavy
typedef enum
{
	idle,
	run	
}os_taskStates;

//ukazatel na handler vlakna
typedef @near void (*osTaskHandler)(void);

//---------------------------------------------------------
//Deklarace
//---------------------------------------------------------
void osInit(void);
int osNewTask(osTaskHandler handler, int memorySize);