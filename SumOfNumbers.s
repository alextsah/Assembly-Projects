.global _start

arr: 	.word 1,2,3,4,5 //array to be summed 
n:		.word 5 //n=num of elements in array 
sum: 	.space 4 //space to store result 

_start:
	LDR R1, =arr
	LDR R2, n
	PUSH {R1, R2, LR}
	BL add
	LDR R1, [SP, #0]
	STR R1, sum
	ADD SP, SP, #8
	POP {LR}
	B end
add:
	PUSH {R4-R6}
	LDR R4, [SP, #16]
	LDR R5, [SP, #12]
	MOV R1, #0
loop:
	LDR R6,[R5], #4
	ADD R1,R1,R6
	SUBS R4,R4,#1
	BGT loop
	STR R1, [SP, #12]
	POP {R4-R6}
	BX LR
	
.end
	
	