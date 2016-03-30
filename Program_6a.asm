TITLE Program_6a     (Program_6a.asm)

; Author:		Brian Stamm
; Email:		stammbr@onid.oregonstate.edu
; Course:		CS 271-400
; Assignment:	Assignment 6a
; Due Date:		7.7.15
; Description:	This is the final assignment, where the program asks the user
; for 10 numbers, gets the average and sum of those numbers, and then displays
; them back to user.  Oh, and it takes the input as a string, converts to an
; int and then back to a string.
; Citation:  I feel as if I used alot of the code in Paul2son's demos (6 thru 8
; were most used), and then I used the code from the lecture on Macros.   

INCLUDE Irvine32.inc

MIN = 0
MAX = 4294967295
MAXSTRING = 256

;Built off of lecture on Macro's
getString	MACRO prompt, varName
	push	ecx
	push	edx
	mov		edx, prompt
	call	WriteString
	mov		edx, varName
	mov		ecx, MAXSTRING-1
	call	ReadString
	pop		edx
	pop		ecx
ENDM

;Built off of lecture on Macro's
displayString	MACRO buffer
	push	edx
	mov		edx, buffer
	call	WriteString
	pop		edx
ENDM


.data

header_1		Byte		"Brian Stamm     ", 0
header_2		Byte		"Assignment 6a ", 0
instruct		Byte		"Hello!  This program will ask you for 10 numbers, and", 0
instruct_2		Byte		"the numbers have to be between 0 and 4,294,967,295.",0
instruct_3		Byte		"No commas needed.  Enjoy!",0

num_prompt		Byte		"Please enter an unsigned number: ",0
error_mes1		Byte		"Error.  You entered a number either too big, unsigned, or not a number",0
error_mes2		Byte		"Please try again.",0

list_prompt		Byte		"You entered the following numbers: ",0
sum_prompt		Byte		"The sum of these numbers are: ",0
ave_prompt		Byte		"The average of these numbers is: ",0
comma			Byte		", ",0

numberStr		Byte		256		DUP(0)
printStr		Byte		11		DUP(0)

array			Dword		10		DUP(0)		
userNum			Dword		0
sum				Dword		0
average			Dword		0
errorN			DWord		0


.code
main PROC

	push	OFFSET header_1			;24
	push	OFFSET header_2			;20
	push	OFFSET instruct			;16
	push	OFFSET instruct_2		;12
	push	OFFSET instruct_3		;+8
	call	introduction
	call	CrLf

	mov		ecx, 10
	mov		esi, OFFSET array
fillArray:
	push	ecx						;Saved for later, not used in readVal
	push	esi						;ditto
	push	MAX						;32
	push	MIN						;28
	push	OFFSET userNum			;24
	push	OFFSET errorN			;20
	push	MAXSTRING				;16
	push	OFFSET numberStr		;12
	push	OFFSET num_prompt		;8
	call	readVal					;Used to get get the value, and then check done in other procedures
	mov		eax, 1
	cmp		eax, errorN				;Used to check error
	je		errorLoop	
	pop		esi						;If not, then get the address of array
	mov		eax, userNum			;Saves number in an array
	mov		[esi], eax			
	add		esi, 4					;and move to next number
	pop		ecx
	loop	fillArray
	jmp		overError				;and Jump over when done with loop
errorLoop:
	displayString	OFFSET error_mes1	;Error message
	call	CrLf
	displayString	OFFSET error_mes2
	call	CrLf
	mov		errorN, 0				;And reset everything
	pop		esi
	pop		ecx
	jmp		fillArray				;And jump so not to mess with loop
overError:
	
	push	OFFSET sum				;+16
	push	OFFSET average			;+12
	push	OFFSET array			;+8
	call	mathTime
	
	call	CrLf
	
	push	OFFSET list_prompt		;+36
	push	OFFSET sum_prompt		;32
	push	OFFSET ave_prompt		;28
	push	OFFSET comma			;24
	push	sum						;20
	push	average					;16
	push	OFFSET printStr			;12
	push	OFFSET array			;8
	call	writeVal				
	
	call	CrLf
	
	exit

main ENDP

;This is introduction.  It prints out the greeting message and instructions
;receives:	Address of header_1, header_2, instruct, instruct_2, instruct_3.
;returns:	None.
;precond:	Needs a macro call displayString.
;registers changed:		None.

introduction	PROC

	push	ebp
	mov		ebp, esp
	
	displayString	[ebp+24]		;header_1
	displayString	[ebp+20]		;header_2
	call	CrLF
	call	CrLf
	displayString	[ebp+16]		;instruct
	call	CrLf
	displayString	[ebp+12]		;instruct_2
	call	CrLf
	displayString	[ebp+8]			;instruct_3
	call	CrLf

	pop		ebp
	ret		20
introduction	ENDP


;This is readVal, it gets the input from the user, then passes input to validString
; to check to make sure number, then passes to string2Int to see if number in range.
; If it clears, errorN not changed.  If there's an error, errorN was changed. 
;receives:	MAX, MIN, @userNum, @errorN, MAXSTRING, @numberStr, @num_prompt
;returns:	Can change @userNum, @errorN, @numberStr
;precond:	Needs macros getString, and needs validString & string2Int.  No pushing
; needed.
;registers changed:		eax, ebx.

readVal		PROC

	push	ebp
	mov		ebp, esp
	getString	[ebp+8], [ebp+12]		;num_prompt, numberStr
	call	validString
	mov	eax, 1							;Checks the errorN
	mov	ebx, [ebp+20]					;errorN
	cmp	eax, [ebx]
	je		endRV						;If error, just go to end
	call	string2Int
endRV:
	
	pop		ebp
	ret		28
readVal		ENDP

;This is validString.  It makes sure that all inputs are numbers
;receives:	retrieves off stack - @errorN, MAXSTRING, @numberStr
;returns:	Possibly changes to @errorN.
;precond:	Stack hasn't changed from readVal
;registers changed:		ecx, esi, edi, eax, edx, ebx

validString		PROC

	push	ebp
	mov		ebp, esp
	
	mov		ecx, [ebp+24]			;MAXSTRING
	mov		esi, [ebp+20]			;numberStr
	mov		edi, [ebp+20]			;numberStr again, to make sure still have the string
	cld
validCount:
	lodsb							;Loads a single byte into al reg
	cmp		al, 1					;Done to see if end of the string
	jl		valCheck
	cmp		al, "0"					;Compares each byte to ascii values, if above or below, error
	jb		notNumber
	cmp		al, "9"
	ja		notNumber
	stosb
	loop	validCount
	jmp		valCheck

notNumber:							;Loop to change errorN
	mov		edx, [ebp+28]			;errorN
	mov		ebx, 1
	mov		[edx], ebx				;Changes value of errorN
	jmp		valDone

valCheck:
	mov		ebx, 245				;Checkes the size of the int
	cmp		ebx, ecx				;if this big, it's out of range, checked pre-emptively
	jae		notNumber

valDone:
	pop		ebp
	ret								;Nothing put on stack, so nothing returned
validString		ENDP


;This makes a string into an int. 
;receives:	MAX, MIN, @userNum, @errorN, MAXSTRING, @numberStr.
;returns:	Possible changes to userNum and errorN
;precond:	Values pushed on stack stay the same from readVal.
;registers changed:		esi, ecx, edx, eax, ebx.
string2Int	PROC

	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+20]					;numberStr
	mov		ecx, [ebp+24]					;MAXSTRING
	xor		edx, edx						;Makes sure edx (and eax next) are 0 values
	xor		eax, eax
	cld										;sets the direction flag
loadString:
	lodsb									;Loads a single byte into al reg
	cmp  	eax, 0							;if 0, then done
	je   	finalCheck
	imul  	edx, edx, 10					;edx = edx*10
	sub  	eax, "0"						;subtracts ascii value of zero
	add  	edx, eax						;add together, continue loop
	loop 	loadString						

finalCheck:
	mov		ebx, [ebp+36]					;MIN
	cmp		edx, ebx
	jb		notNumber
	mov		ebx, [ebp+40]					;MAX
	cmp		edx, ebx
	ja		notNumber
	mov		ebx, [ebp+32]					;userNum
	mov		[ebx], edx						;Saves the value
	jmp		s2iDone
	
notNumber:
	mov		edx, [ebp+28]					;errorN
	mov		ebx, 1
	mov		[edx], ebx						;errorN changed

s2iDone:
	pop		ebp								
	ret										;No value because no values pushed
string2Int	ENDP


;This is mathTime.  It calculates the values.
;receives:	@sum, @average, @array.
;returns:	Changes to sum and average.
;precond:	Addresses of sum, average and array are pushed on stack.
;registers changed:		eax, esi, ecx, ebx, edx.
mathTime	PROC

	push	ebp
	mov		ebp, esp

	mov		eax, [ebp+16]			;sum address
	mov		esi, [ebp+8]			;OFFSET array	
	mov		ecx, 10					;since there's 10 values	
adding:
	mov		ebx, [esi]				;gets the sum
	add		[eax], ebx
	add		esi, 4
	loop	adding

	mov		edx, 0					;for remainder
	mov		ebx, [ebp+16]			;New value of sum moved
	mov		eax, [ebx]
	mov		ebx, 10					;Calc average
	div		ebx
	mov		ebx, [ebp+12]			;average
	mov		[ebx], eax				;Saves average

	pop		ebp
	ret		12
mathTime	ENDP


;This is writeVal, it will take the values, pass them to int2String and 
; then print off the new string.
;receives:	@list_prompt, @sum_prompt, @ave_prompt, @comma, sum, 
; average, @printStr, @array
;returns:	n/s, just prints values
;precond:	Everything pushed on stack in order, need to pass to i2s
;registers changed:		esi & ecx
writeVal	PROC

	push	ebp
	mov		ebp, esp

	displayString [ebp+36]				;OFFSET list_prompt
	
	mov		esi, [ebp+8]				;OFFSET array
	mov		ecx, 10
printLoop:
	push	ecx
	push	[ebp+12]					;Offset printStr
	push	[esi]						;value of array
	call	int2String
	displayString [ebp+12]				;displays OFFSET printStr
	add		esi, 4						;moves to next value in array
	pop		ecx
	cmp		ecx, 1						;To make sure comma not printed after last value
	je		noComma
	displayString	[ebp+24]			;OFFSET comma
noComma:
	loop	printLoop
	call	CrLf

	call	CrLf
	displayString [ebp+32]				;OFFSET sum_prompt
	push	[ebp+12]					;printStr
	push	[ebp+20]					;sum value
	call	int2String
	displayString [ebp+12]
	call	CrLf

	call	CrLf
	displayString [ebp+28] 				;OFFSET ave_prompt
	push	[ebp+12]					;printStr
	push	[ebp+16]					;average
	call	int2String
	displayString [ebp+12]
	call	CrLf
	
	pop		ebp
	ret		32
writeVal	ENDP


;This is int2String, which converts an integer a string.
;receives:	An integer and the @printStr
;returns:	change to printStr
;precond:	Needs stack not to change.
;registers changed:		eax, ebx, edx, ecx
int2String 	PROC 	
LOCAL 			holder:DWORD					;local value, to hold bytes
	
	mov  		eax, [ebp+8]					;Int to print
	mov  		ebx, 10
	xor  		ecx, ecx						;clears ecx, 0
divider:
	xor  		edx, edx						;clears edx 
	div  		ebx
	push  		edx								;each digit saved
	inc  		ecx								;to know how big string should be, used in conquer
	test 		eax, eax						;ZF is 1 if eax = 0
	jnz  		divider							;while eax not 0, continues loop
	mov  		edi, [ebp+12]					;OFFSET printStr
conquer:
	pop  		holder							;moves digit into the holder
	mov  		al, BYTE PTR holder				;moves value into al
	add  		al, "0"							;adds to ascii value of 0
	stosb										;stores value in printStr
	loop 		conquer
	mov  		al, 0							;Null character
	stosb

	ret  		8
int2String  	ENDP

END main
