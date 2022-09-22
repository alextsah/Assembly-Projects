.global _start
//initialize array 
arr:   .word 68, -22, -31, 75, -10, -61, 39, 92, 94, -55 // test array of 10 elements 

_start:
	LDR R0,=arr //pointer to array a.k.a base address of array 
	MOV R1,#10 //length of array (n)
	MOV R2,#1 //index i=1

TOP:
	CMP R2,R1
	BLE OUTERLOOP //if R2<R1 => i<n => i-n<0 
	
OUTERLOOP:
	LDR R3,[R0,R2,LSL#2] //R3=value=arr[i]
	STR R2, [R4] //R4=j=i
	
	CMP R4,#0 //R4-0
	BGE INNERLOOP1 //if R4-0>0 => R4>0 =>j>0 then branch 
	STR R3, [R0,R2,LSL#2]// arr[j] = value 
	ADD R2,R2,#1//i = i+1
	B OUTERLOOP

INNERLOOP1:
	SUB R5,R5,#1 //R5 = j-1
	LDR R6,[R0,R5,LSL#4] //R6=arr[j-1]
	CMP R6,R3//R6-R3 = arr[j-1]-value
	BGE INNERLOOP2//if arr[j-1]-value>0 => arr[j-1]>value then branch 
	STR R3, [R0,R2,LSL#2]// arr[j] = value
	B OUTERLOOP
	
INNERLOOP2:
	LDR R7,[R0,R4,LSL#4] //R7=arr[j]
	STR R7,[R6]//arr[j]=arr[j-1]
	SUB R4,R4,#1//R6=R6-1 => j=j-1
	B INNERLOOP1
