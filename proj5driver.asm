;******************************************************************************************
;Program Name: proj4a.asm
;Programmer:   Colin Kelley
;Class:        CSCI 2160-001
;Date:         November 2, 2018 at 5:00 PM
;Purpose:	   This is a driver program that is used to test various methods from methods4.asm
;	
;******************************************************************************************

	.486
	.model flat
	.stack 100h
	
	ExitProcess			PROTO Near32 stdcall, dVal:dword  ;dVal normally 0
	ascint32			PROTO NEAR32 stdcall, lpInputString:dword
	intasc32			PROTO NEAR32 stdcall, lpOutputString:dword,dNum:dword
	getstring			PROTO NEAR32 stdcall, lpInputString:dword, dStringLength:dword
	putstring			PROTO NEAR32 stdcall, lpInputString:dword
	putch				PROTO Near32 stdcall, bVal:byte
	getche				PROTO Near32 stdcall		;gets a char and echos it
	getch				PROTO Near32 stdcall		;no echo of char
	intasc32Comma 		PROTO Near32 stdcall, lpStringToConvert:dword, dVal:dword ; puts in commas
	hexToChar			PROTO Near32 stdcall,lpDestStr:dword,lpSourceStr:dword, dLen:dword
	
	Extern String_length:Near32, String_copy:Near32, String_equals:Near32, String_equalsIgnoreCase:Near32, String_toUpperCase:Near32, String_toLowerCase:Near32, String_appends:Near32
	
COMMENT %
;************************************************************************************
; name:  newline
; date: 9/27/2018
; purpose:  Advance to a new line
;***********************************************************************************%
newline  macro  
	
	INVOKE putch, 10	;Advance to a new line
	INVOKE putch, 13	;Move to beginning of line
	
	endm

comment %
;**************************************************************************************
;* Name: tab															 
;* Purpose: 																			 
;*	  The purpose of this macro is to tab over one position on the screen     
;*																					 
;*Date created: September 27, 2018														 
;*Date last modified:Sept. 27, 2018												 		 
;**************************************************************************************%
tab	macro
	
	INVOKE putch, 9	;Tab over one position 	
	
	endm
	
	.data
strTest1	byte	10,13,"hello, my name is colin",0	;String for testing
strTest2	byte	10,13,"HELLO, MY NAME IS COLIN",0	;String for testing
strTest3	byte	"Bill Jones",0			;String for testing	
strTest4	byte	"went to town",0		;String for testing
strOut		byte	50 dup(?)				;String for testing
strTest5	byte	"Length is: ",0			;String for testing
strTest6	byte	10,13,9,"The copied string is: ",0	;String for testing
strTest7	byte	10,13,9,"The strings are not equal (case sensitive)",0 ;String for testing
strTest8	byte	10,13,9,"The strings are equal (case sensitive)",0 ;String for testing
strTest9	byte	10,13,9,"The strings are not equal (not case sensitive)",0 ;String for testing
strTest10	byte	10,13,9,"The strings are equal (not case sensitive)",0 ;String for testing
dVal 		dword	?						;Dword to hold test values
	
	.code
_start: 
	mov eax,-1					;dummy executable statement to aid in debugging.

main	proc					;beginning of the driver
	
	;Test length
	lea ebx, strTest1		;Get the address of the param
	push ebx				;Push the param
	call String_length		;Call the method
	add esp, 4				;Clean up the stack
	mov dVal, eax			;Move the return inot the variable
	INVOKE intasc32, addr strOut, dval	;convert the int to ascii
	tab						;Tab results
	INVOKE putstring, addr strTest5		;Display the prompt
	INVOKE putstring, addr strOut		;Display the length

	;test copy
	lea ebx, strTest1	;Load param address
	push ebx			;push the param
	call String_copy	;call the copy method
	add esp, 4			;clean up the stack
	mov ebx, eax		;store the address of the string
	
	INVOKE putstring, addr strTest6	;Display the string
	INVOKE putstring, ebx	;Display the string
	
	;test equals
	lea ebx, strTest1	;Load the param address
	push ebx			;push the param
	lea ebx, strTest2	;load the parameter address
	push ebx			;push the param
	call String_equals	;call the equals 
	add esp, 8			;clean up the stack
	
	.if eax == 0	;If the return is 0
		INVOKE putstring, addr strTest7	;Display result
	.else			;if return is 1
		INVOKE putstring, addr strTest8	;Display result
	.endif	;end the if
	
	;test eqCase
	lea ebx, strTest1	;load the param address
	push ebx			;push the param
	lea ebx, strTest2	;load the address of the next param
	push ebx			;push to the stack
	call String_equalsIgnoreCase	;call the equals method(ignore case)
	add esp, 8			;clean the stack up
	
	.if eax == 0	;If the return is 0
		INVOKE putstring, addr strTest9	;Display result
	.else			;if return is 1
		INVOKE putstring, addr strTest10	;Display result
	.endif	;end the if
	
	
	;test toUpper
	lea ebx, strTest1	;load the param address
	push ebx			;push the param
	call String_toUpperCase	;Call the upper case method
	add esp, 4			;clean up the stack
	mov ebx, eax		;mov the return to ebx
	tab					;tab the result
	INVOKE putstring, ebx	;Display the result
	
	;Test toLower
	lea ebx, strTest2	;Load the address of the string
	push ebx			;push the parameter
	call String_toLowerCase	;call the to lower case method
	add esp, 4			;clean up the stack
	mov ebx, eax		;mov address into ebx
	INVOKE putstring, ebx		;display the result
	
	;Testappened
	lea ebx, strTest4	;Load the parameter address
	push ebx			;Push the parameter onto the stack
	lea ebx, strTest3	;Load the parameter address
	push ebx			;Push the parameter
	call String_appends	;Call the appends method
	add esp, 8			;Clean up the stack
	newline					;Go to a new line
	INVOKE putstring, eax	;Display the new string
	
	
INVOKE ExitProcess,0				;terminate "normally" the program
main	endp							;end of the "driving program"
	PUBLIC _start
;any PROCs that you will add later go in here	
	
	END								;The very LAST line in your program. Terminate assembly