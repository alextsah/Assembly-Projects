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
	MOV R0,#0xC
	
HEX_flood_ASM:
	LDR R1,#HEX0
	LDR R3,#HEX0_display
	ANDS R2,R0,R1
	BEQ check1
	ADD R10,R10,R3
	
check1:	LDR R1,#HEX1
	LDR R3,#HEX1_display
	ANDS R2,R0,R1
	BEQ check2
	ADD R10,R10,R3
check2:	LDR R1,#HEX2
	LDR R3,#HEX2_display
	ANDS R2,R0,R1
	BEQ check3
	ADD R10,R10,R3
check3:	LDR R1,#HEX3
	LDR R3,#HEX3_display
	ANDS R2,R0,R1
	BEQ check4
	ADD R10,R10,R3
check4:	LDR R1,#HEX4
	LDR R3,#HEX4_display
	ANDS R2,R0,R1
	BEQ check5
	ADD R12,R12,R3 
check5:	LDR R1,#HEX5
	LDR R3,#HEX5_display
	ANDS R2,R0,R1
	BEQ turn_on
	ADD R12,R12,R3
	
turn_on:
	LDR R8,=HEX0_3
	LDR R9,=HEX4_5
	STR R10,[R8]
	STR R12,[R9]

HEX_clear_ASM:
	LDR R1,#HEX0
	LDR R3,#HEX0_display
	ANDS R2,R0,R1
	BEQ check1_off
	SUB R10,R10,R3
	
check1_off:	LDR R1,#HEX1
	LDR R3,#HEX1_display
	ANDS R2,R0,R1
	BEQ check2_off
	SUB R10,R10,R3
check2_off:	LDR R1,#HEX2
	LDR R3,#HEX2_display
	ANDS R2,R0,R1
	BEQ check3_off
	SUB R10,R10,R3
check3_off:	LDR R1,#HEX3
	LDR R3,#HEX3_display
	ANDS R2,R0,R1
	BEQ check4_off
	SUB R10,R10,R3
check4_off:	LDR R1,#HEX4
	LDR R3,#HEX4_display
	ANDS R2,R0,R1
	BEQ check5_off
	SUB R12,R12,R3 
check5_off:	LDR R1,#HEX5
	LDR R3,#HEX5_display
	ANDS R2,R0,R1
	BEQ turn_off
	SUB R12,R12,R3
	
turn_off:
	LDR R8,=HEX0_3
	LDR R9,=HEX4_5
	STR R10,[R8]
	STR R12,[R9]
	
end: .end
