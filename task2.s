.global _start
//initialize array 
arr:   .word 68, -22, -31, 75, -10, -61, 39, 92, 94, -55 // test array of 10 elements 

_start:
	LDR R0,=arr //pointer to array 
	MOV R1,#10 //length of array (n)
	MOV R2,#1 //index i=1

TOP:
	CMP R2,R1
	BLT OUTERLOOP //if R2<R1 => i<n => i-n<0 
	
OUTERLOOP:
	MUL R3, R2, #4 //R3 = R2 *4 = i*4 //offset for index i 
	ADD R4, R0, R3 //R4 = R0 + R3 = arr + i*4, absolute address of array 
	LDR R5, [R4] //R5 = value = arr[i]
	LDR R6, R2 //R6=j=i
	
	CMP R6,#0 //R6-0
	BGT INNERLOOP1 //if R6-0>0 => R6>0 then branch 
	//insert arr[j] = value 
	B OUTERLOOP

INNERLOOP1:
	MUL R7, R6, #4//R7 = R6*4 = j*4
	ADD R8, R0, R7//R8 = R0 + R7 = arr+j*4
	SUB R8,R8,#1//R8 = arr+j*4 -1 
	LDR R9,[R8]//R9 = arr[j-1]
	CMP R9,R5//R9-R5 = arr[j-1]-value
	BGT INNERLOOP2//if arr[j-1]-value>0 => arr[j-1]>value then branch 
	//insert arr[j] = value
	B OUTERLOOP
	
INNERLOOP2:
	ADD R10,R8,#1//R10 = arr+j*4
	LDR R11,[R10]//R11=arr[j]
	STR R9,[R11]//arr[j]=arr[j-1]
	SUB R6,R6,#1//R6=R6-1 => j=j-1
	B OUTERLOOP 
