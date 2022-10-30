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
	MOV R10,#0x00000000
	MOV R12,#0x00000000
	LDR R8,=HEX0_3
	LDR R9,=HEX4_5
	STR R10,[R8]
	STR R12,[R9]
	MOV R10,#0
	MOV R12,#0
	MOV R0,#0xc //where is it being written 
	MOV R1,#0xf //what is being written 
	
HEX_write_ASM:
	MOV R3,#0
	LDR R2,#HEX0
	ANDS R4,R0,R2
	BLNE write
	ADD R10,R10,R3
	B checkHEX1
	
checkHEX1:
	MOV R3,#0
	LDR R2,#HEX1
	ANDS R4,R0,R2
	BLNE write
	LSL R3,R3,#8
	ADD R10,R10,R3
	B checkHEX2
	
checkHEX2:
	MOV R3,#0
	LDR R2,#HEX2
	ANDS R4,R0,R2
	BLNE write
	LSL R3,R3,#16
	ADD R10,R10,R3
	B checkHEX3

checkHEX3:
	MOV R3,#0
	LDR R2,#HEX3
	ANDS R4,R0,R2
	BLNE write
	LSL R3,R3,#24
	ADD R10,R10,R3
	B checkHEX4
	
checkHEX4:
	MOV R3,#0
	LDR R2,#HEX4
	ANDS R4,R0,R2
	BLNE write
	ADD R12,R12,R3
	B turn_on

checkHEX5:
	MOV R3,#0
	LDR R2,#HEX5
	ANDS R4,R0,R2
	BLNE write
	LSL R3,R3,#8
	ADD R12,R12,R3
	B turn_on
	
write:
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
	MOV R3,#0x3f
	BX LR
write_one:
	MOV R3,#0x6
	BX LR
write_two:
	MOV R3,#0x5b
	BX LR
write_three:
	MOV R3,#0x4f
	BX LR
write_four:
	MOV R3,#0x67
	BX LR
write_five:
	MOV R3,#0x6d
	BX LR
write_six:
	MOV R3,#0x7d
	BX LR
write_seven:
	MOV R3,#0x6
	BX LR
write_eight:
	MOV R3,#0x7f
	BX LR
write_nine:
	MOV R3,#0x6f
	BX LR
write_a:
	MOV R3,#0xf7
	BX LR
write_b:
	MOV R3,#0x7f
	BX LR
write_c:
	MOV R3,#0x39
	BX LR
write_d:
	MOV R3,#0x3f
	BX LR
write_e:
	MOV R3,#0x79
	BX LR
write_f:
	MOV R3,#0x71
	BX LR
	
turn_on:
	LDR R8,=HEX0_3
	LDR R9,=HEX4_5
	STR R10,[R8]
	STR R12,[R9]
	.end
