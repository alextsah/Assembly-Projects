.global _start

arr:	.word 10,15

_start:
	LDR R0,=arr
	MOV R1,#0
	MOV R2,#1
	
	LDR R3,[R0,R1,LSL#2]
	LDR R4,[R0,R2,LSL#2]
	
	STR R3,[R0,R2,LSL#2]
	STR R4,[R0,R1,LSL#2]
	
.end