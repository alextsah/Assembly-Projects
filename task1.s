.global _start              
// initialize values
devident: .word 10
devisor: .word 2
result: .space 4
reminder: .word 10
quotient: .word 0

_start:
	LDR R0,devident
	LDR R1,devisor
	LDR R2,=result
	LDR R3,devident //R3 = reminder = devident
	LDR R4,quotient //R4 = quotient 	
top:
	CMP R3,R1
	BGE while
	STR R2, [R3,R4,LSL#4]
	B end
while:
	SUB R3,R3,R1
	ADD R4,R4,#1
	B top

.end
