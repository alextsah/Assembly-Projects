.global _start

arr:   .word 68, -22, -31, 75, -10, -61, 39, 92, 94, -55 // test array
_start:
	LDR R0,arr //pointer to array 
	MOV R1,#10 //length of array (n)
	MOV R2,#1 //index i=1
	
	CMP R2,R1
	BLT OUTERLOOP //if R2<R1 => i<n => i-n<0 
	
OUTERLOOP:
	ADD R1,R1,#1 //R1 = R1+1
	