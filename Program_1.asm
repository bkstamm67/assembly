TITLE Program_1     (Program_1.asm)

; Author:		Brian Stamm
; Email:		stammbr@onid.oregonstate.edu
; Course:		CS 271-400
; Assignment:	01
; Due Date:		4.12.15
; Description:  This program follows the guidelines for assignment 1 - it
; has an introduction, gets 2 numbers from user, then displays those numbers
; used in various math calculations.  Then a closing.  Nice, huh?

INCLUDE Irvine32.inc

; Constants would go here, but there are none

;Below are the various variables used in the program, explanations w
.data

userNum_1	DWORD	?			;integer's to be entered by user
userNum_2	DWORD	?
a_result	DWORD	?			;following are int's derived from users numbers
s_result	DWORD	?
m_result	DWORD	?
d_result	DWORD	?
rd_result	DWORD	?
intro_1		BYTE	"Brian Stamm     ", 0		;Following are what program prints out
intro_2		BYTE	"Assignment 1 " , 0
direct_1	BYTE	"This program will ask for 2 numbers, and then sum, subtract, multiple and divide the numbers. ", 0
prompt_1	BYTE	"First Number: ", 0
prompt_2	BYTE	"Second Number: ", 0
equal		BYTE	" = ", 0
plus		BYTE	" + ", 0
minus		BYTE	" - ", 0
multiple	BYTE	" x ", 0
divide		BYTE	" / ", 0
remainder	BYTE	" remainder ", 0
goodBye		BYTE	"Impressive, huh?  Good-bye! ", 0

;Code block for program
.code
main PROC

; Introduction & Directions - First has name and assignment, then strings explaining program
	mov		edx, OFFSET intro_1
	call	WriteString
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf		;2 used to seperate programmer name and instructions, readability
	call	CrLf
	mov		edx, OFFSET direct_1
	call	WriteString
	call	CrLf		;readability
	call	CrLf

; Prompt for numbers - get the data and save to respective variables, userNum_1 & userNum_2
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		userNum_1, eax
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		userNum_2, eax
	call	CrLf

; Calculate the required values
	; Add, and saves to a_result
	mov		eax, userNum_1
	add		eax, userNum_2
	mov		a_result, eax
	
	; Subtraction, and saves to s_result
	mov		eax, userNum_1
	sub		eax, userNum_2
	mov		s_result, eax

	; Multiple, and saves to m_result
	mov		eax, userNum_1
	mov		ebx, userNum_2
	mul		ebx
	mov		m_result, eax

	; Divide, and saves to d_result with remainder in rd_result
	mov		eax, userNum_1
	cdq
	mov		ebx, userNum_2
	div		ebx
	mov		d_result, eax
	mov		rd_result, edx

; Display results for each block above.
	; Addition
	mov		eax, userNum_1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, userNum_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, a_result
	call	WriteDec
	call	CrLf

	; Subtraction
	mov		eax, userNum_1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, userNum_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, s_result
	call	WriteDec
	call	CrLf

	; Multiplication
	mov		eax, userNum_1
	call	WriteDec
	mov		edx, OFFSET multiple
	call	WriteString
	mov		eax, userNum_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, m_result
	call	WriteDec
	call	CrLf
	
	; Division
	mov		eax, userNum_1
	call	WriteDec
	mov		edx, OFFSET divide
	call	WriteString
	mov		eax, userNum_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, d_result
	call	WriteDec
	mov		edx, OFFSET remainder
	call	WriteString
	mov		eax, rd_result
	call	WriteDec
	call	CrLf
	call	CrLf

; Say Goodbye - prints a farewell statement
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; No addition procedures needed, end of program.

END main