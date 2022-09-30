.global _start

arr: 	.word 69,-22,35,12,-40,70
n: 		.word 6
_start:

	LDR R0,=arr //R0=pointer to array 
	LDR R1,n //R1=lenght of array (n)
	
TOP:
	CMP R1,#1
	BLE OUTERLOOP// branch if n<=1
	SUB R1,R1,#1
	B TOP
	 
OUTERLOOP:
	BL INNERLOOP2C //call subroutine
	
INNERLOOP2C:
	PUSH {R4-R8,LR}
	LDR R8,n
	ADD R1,R1,#1
	CMP R1,R8
	BGT end
	SUB R2, R1, #1 //R2 = n-1
	LDR R3, [R0,R2,LSL#2] //R3=value=arr[n-1]
	SUB R4, R1,#2 //R4=j=n-2
	ADD R5,R4,#1//R5=j+1
	CMP R4,#0 //branch if j>=0
	BGE INNERLOOP1
	STR R3,[R0,R5,LSL#2]//value ->arr[j+1]
	POP {R4-R8, LR}
	BX LR
	
INNERLOOP1:
	LDR R6, [R0,R4,LSL#2] //R6 = arr[j]
	CMP R6,R3 //arr[j] - value
	BGT INNERLOOP2 //branch if R6>R3 =>arr[j]>value
	STR R3,[R0,R5,LSL#2] //value ->arr[j+1]
	POP {R4-R8,LR}
	B INNERLOOP2C
	
INNERLOOP2:
	LDR R7,[R0,R5,LSL#2] //R7 = arr[j+1]
	STR R7,[R0,R4,LSL#2] //arr[j+1] -> arr[j]
	STR R6,[R0,R5,LSL#2] //arr[j] -> arr[j+1]
	SUB R4,R4,#1 //j=j-1
	POP {R4-R8,LR}
	B TOP
	
end:
	B end
