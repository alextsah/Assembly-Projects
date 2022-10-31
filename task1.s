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
	MOV R0,#0x10
	MOV R1,#0x5
	BL HEX_write_ASM
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
	
HEX_write_ASM:
	PUSH {R2-R12}
	LDR R3,=HEX0_3
	LDR R3,[R3]
	LDR R2,=HEX4_5
	LDR R2,[R2]
	LDR R10,#HEX0
	AND R4,R0,R10
	B checkHEX1
	
checkHEX1:
	LDR R10,#HEX1
	AND R5,R0,R10
	B checkHEX2
	
checkHEX2:
	LDR R10,#HEX2
	AND R6,R0,R10
	B checkHEX3

checkHEX3:
	LDR R10,#HEX3
	AND R7,R0,R10
	B checkHEX4
	
checkHEX4:
	LDR R10,#HEX4
	AND R8,R0,R10
	B checkHEX5

checkHEX5:
	LDR R10,#HEX5
	AND R9,R0,R10
	B find_what_to_write
	
find_what_to_write:
	CMP R1,#0
	BEQ write_zero
	CMP R1,#1
	BEQ write_one
	CMP R1,#2
	BEQ write_two
	CMP R1,#3
	BEQ write_three
	CMP R1,#4
	BEQ write_four
	CMP R1,#5
	BEQ write_five
	CMP R1,#6
	BEQ write_six
	CMP R1,#7
	BEQ write_seven
	CMP R1,#8
	BEQ write_eight
	CMP R1,#9
	BEQ write_nine
	CMP R1,#0xa
	BEQ write_a
	CMP R1,#0xb
	BEQ write_b
	CMP R1,#0xc
	BEQ write_c
	CMP R1,#0xd
	BEQ write_d
	CMP R1,#0xe
	BEQ write_e
	CMP R1,#0xf
	BEQ write_f

write_zero:
	MOV R10,#0x3f
	B write
write_one:
	MOV R10,#0x6
	B write
write_two:
	MOV R10,#0x5b
	B write
write_three:
	MOV R10,#0x4f
	B write
write_four:
	MOV R10,#0x66
	B write
write_five:
	MOV R10,#0x6d
	B write
write_six:
	MOV R10,#0x7d
	B write
write_seven:
	MOV R10,#0x7
	B write
write_eight:
	MOV R10,#0x7f
	B write
write_nine:
	MOV R10,#0x6f
	B write
write_a:
	MOV R10,#0xf7
	B write
write_b:
	MOV R10,#0x7f
	B write
write_c:
	MOV R10,#0x39
	B write
write_d:
	MOV R10,#0x3f
	B write
write_e:
	MOV R10,#0x79
	B write
write_f:
	MOV R10,#0x71
	B write
	
write:
	CMP R4,#0
	BNE write_HEX0
checkHEX1write:
	CMP R5,#0
	BNE write_HEX1
checkHEX2write:
	CMP R6,#0
	BNE write_HEX2
checkHEX3write:
	CMP R7,#0
	BNE write_HEX3
checkHEX4write:
	CMP R8,#0
	BNE write_HEX4
checkHEX5write:
	CMP R9,#0
	BNE write_HEX5
	B turn_on

write_HEX0:
	MOV R12,#0xFFFFFF00
	AND R3,R3,R12
	ORR R3,R3,R10
	B checkHEX1write
write_HEX1:
	MOV R12,#0xFFFF00FF
	AND R3,R3,R12
	LSL R11,R10,#8
	ORR R3,R3,R11
	B checkHEX2write
write_HEX2:
	MOV R12,#0xFF00FFFF
	AND R3,R3,R12
	LSL R11,R10,#16
	ORR R3,R3,R11
	B checkHEX3write
write_HEX3:
	MOV R12,#0x00FFFFFF
	AND R3,R3,R12
	LSL R11,R10,#24
	ORR R3,R3,R11
	B checkHEX4write
write_HEX4:
	MOV R12,#0xFFFFFF00
	AND R2,R2,R12
	ORR R2,R2,R10
	B checkHEX5write
write_HEX5:
	MOV R12,#0xFFFF00FF
	AND R2,R2,R12
	LSL R11,R10,#8
	ORR R2,R2,R11
	B write_on
	
write_on:
	LDR R8,=HEX0_3
	LDR R9,=HEX4_5
	STR R3,[R8]
	STR R2,[R9]
	POP {R2-R12}
	BX LR
	
end: 
	B end
.end
