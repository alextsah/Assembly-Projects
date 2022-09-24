.global _start

arr: 	.word 69,-22,-30
_start:
	LDR R0,=arr //pointer to array 
	MOV R1,#3 //lenght of array (n)
	
	CMP R1,#1
	BLE end
	//PUSH {R0,R1,LR} //push parameters and LR (R0 is TOS)
	
OUTERLOOP:
	//PUSH {R1,R2,LR} //save registers insertionsort uses to stack 
	//LDR R1, [SP, #16] //load n from stack 
	//LDR R2, [SP, #12] //load array pointer from stack 
	PUSH {LR}
	BL INNERLOOP2C //call subroutine
	
INNERLOOP2C:
	SUB R2, R1, #1 //R2 = n-1
	LDR R4, [R0,R2,LSL#2] //R4=value=arr[n-1]
	SUB R5, R1,#2 //R5=j=n-2
	
	CMP R5,#0 //branch if j>=0
	BGE INNERLOOP1
	ADD R6,R6,#1//R6=j+1
	LDR R7,[R0,R6,LSL#2]//R7=arr[j+1]
	STR R4,[R0,R6,LSL#2]
	B OUTERLOOP
	
INNERLOOP1:
	LDR R8, [R0,R5,LSL#2] //R8 = arr[j]
	CMP R8,R4 //arr[j] -arr[n-1]
	BGT INNERLOOP2 //branch if R8>R4 =>arr[j]>value
	STR R4,[R0,R6,LSL#2]
	B OUTERLOOP
	
INNERLOOP2:
	MOV R9,R8 //temp var for R9=R8=arr[j]
	LDR R7,[R0,R6,LSL#2]
	STR R7,[R0,R5,LSL#2] //arr[j+1] -> arr[j]
	STR R9,[R0,R6,LSL#2] //arr[j] -> arr[j+1]
	SUB R5,R5,#1 //j=j-1
	BX LR
	
.end
