.global _start

.equ HEX0_3, 0xFF200020
.equ HEX4_5, 0xFF200030

HEX0: .word 0x00000001
HEX1: .word 0x00000002
HEX2: .word 0x00000004
HEX3: .word 0x00000008
HEX4: .word 0x00000010
HEX5: .word 0x00000020

HEX0_display: .word 0x0000007F
HEX1_display: .word 0x00007F00
HEX2_display: .word 0x007F0000
HEX3_display: .word 0x7F000000
HEX4_display: .word 0x0000007F
HEX5_display: .word 0x00007F00

_start:
	MOV R0,#0x3F
	BL HEX_flood_ASM
	MOV R0,#0x35
	BL HEX_clear_ASM
	B end 
	
HEX_clear_ASM:
	PUSH {R2-R12}
	LDR R3,=HEX4_5
	LDR R3,[R3]
	LDR R2,=HEX0_3
	LDR R2,[R2]
	LDR R5,#HEX0
	MOV R4,#0xFFFFFF00
	ANDS R6,R0,R5
	BEQ check1
	AND R2,R2,R4
	
check1:	
	LDR R5,#HEX1
	MOV R4,#0xFFFF00FF
	ANDS R6,R0,R5
	BEQ check2
	AND R2,R2,R4
check2:	
	LDR R5,#HEX2
	MOV R4,#0xFF00FFFF
	ANDS R6,R0,R5
	BEQ check3
	AND R2,R2,R4
check3:	
	LDR R5,#HEX3
	MOV R4,#0x00FFFFFF
	ANDS R6,R0,R5
	BEQ check4
	AND R2,R2,R4
check4:	
	LDR R5,#HEX4
	MOV R4,#0xFFFFFF00
	ANDS R6,R0,R5
	BEQ check5
	AND R3,R3,R4
check5:	
	LDR R5,#HEX5
	MOV R4,#0xFFFF00FF
	ANDS R6,R0,R5
	BEQ turn_on
	AND R3,R3,R4
	
turn_off:
	LDR R8,=HEX0_3
	LDR R9,=HEX4_5
	STR R2,[R8]
	STR R3,[R9]
	POP {R2-R12}
	BX LR 
	
HEX_flood_ASM:
	PUSH {R2-R12}
	LDR R3,=HEX4_5
	LDR R3,[R3]
	LDR R2,=HEX0_3
	LDR R2,[R2]
	LDR R5,#HEX0
	LDR R4,#HEX0_display
	ANDS R6,R0,R5
	BEQ check1_on
	ORR R2,R2,R4
	
check1_on:	
	LDR R5,#HEX1
	LDR R4,#HEX1_display
	ANDS R6,R0,R5
	BEQ check2_on
	ORR R2,R2,R4
check2_on:	
	LDR R5,#HEX2
	LDR R4,#HEX2_display
	ANDS R6,R0,R5
	BEQ check3_on
	ORR R2,R2,R4
check3_on:	
	LDR R5,#HEX3
	LDR R4,#HEX3_display
	ANDS R6,R0,R5
	BEQ check4_on
	ORR R2,R2,R4
check4_on:	
	LDR R5,#HEX4
	LDR R4,#HEX4_display
	ANDS R6,R0,R5
	BEQ check5_on
	ORR R3,R3,R4
check5_on:	
	LDR R5,#HEX5
	LDR R4,#HEX5_display
	ANDS R6,R0,R5
	BEQ turn_on
	ORR R3,R3,R4
	
turn_on:
	LDR R8,=HEX0_3
	LDR R9,=HEX4_5
	STR R2,[R8]
	STR R3,[R9]
	POP {R2-R12}
	BX LR
	
end: 
	B end
.end
