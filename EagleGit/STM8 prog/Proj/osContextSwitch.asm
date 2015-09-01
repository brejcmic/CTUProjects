; osContextSwitch
; Compiler: COSMIC
;
; int* osContextSwitch(int * newContext);
; return: old context pointer

	xdef 	_osContextSwitch	;public
	
	switch 	.bss

_contOld:	ds.b	2
_contNew:	ds.b	2
_contRPC:	ds.b	2			;Returning PC
	
	switch 	.text
	
_osContextSwitch:
;-----------------------------------------------------------
;Getting arguments
;-----------------------------------------------------------
	ldw		_contNew,X			;first argument is in X
;-----------------------------------------------------------
;Clearing stack - just extracting returning address
;-----------------------------------------------------------
	popw	X
	ldw		_contRPC,X
;-----------------------------------------------------------
;Saving old context pointer
;-----------------------------------------------------------
	ldw		X, SP
	ldw		_contOld,X
;-----------------------------------------------------------
;Context switching with setting returning PC
;-----------------------------------------------------------
	ldw		X,_contNew
	ldw		SP,X				;new context was set
	ldw		X,_contRPC
	pushw	X					;returning address was added
;-----------------------------------------------------------
;Return old context pointer as a return value in X
;-----------------------------------------------------------
	ldw		X,_contOld
	ret
	
	end