TITLE Program_3     (Program_3.asm)

; Author:		Brian Stamm
; Email:		stammbr@onid.oregonstate.edu
; Course:		CS 271-400
; Assignment:	Program_3
; Due Date:		May 3rd, 2015
; Description:	This program will greet the user, display some instructions, adds users
; inputted numbers as long as it is negative.  Once a positive number is entered, then
; it stops adding to the total and displays the sum, average, and total numbers enter.  

INCLUDE Irvine32.inc

; CONSTANTS

MIN_NUM = -100			; Constant, min number user allowed
MAX_NUM	= -1			; Constant, max number user allowed

.data
																	;Variables for header & beginning
intro_1		Byte		"Brian Stamm     ", 0
intro_2		Byte		"Assignment 3 ", 0
getUserName	Byte		"What is your name: ", 0
userName	Byte		33 DUP(0)
																	;Greeting variables
hello		Byte		"Hello, ", 0
welcome		Byte		" nice to meet you!  Welcome to my 3rd Program!", 0
instruct_1	Byte		"This program will sum up the numbers you enter from -100 to -1.", 0
instruct_2	Byte		"When you're done, enter a positive number (zero is positive).", 0

																	;Get Input
userNum		SDword		?
enterNum	Byte		"Enter number: ", 0
																	;Results Section & Error
results		Byte		"Here are the results: ",0
result_tot	Byte		"How many numbers entered: ", 0
result_sum	Byte		"Sum of numbers entered: ", 0
result_ave	Byte		"Rounded Average of numbers entered: ", 0
error_mes1	Byte		"Sorry, value was too low.  Try again.", 0
																	;Numbers
sum			SDword		0
aver		SDword		?
counter		Dword		?
remainder	Dword		?
two			SDword		-2
remain_2	Dword		?
																	;Farewell portion
thanks		Byte		"Thanks, ", 0
ending		Byte		" for using my program.  Hope you enjoyed it!", 0
farewell	Byte		"Goodbye!", 0

.code
main PROC

; Introduction
	; Title lines
	
	mov		edx, OFFSET intro_1
	call	WriteString
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf

	; Prompt User Name & saves name
	
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

	; Get numbers - validation check of input, keeps running total and count for total correct numbers inputted

input:		; Block asks user for number and saves to userNum
	mov		edx, OFFSET enterNum
	call	WriteString
	call	ReadInt
	mov		userNum, eax
	call	CrLf

	; Checks input to max and min amount allowed
	cmp		userNum, MIN_NUM		; compares user number to lowest number
	jl		err_mes					; jumps to error message if too low
	cmp		userNum, MAX_NUM		; then compares to makes number allowed
	jg		display					; if too high (i.e a positive number), goes to display results
	jmp		total					; If number is in range, does minor calculations
	
	; Error Message 
err_mes:
	mov		edx, OFFSET error_mes1
	call	WriteString
	call	CrLf
	jmp		input					;jumps back to get a correct input
	
	; Calculate sum
total:
	mov		ebx, sum				; adds number to SUM variable
	add		ebx, userNum
	mov		sum, ebx
	inc		counter					;increase counter to keep track of how many rounds done
	jmp		input					;jumps back to input to do again
	
	; Show Results - Shows user results of numbers inputted

display:
	cmp		counter, 0					; Special case, no negative numbers were entered
	je		closing						; if so, jump to the end

	mov		eax, counter				;Else, first block of calculations 
	cdq									; determines the 1/2 value of the remainder
	idiv	two							; and saves to variable remain_2
	mov		remain_2, eax
	
	mov		edx, OFFSET results			; Displays Title
	call	WriteString
	call	CrLf
	call	CrLf
	
	mov		edx, OFFSET	result_tot		; Displays Total Numbers Entered Value
	call	WriteString
	mov		eax, counter
	call	WriteInt
	call	CrLf
	
	mov		edx, OFFSET	result_sum		; Displays the Sum of the Numbers
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf
	
	mov		eax, sum					; another calculate block
	cdq									; gets average of numbers inputted
	idiv	counter 
	mov		aver, eax
	mov		remainder, edx				;and saves remainder as well

	mov		eax, remainder				; this block compares the two remainders
	cmp		eax, remain_2				
	jae		print						; if remainder less then or equal, just goes to print block
	dec		aver						; if remainder greater than, then rounds up, then moves foward
	
print:
	mov		edx, OFFSET	result_ave		; Displays the Average of the Numbers
	call	WriteString
	mov		eax, aver
	call	WriteInt
	call	CrLf

	;Ending, thanks and goodbye

closing:
	call	CrLf
	call	CrLf
	mov		edx, OFFSET thanks
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET ending
	call	WriteString
	call	CrLf
	mov		edx, OFFSET farewell
	call	WriteString
	call	CrLf
	call	CrLf

	exit	; exit to operating system
main ENDP


END main