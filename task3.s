.global _start

arr: 	.word 69,-22,-30
_start:
	LDR R0,=arr //pointer to array 
	MOV R1,#3 //lenght of array (n)
	PUSH {R0,R1,LR}
	BL OUTERLOOP
	
OUTERLOOP:
	PUSH {R1,R3,LR} //save registers insertionsort uses to stack 
	LDR R1, [SP, #16] //load n from stack 
	LDR R2, [SP, #12] //load array pointer from stack 
	
INNERLOOP2C:
	SUB R3, R1, #1 //R3 = n-1
	LDR R4, [R2,R3,LSL#4] //R4=value=arr[n-1]
	SUB R5, R1,#2 //R5=j=n-2
	
	CMP R5,#0
	BGE INNERLOOP1
	ADD R6,R6,#1//R6=j+1
	LDR R7,[R2,R6,LSL#4]//R7=arr[j+1]
	STR R4,[R2,R6,LSL#4]
	B OUTERLOOP
	
INNERLOOP1:
	LDR R8, [R2,R5,LSL#4] //R8 = arr[j]
	CMP R8,R4
	BGT INNERLOOP2
	STR R4,[R2,R6,LSL#4]
	B OUTERLOOP
	
INNERLOOP2:
	MOV R9,R8 //temp var for R9=R8=arr[j]
	STR R7,[R2,R5,LSL#4] //arr[j+1] -> arr[j]
	STR R8,[R2,R6,LSL#4] //arr[j] -> arr[j+1]
	SUB R5,R5,#1 //j=j-1
	BX LR
	
.end
	
	
	
	
	
	