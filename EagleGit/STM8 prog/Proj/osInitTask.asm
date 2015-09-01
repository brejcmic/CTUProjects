; osInitTask
; Compiler: COSMIC
;
; int* osInitTask(  (void (*f)(void)) handler, 
;          int stackOffset);
; return: context pointer for this task

  xdef   _osInitTask      ;public
  
  switch   .bss
  
_taskPCI:  ds.b  2      ;handler address
                ;Initial PC
_taskSPO:  ds.b  2      ;task Stack Pointer Offset
_taskCSP:  ds.b  2      ;Current Stack Pointer
_taskNCP:  ds.b  2      ;New Context Pointer


  switch   .text
  
_osInitTask:
;-----------------------------------------------------------
;Getting arguments
;-----------------------------------------------------------
  ldw    _taskPCI,X      ;first argument is in X
  ld    A, (3,SP)        ;second argument is in stack
                         ;before return address
                         ;(PCH:PCL)
  ldw    X,#_taskSPO     ;MSB address to _taskSPO
  ld    (X), A
  ld    A, (4,SP)
  incw  X                ;LSB address to _taskSPO+1
  ld    (X), A
  
;-----------------------------------------------------------
;Initialize stack
;-----------------------------------------------------------
;saving current SP value
  ldw    X, SP
  ldw    _taskCSP, X
;moving in stack to the offset
  ldw    X, _taskSPO
  ldw    SP, X
;saving initial context into stack (interrupt return)
  ldw    X, _taskPCI
  pushw  X          ;1) PCL
                    ;2) PCH
  clr    A          ;
  push  A           ;3) PCE
  push  A           ;4) YL - reset value
  push  A           ;5) YH - reset value
  push  A           ;6) XL - reset value
  push  A           ;7) XH - reset value
  push  A           ;8) A - reset value
  ld    A, #$20     ;9) CC - interrupt value
  push  A
  clr    A          ;
  push  A           ;?) There are reserved
                    ;another 8 bytes in the 
                    ;interrupt. I do not why.
  push  A
  push  A
  push  A
  push  A
  push  A
  push  A
  push  A
;saving new context pointer
  ldw    X, SP
  ldw    _taskNCP, X
;restore current SP value
  ldw    X, _taskCSP
  ldw    SP, X
;-----------------------------------------------------------
;Return context pointer as a return value in X
;-----------------------------------------------------------
  ldw    X, _taskNCP
  ret
  
  end