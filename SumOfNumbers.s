.global _start

arr: 	.word 1,2,3,4,5,5,10 //array to be summed 
n:		.word 7 //n=num of elements in array 
sum: 	.space 4 //space to store result 

_start:
	LDR R1, =arr //R1 = pointer to array 
	LDR R2, n //R2 = num of elements to add 
	PUSH {R1, R2, LR} //push parameters and LR(R1=pointer to array is TOS)
	BL add //call add function
	LDR R1, [SP, #0] //sum is at TOS (line 27)
	STR R1, sum //store sum in memory 
	ADD SP, SP, #8 //clear parameters 
	POP {LR} //restore LR 
	B end
add:
	PUSH {R4-R6} //save the registers (to stack) add functions  uses 
	LDR R4, [SP, #16] //load n from stack 
	LDR R5, [SP, #12] //load pointer to array(R1) from stack 
	MOV R1, #0 //clear R1 (sum)
loop:
	LDR R6,[R5], #4 //get next value from array 
	ADD R1,R1,R6 //sum partially 
	SUBS R4,R4,#1 //decrement loop counter 
	BGT loop
	STR R1, [SP, #12] //store sum on stack, replacing array pointer 
	POP {R4-R6} //restore registers 
	BX LR
	
.end	
