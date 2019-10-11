;******************************************************************************************
;Program Name: proj5a.asm
;Programmer:   Colin Kelley
;Class:        CSCI 2160-001
;Date:         November 17, 2018 at 5:00 PM
;Purpose:	This file contains various methods to test or manipulate strings
;
;******************************************************************************************

	.486
	.model flat
	
	memoryallocBailey	PROTO NEAR32 stdcall, dSize:dword
	
	.code
COMMENT %
;*****************************************************************************************
;* Name:  String_length																	 *
;* Purpose:	Accepts the address of a string and returns the number of non-null characters*			 															 
;*																						 *
;* Date created: November 15, 2018 at 1:00 PM		 
;* Date last modified:	November 15, 2018 at 1:00 PM 			 
;*																						 *
;* Notes:	None																		 *
;*																						 *
;*	@param 	lpStringInQuestion:dword													 *
;*	@return dword	
;*
;*****************************************************************************************%	
String_length proc Near32
	push ebp		;Preserve ebp
	mov ebp, esp	;Start a new stack frame
	push ebx		;Preserve ebx
	push esi		;Preserve esi
	
	mov ebx, [ebp+8]	;Save the address
	mov esi, 0			;Set the index to 0
lengthLoop:
	cmp byte ptr[ebx+esi], 0	;See if char is null
	je done		;if so then we are done
	inc esi			;Inc index
	jmp lengthLoop	;loop back
done:
	mov eax, esi	;Move length into eax
	pop ebx			;Restore ebx
	pop	esi			;restore esi
	pop ebp			;restore ebp
	RET				;return
String_length endp

COMMENT %
;*****************************************************************************************
;* Name:  String_copy																	 *
;* Purpose:	Accepts the address of a string and makes a deep copy. Returns address of copy*			 															 
;*																						 *
;* Date created: November 15, 2018 at 1:00 PM		 
;* Date last modified: November 15, 2018 at 1:00 PM			 
;*																						 *
;* Notes:	None																		 *
;*																						 *
;*	@param 	lpStringOriginal:dword														 *
;*	@return dword	
;*****************************************************************************************%
String_copy proc Near32
	push ebp		;Preserve ebp
	mov ebp, esp	;Start a new stack frame
	push ebx		;Preserve ebx
	push edx		;Preserve edx
	push esi		;Preserve esi
	
	mov ebx, [ebp+8]	;save address of string
	
	push ebx			;Push the parameter
	call String_Length	;Get the length of the string
	pop ebx				;Get address back
	
	inc eax		;Inc to make space for NULL
	INVOKE memoryallocBailey,eax ;Create a new memory block
	mov edx, eax		;Save new address
	
	mov esi, 0		;Make sure esi is set to 0 for the offset
	
beginLoop:
	mov al, byte ptr[ebx+esi]		;Move the character into al
	mov byte ptr[edx+esi], al		;Copy into destination string
	cmp byte ptr[edx+esi], 0		;See if last byte is null
	je done			;Jump if the final character is null
	inc esi			;Increment index
	jmp beginLoop	;Return to beginning of loop
	
done:
	mov eax, edx	;Mov the address into eax
	pop esi	;restore esi
	pop edx	;restore edx
	pop ebx	;restore ebx
	pop ebp	;restore ebp
	RET		;Return
String_copy endp

COMMENT %
;*****************************************************************************************
;* Name:  String_equals																	 *
;* Purpose:	This method accepts the addresses of two string and compares to see if equal.
;*						Case sensitive!		 															 
;*																						 *
;* Date created: November 15, 2018 at 1:00 PM	 
;* Date last modified: 	November 15, 2018 at 1:00 PM		 
;*																						 *
;* Notes:	None																		 *
;*																						 *
;*	@param 	lpStringOne:dword															 *
;*	@param	lpStringTwo:dword
;*	@return byte	
;*****************************************************************************************%
String_equals proc Near32
	push ebp		;Preserve ebp
	mov ebp, esp	;Start a new stack frame
	push ebx		;preserve ebx
	push edx		;preserve edx
	
	mov ebx, [ebp+8]	;get the first address
	mov edx, [ebp+12]	;get the second address
	
	mov esi, 0		;Use esi as index
compareLoop:
	mov al, byte ptr[ebx+esi]		;Move the character into al
	mov ah, byte ptr[edx+esi]		;Move a character into ah
	cmp al, ah			;See if characters are equal
	jne notEqual		;Jumps if !=
	cmp al, 0			;See if they are null
	je equal			;Jump if null
	inc esi				;Add one to esi
	jmp compareLoop		;Loop back to loop

equal:	
	mov eax, 1			;If they are equal return 1
	jmp done			;Skip notEqual
	
notEqual:
	mov eax, 0			;Return 0	
done:
	pop edx			;restore edx
	pop	ebx			;restore ebx
	pop ebp			;Restore ebp
	RET				;Return
String_equals endp

COMMENT %
;*****************************************************************************************
;* Name:  String_equalsIgnoreCase														 *
;* Purpose: This method accepts the addresses of two string and compares to see if equal.
;*						Not case sensitive!				 															 
;*																						 *
;* Date created: November 15, 2018 at 1:00 PM	 
;* Date last modified: 	November 15, 2018 at 1:00 PM		 
;*																						 *
;* Notes:	None																		 *
;*																						 *
;*	@param 	lpStringOne:dword															 *
;*	@param	lpStringTwo:dword
;*	@return byte
;*****************************************************************************************%
String_equalsIgnoreCase proc Near32
	push ebp		;Preserve ebp
	mov ebp, esp	;Start a new stack frame
	push ebx		;Preserve ebx
	push edx		;Preserve edx
	
	mov ebx, [ebp+8]	;get the first address
	mov edx, [ebp+12]	;get the second address
	
	mov esi, 0		;Use esi as index
compareLoop:
	mov al, byte ptr[ebx+esi]		;Move the character into al
	mov ah, byte ptr[edx+esi]		;Move a character into ah
	cmp al, ah	 ;See if characters are the same
	jne checkLetters	;Jumps if !=
	cmp al, 0			;See if they are null
	je equal			;Jump if null
	inc esi				;Add one to esi
	jmp compareLoop		;Loop back to loop
	
	
checkLetters:
	
	.if al < 5Bh	;check if al is uppercase
		add al, 20h	;if it is add 20h
	.endif			;end statement
	.if ah < 5Bh	;check if ah is uppercase
		add ah, 20h	;if then add 20h
	.endif			;end statment
	
	inc esi			;Increment esi
	cmp al,ah		;Compare to see if they are equal
	jne notEqual	;if they are not then jump
	jmp compareLoop	;loop back otherwise

equal:	
	mov eax, 1			;If they are equal return 1
	jmp done			;Skip notEqual
	
notEqual:
	mov eax, 0			;Return 0	
done:
	pop	edx 		;Restore edx
	pop	ebx			;restore ebx
	pop ebp			;Restore ebp
	RET				;Return
String_equalsIgnoreCase endp

COMMENT %
;*****************************************************************************************
;* Name:  String_toUpperCase															 *
;* Purpose:	Makes a deep copy of a provided string but all capitalized			 															 
;*																						 *
;* Date created: November 15, 2018 at 1:00 PM		 
;* Date last modified: November 15, 2018 at 1:00 PM			 
;*																						 *
;* Notes:	None																		 *
;*																						 *
;*	@param 	lpStringOriginal:dword														 *
;*	@return dword	
;*****************************************************************************************%
String_toUpperCase proc Near32
	push ebp		;Preserve ebp
	mov ebp, esp	;Start a new stack frame
	push ebx		;Preserve ebx
	push edx		;Preserve edx
	push esi		;Preserve esi
	
	mov ebx, [ebp+8]	;save address of string
	
	push ebx			;Push the parameter
	call String_Length	;Get the length of the string
	pop ebx				;Get address back
	
	inc eax		;Inc to make space for NULL
	INVOKE memoryallocBailey,eax ;Create a new memory block
	mov edx, eax		;Save new address
	
	mov esi, 0		;Make sure esi is set to 0 for the offset
	
beginLoop:
	mov al, byte ptr[ebx+esi]		;Move the character into al
	.if al > 60h	;check if al is lowercase
		.if al < 7Bh	;If it is then see if less than 5A
		sub al, 20h	;if it is add 20h
		.endif		;End if 
	.endif
	mov byte ptr[edx+esi], al		;Copy into destination string
	cmp byte ptr[edx+esi], 0		;See if last byte is null
	je done			;Jump if the final character is null
	inc esi			;Increment index
	jmp beginLoop	;Return to beginning of loop
	
done:
	mov eax, edx	;Return the address of the new string

	pop esi	;restore esi
	pop edx	;restore edx
	pop ebx	;restore ebx
	pop ebp	;restore ebp
	RET
String_toUpperCase endp

COMMENT %
;*****************************************************************************************
;* Name:  String_toLowerCase															 *
;* Purpose:	Makes a deep copy of a provided string but all lowercase			 															 
;*																						 *
;* Date created: November 15, 2018 at 1:00 PM		 
;* Date last modified: November 15, 2018 at 1:00 PM			 
;*																						 *
;* Notes:	None																		 *
;*																						 *
;*	@param 	lpStringOriginal:dword														 *
;*	@return dword	
;*****************************************************************************************%
String_toLowerCase proc Near32
	push ebp		;Preserve ebp
	mov ebp, esp	;Start a new stack frame
	push ebx		;Preserve ebx
	push edx		;Preserve edx
	push esi		;Preserve esi
	
	mov ebx, [ebp+8]	;save address of string
	
	push ebx			;Push the parameter
	call String_Length	;Get the length of the string
	pop ebx				;Get address back
	
	inc eax		;Inc to make space for NULL
	INVOKE memoryallocBailey,eax ;Create a new memory block
	mov edx, eax		;Save new address
	
	mov esi, 0		;Make sure esi is set to 0 for the offset
	
beginLoop:
	mov al, byte ptr[ebx+esi]		;Move the character into al
	.if al > 40h	;check if al is uppercase
		.if al < 5Bh	;If it is then see if less than 5A
		add al, 20h	;if it is add 20h
		.endif		;End if 
	.endif
	mov byte ptr[edx+esi], al		;Copy into destination string
	cmp byte ptr[edx+esi], 0		;See if last byte is null
	je done			;Jump if the final character is null
	inc esi			;Increment index
	jmp beginLoop	;Return to beginning of loop
	
done:
	mov eax, edx	;Return the address of the new string
	
	pop esi	;restore esi
	pop edx	;restore edx
	pop ebx	;restore ebx
	pop ebp	;Restore ebp
	RET		;return
String_toLowerCase endp

COMMENT %
;*****************************************************************************************
;* Name:  String_appends															 	 *
;* Purpose:	Takes two strings and appends them together into a new string. Returns the 
;*			address of said string			 															 
;*																						 *
;* Date created: November 15, 2018 at 1:00 PM		 
;* Date last modified: November 15, 2018 at 1:00 PM			 
;*																						 *
;* Notes:	None																		 *
;*																						 *
;*	@param 	lpStringOne:dword														     *
;*	@param 	lpStringTwo :dword
;*	@return dword	
;*****************************************************************************************%
String_appends proc Near32
	push ebp		;Preserve ebp
	mov ebp, esp	;Set a new stack frame
	push ebx		;Preserve ebx
	push ecx		;Preserve ecx
	push edx		;Preserve edx
	push esi		;Preserve esi
	
	mov ebx, [ebp+8]	;save address of string
	mov edx, [ebp+12]	;Save second string address
	
	push ebx			;Push the parameter
	call String_Length	;Get the length of the string
	pop ebx				;Get address back
	
	mov ecx, eax		;Move the length into ecx
	push edx			;Push the parameter
	call String_Length	;Get the length of the string
	pop edx				;Get address back
	
	add eax, ecx		;Add the two sizes together 
	
	inc eax		;Inc to make space for NULL
	INVOKE memoryallocBailey,eax ;Create a new memory block
	
	mov esi, 0		;Set the index to 0
	
beginLoop:
	cmp byte ptr[ebx+esi], 0		;See if last byte is null
	je nextString			;Jump if the final character is null
	mov cl, byte ptr[ebx+esi]		;Move the character into al
	mov byte ptr[eax+esi], cl		;Copy into destination string
	inc esi			;Increment index
	jmp beginLoop	;Return to beginning of loop
nextString:	
	mov ebx, 0	;Use ebx to index
nextLoop:
	mov cl, byte ptr[edx+ebx]		;Move the character into al
	mov byte ptr[eax+esi], cl		;Copy into destination string
	cmp byte ptr[eax+esi], 0		;See if last byte is null
	je done			;Jump if the final character is null
	inc ebx			;Increment index
	inc esi			;Increment index
	jmp nextLoop	;Return to beginning of loop	
	
done:
	pop esi	;Restore
	pop	edx	;Restore
	pop ecx	;Restore
	pop ebx	;Restore
	pop ebp		;Restore ebp
	RET			;Return
String_appends endp
	END