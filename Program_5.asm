TITLE Project_5     (Project_5.asm)

; Author:		Brian Stamm
; Email:		stammbr@onid.oregonstate.edu
; Course:		CS 271-400
; Assignment:	5
; Due Date:		5.24.15
; Used 1 of 2 Grace Days on this assignment.
; Description:	This is a program filling an array and sorting it
; I am still working on this program and am using my 2 grace days
; to complete it.  This is a partial program.  The final program


INCLUDE Irvine32.inc

MIN = 10			; Constants, per assignment requirements
MAX = 200
LO = 100
HI = 999

.data

header_1		Byte		"Brian Stamm     ", 0
header_2		Byte		"Assignment 5 ", 0
instruct		Byte		"Hello!  This program will ask the user for a number, and then", 0
instruct_2		Byte		"fill an array with that many numbers.  The numbers will be random",0
instruct_3		Byte		"between 100 and 999.  Please select a number from 10 up to 200. ",0

num_prompt		Byte		"How many numbers: ",0
err_mes			Byte		"Not in range, please try again.",0
ran_mes			Byte		"The range is 10 up to 200.",0
num_space		Byte		"     ",0

title_arr		Byte		"The unsorted array is: ",0
title_sort		Byte		"The sorted array is: ",0
med_mes			Byte		"The median is:  ",0

request			Dword		?									; Number of the array
array			Dword		200			DUP(-1)					; Array
zero			Dword		0


.code
main PROC

	call	Randomize				;Done to get random numbers later in program

	;Intro procedure
	call	introduction			;Needs instructions

	;Getting number from user
	push	OFFSET request			;Works, and validates
	call	get_data

	;Filling the array
	push	OFFSET array			;Works, does fill and fills within the range
	push	request
	call	fill_array

	;Displaying array
	push	OFFSET title_arr
	push	zero
	push	OFFSET array
	push	request
	call	display_list
	call	CrLf
	call	CrLf

	;Sorting the Array
	push	OFFSET array
	push	request
	call	sort_array

	;Displaying the median
	push	OFFSET array
	push	request
	call	display_med
	call	CrLf
	call	CrLf

	;Displaying the sorted array
	push	OFFSET title_sort
	push	zero
	push	OFFSET array
	push	request
	call	display_list
	call	CrLf
	call	CrLf

	exit	; exit to operating system
main ENDP

;This is the introduction for the user
;receives:	None, using global variables
;returns:	None.
;precond:	None
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


;This is get_data, it asks user for number and stores the value.
;receives:	Address of request through stack.
;returns:	Changes value of request
;precond:	Adress of request is pushed on stack.  Global variables used
; to check range.
;registers changed:	edx, eax, ebx
get_data	PROC

	push	ebp				;Sets up registers
	mov		ebp, esp

inval:
	mov		edx, OFFSET num_prompt		;Prints prompts
	call	WriteString
	call	ReadInt
	cmp		eax, MIN					;compares if in range, if so, error message
	jl		err_lp
	cmp		eax, MAX
	jg		err_lp

	mov		ebx, [ebp+8]				;if not, saves value
	mov		[ebx], eax
	call	CrLf
	jmp		end_gd

err_lp:
	mov		edx, OFFSET err_mes			;Error message
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET	ran_mes
	call	WriteString
	call	CrLf
	jmp		inval

end_gd:
	pop		ebp
	ret		4	
get_data	ENDP


;This is fill_array.  It fills the array with random numbers within 
;given range.
;receives:	Via stack, address of array and request.  Via global
; variables, hi and lo.
;returns:	Filled array
;precond:	Address of array and value of request pushed on stack, in
; that order
;registers changed:  esi, ecx, eax	
;Citation:  Idea of this was gotten from lecture 20
fill_array		PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]
	mov		ecx, [ebp+8]

fill_loop:
	mov		eax, HI
	sub		eax, LO
	inc		eax
	call	RandomRange
	add		eax, LO
	mov		[esi], eax
	add		esi, 4
	loop	fill_loop
	
	pop		ebp
	ret		8		
fill_array		ENDP


;  This is sort_array.  It sorts the elements in the array using the bubble
;sort found in textbook (p 375)
;receives:		Via stack, it receives address of array and request.
;returns:		Sorted array.
;precond:		Address of array and request placed in stack, in that order.
;registers changed:  ecx, esi, eax, edx	
sort_array	PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]		;Sets up counter for outside loop
	dec		ecx

loopy:
	mov		esi,[ebp+12]		;sets starting address for comparisons
	push	ecx					;pushes value of loop counter on stack

doopy:
	mov		eax, [esi]			;compares array[i] to array[i+1]
	cmp		[esi+4], eax
	jl		skip
	mov		edx, [esi+4]		;Swaps them if one larger
	mov		[esi+4], eax
	mov		[esi], edx

skip:
	add		esi, 4				;moves to next element and loops
	loop	doopy

	pop		ecx					;starts over again to continue bubbling.
	loop	loopy

	pop		ebp
	ret		8	
sort_array	ENDP


;This is display_med.  It will display the median value.  If even number of
; elements, then it will take the two middle values and average them together.
;receives:	Via stack, the address of array and request, in that order.  Also
; prints off message from global variables.
;returns:	Displays the median of the array, no changes in variable values
;precond:	address of array and request must be on stack
;registers changed:	esi, eax, edx, ebx
display_med	PROC
	push	ebp						;Sets up registers
	mov		ebp, esp
	mov		esi, [ebp+12]			;puts address of array
	mov		eax, [ebp+8]			;request
	
	mov		edx, OFFSET med_mes		;Prints message
	call	WriteString
	mov		edx, 0					;cleared for dividing

	mov		ebx, 2
	div		ebx
	cmp		edx, 0					;Sees if even or odd
	jne		odd_med
	
	;This is if result is even
	mov		ebx, 4				;Gets two values in array
	mul		ebx
	mov		ebx, eax
	sub		eax, 4				;subtracts, becuas array starts at address 0
	mov		edx, eax
	mov		eax, [esi+edx]		;Gets the values and adds together
	mov		edx, [esi+ebx]
	add		eax, edx
	mov		edx, 0				;Then gets average
	mov		ebx, 2
	div		ebx
	call	WriteDec
	jmp		end_med

odd_med:				;This is if the result is odd
	mov		ebx, 4
	mul		ebx
	mov		ebx, eax
	mov		eax, [esi+ebx]	;Times result by 4 and then goes to that element
	call	WriteDec

end_med:
	pop		ebp
	ret		8	
display_med	ENDP


;This is display_list.  It displays the elements in the array.
;receives:			num_space - string of spaces
;returns:			Prints off all elements in array.
;precond:			Items on stack, in this order and starting at 0:
; return @, request, @ array, zero, @ title.
;registers changed:	esp, esi, ecx, ebx, edx, eax
display_list	PROC
	push	ebp					;Sets up registers
	mov		ebp, esp
	mov		esi, [ebp+12]		;@ array
	mov		ecx, [ebp+8]		;request
	mov		ebx, [ebp+16]		;zero
	mov		edx, [ebp+20]		;@ Title 
	call	WriteString
	call	CrLf

print:
	mov		eax, [esi]			;Moves number in array
	call	WriteDec
	add		esi, 4				;Increase address by dword
	
	mov		edx, 0				;clears edx
	inc		ebx					;increase ebx, used for counting elements in row
	push	ebx					;saves value
	mov		eax, ebx			;moves value so can divide
	mov		ebx, 10				;moves ten into ebx and divide
	div		ebx
	cmp		edx, 0				;sees if there's a remainder
	jne		no_nline
	call	CrLf				;If no remainder (divisible by 10), new line
	pop		ebx 
	loop	print
	jmp		end_dis
no_nline:
	mov		edx, OFFSET num_space	;else, puts space bt numbers, continues loop
	call	WriteString
	pop		ebx					;pops value, counter of elements
	loop	print

end_dis:	
	pop		ebp
	ret		16	
display_list	ENDP

END main