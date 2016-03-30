TITLE Program_2     (Program_2.asm)

; Author:		Brian Stamm
; Email:		stammbr@onid.oregonstate.edu
; Course:		CS 271-400
; Assignment:	02
; Date:			4.19.15
; Description:	Obtains the user's name, greets them, and then gives the user
; a brief description of the program.  Asks for how far down the Fib sequence
; they would like to go, and then prints off the result.

INCLUDE Irvine32.inc

UPPER = 46		;Constant, upper limit of number user can input 	

.data

intro_1		Byte	"Brian Stamm     ", 0
intro_2		Byte	"Assignment 2 ", 0

getUserName	Byte	"What is your name: ", 0
userName	Byte	33 DUP(0)
hello		Byte	"Hello, ", 0
welcome		Byte	" nice to meet you!  Welcome to my program.", 0
instruct_1	Byte	"This program will display the total number of Fibonacci",0
instruct_2	Byte	"numbers you want to see.  Pick between 1 and 46.", 0
select		Byte	"How many Fibonacci numbers: ", 0
uFibNum		Dword	?											; user inputed number
fibA		Dword	1											; used to calculate the Fib sequence 
fibB		Dword	1											
counter		Dword	0											; variable to set counter to zero
five		Dword	5											; variable to compare to five
space		Byte	"     ", 0									; used for spacing with numbers
error		Byte	"Sorry, that number was too high.  Remember, between 1 and 46.", 0		;error message
result		Byte	"That's the results.", 0
goodbye		Byte	"Goodbye, ", 0

.code
main PROC

; Introduction
	; Title line, Brian & Assignment
	mov		edx, OFFSET intro_1
	call	WriteString
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf

	; Get User Name and save to variable
	mov		edx, OFFSET getUserName
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString
	call	CrLf

	; Welcomes user
	mov		edx, OFFSET hello
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET welcome
	call	WriteString
	call	CrLf

; userInstructions, prints basic instructions for user
	mov		edx, OFFSET instruct_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	instruct_2
	call	WriteString
	call	CrLf
	call	CrLf

; getUserData, to get the Fib number from user
notValid:
	mov		edx, OFFSET select
	call	WriteString
	call	ReadInt
	mov		ufibNum, eax
	call	CrLf
	cmp		ufibNum, UPPER			;compares user number to upper, will loop if too big
	jbe		math					; if not will jump to next section
a2:	
	mov		edx, OFFSET error		; prints error message
	call	WriteString
	call	CrLf
	jmp		notValid



; displayFibs
math:								; start by setting up registers
	mov		ecx, ufibNum
	dec		ecx
	mov		eax, fibA
	call	WriteDec
	mov		edx, OFFSET	space
	call	WriteString

top:								; then creates loop to calculate fib number
	mov		eax, fibA
	mov		ebx, fibB
	add		eax, ebx
	mov		fibA, ebx
	mov		fibB, eax
	mov		eax, fibA
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString				;prints the number

	; now creates counter to ensure only 5 numbers printed on a line
	inc		counter
	mov		counter, eax				
	mov		edx, 0
	div		five					; if counter is divisible by 5, new line
	cmp		edx, 0;
	jne		b1
	call	CrLf
b1:
	
	loop	top

; farewell to user
	call	CrLf
	call	CrLf
	mov		edx, OFFSET result
	call	WriteString
	;mov		eax, sum
	;call	WriteDec
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf

	exit	; exit to operating system
main ENDP

END main