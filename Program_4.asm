TITLE Program_4     (Program_4.asm)

; Author:		Brian Stamm
; Email:		stammbr@onid.oregonstate.edu
; Course:		CS 271-400
; Assignment:	Assignment 4
; Due Date:		May 10th, 2015
; Description:	This program gets a number from the user, and then displays all the composite numbers
; from 1 to the number selected.  It also does error checking on the number to make sure it is within
; a given range.

INCLUDE Irvine32.inc

UPPER_LIMIT = 400			; Constant, the upper range allowed

.data

header_1		Byte		"Brian Stamm     ", 0
header_2		Byte		"Assignment 4 ", 0
instruct		Byte		"Hello!  This program will display composite numbers.", 0
instruct_2		Byte		"After picking a number between 1 and 400, the program ",0
instruct_3		Byte		"will then print all the composite numbers up to that number.",0

userNumber		Dword		?
num_prompt		Byte		"Enter number: ", 0
truth			Dword		0
errorMes_1		Byte		"Sorry, number not in range.  Try again.", 0
errorMes_2		Byte		"Remember, from 1 up to & including 400.", 0

comNum			Dword		1
sc_count		Dword		0
ten				Dword		10
spaces			Byte		"   ", 0

goodBye			Byte		"Thanks, and goodbye!", 0

.code
main PROC

	call	introduction

	call	getUserData
	
	call	showComposites
	
	call	farewell

	exit	; exit to operating system
main ENDP

;This is the introductions for the user
;receives:			none
;returns:			none
;precond:			none
;registers changed:	edx - used for printing statements

introduction	PROC
	
	;Header for the program
	mov		edx, OFFSET header_1
	call	WriteString
	mov		edx, OFFSET	header_2
	call	WriteString
	call	CrLf
	call	CrLf
			
	;Basic Instructions
	mov		edx, OFFSET instruct
	call	WriteString
	call	CrLf

	mov		edx, OFFSET instruct_2
	call	WriteString
	call	CrLf

	mov		edx, OFFSET instruct_3
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introduction	ENDP


;This is getting the data from the user
;receives:			none
;returns:			userNumber
;precond:			none
;registers changed:	edx, eax

getUserData		PROC

obtain:
	mov		edx, OFFSET num_prompt		;Prompts for number
	call	WriteString
	call	ReadInt
	mov		userNumber, eax
	call	validate					;Then calls procedure to check if in range

	cmp		truth, 0					;If not, continues to prompt for number
	je		obtain

	ret
getUserData		ENDP


;This validates the number inputted by user is in the right range
;receives:			userNumber
;returns:			truth value - a boolean variable
;precond:			user inputted number
;registers changed:	eax, edx as well if not in range

validate		PROC
	cmp		userNumber, UPPER_LIMIT		;Checks the top of range first
	jg		error		
	cmp		userNumber, 0				;then bottom
	jle		error
	mov		eax, 1						;if okay, changes boolean variable and goes to end
	mov		truth, eax
	jmp		finish
error:									;if not okay, then prints error message
	mov		edx, OFFSET errorMes_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET errorMes_2
	call	WriteString
	call	CrLf
	call	CrLf
	mov		eax, 0
	mov		truth, eax					;and makes boolean false
finish:
	ret
validate		ENDP


;This is showComposites, it prints off the composite numbers
;receives:			userNumber
;returns:			composites up to userNumber
;precond:			entered valid number
;registers changed:	eax, edx, ecx

showComposites	PROC

	call	CrLf		;Puts some space
	call	CrLf
	
	mov		ecx, userNumber		;Starts counter for loop, using userNumber
beginSC:
	call	isComposite			;calls procedure to check if composite
	cmp		truth, 0			;checks boolean if it is
	jne		process				;if it is, goes to label process
	inc		comNum				;if it's not, increases comNum
	loop	beginSC				;and loops until it equals user's
	jmp		endSC				;at end, jumps to end of procedure

process:
	inc		sc_count			;variable to keep 10 numbers per line
	mov		eax, comNum			;Prints composite number
	call	WriteDec
	mov		edx, OFFSET spaces
	call	WriteString

	mov		edx, 0				;Checks if there's been 10 numbers in the line
	mov		eax, sc_count
	div		ten
	cmp		edx, 0				;if so, starts new line, if not, continues loop
	jne		next
	call	CrLf
next:
	inc		comNum
	loop	beginSC
endSC:
	call	CrLf
	ret
showComposites	ENDP


;This shows isComposite, which checks if number is a composite number
;receives:			comNum
;returns:			boolean variable
;precond:			made it to this point in the program
;registers changed:	ebx, eax, edx
isComposite		PROC

	mov		ebx, 2			;starts with 2 for dividing
	mov		eax, 0
	mov		truth, eax		;resets the truth variable

	mov		eax, 3			;if number 3 or less then, it's not composite
	cmp		comNum, eax
	jle		endIC

topIC:
	mov		eax, comNum		;divides comNum by all numbers between 2 and it
	mov		edx, 0			;if no remainder, then composite and change
	cmp		eax, ebx		; truth value, otherwise, doesn't
	je		endIC
	div		ebx
	cmp		edx, 0
	je		found
	inc		ebx
	jmp		topIC
found:
	mov		eax, 1
	mov		truth, eax
endIC:
	ret
isComposite		ENDP


;This is farewell.
;receives:			none
;returns:			none
;precond:			Has gone through the program
;registers changed:	edx
farewell		PROC

	call	CrLf
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf
	call	CrLf

	ret
farewell		ENDP

END main