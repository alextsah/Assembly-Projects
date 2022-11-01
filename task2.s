.global _start
.equ LED_MEMORY, 0xFF200000

.equ TIMERLOAD, 0xFFFEC600
.equ TIMERCOUNTER, 0xFFFEC604
.equ TIMERCONTROL, 0xFFFEC608
.equ TIMERINTERUP, 0xFFFEC60C

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
	MOV R5,#0
begin:
	LDR R1,=200000000
	MOV R2,#0b001
	BL ARM_TIM_clear_INT_ASM
	BL ARM_TIM_config_ASM
loop:
	BL ARM_TIM_read_INT_ASM
	CMP R2,#1
	BEQ increment 
	B loop
	
ARM_TIM_config_ASM:
	PUSH {R3-R4}
	LDR R3,=TIMERLOAD
	STR R1,[R3]
	LDR R4,=TIMERCONTROL
	STR R2,[R4]
	POP {R3-R4}
	BX LR
	
ARM_TIM_clear_INT_ASM:
	PUSH {R2-R3}
	MOV R2,#0x00000001
	LDR R3,=TIMERINTERUP
	STR R2,[R3]
	POP {R2-R3}
	BX LR 

ARM_TIM_read_INT_ASM:
	LDR R2,=TIMERINTERUP
	LDR R2,[R2] 
	BX LR

increment:
	MOV R1,R5
	MOV R0,#0x01
	BL HEX_write_ASM
	ADD R5,R5,#1
	CMP R5,#16
	BEQ _start
	B begin
	
HEX_write_ASM:
	PUSH {R2-R12}
	LDR R2,=HEX0_3
	LDR R2,[R2]
	LDR R3,=HEX4_5
	LDR R3,[R3]
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
	B write_on

write_HEX0:
	MOV R12,#0xFFFFFF00
	AND R2,R2,R12
	ORR R2,R2,R10
	B checkHEX1write
write_HEX1:
	MOV R12,#0xFFFF00FF
	AND R2,R2,R12
	LSL R11,R10,#8
	ORR R2,R2,R11
	B checkHEX2write
write_HEX2:
	MOV R12,#0xFF00FFFF
	AND R2,R2,R12
	LSL R11,R10,#16
	ORR R2,R2,R11
	B checkHEX3write
write_HEX3:
	MOV R12,#0x00FFFFFF
	AND R2,R2,R12
	LSL R11,R10,#24
	ORR R2,R2,R11
	B checkHEX4write
write_HEX4:
	MOV R12,#0xFFFFFF00
	AND R3,R3,R12
	ORR R3,R3,R10
	B checkHEX5write
write_HEX5:
	MOV R12,#0xFFFF00FF
	AND R3,R3,R12
	LSL R11,R10,#8
	ORR R3,R3,R11
	B write_on
	
write_on:
	LDR R8,=HEX0_3
	LDR R9,=HEX4_5
	LDR R11,=LED_MEMORY
	STR R2,[R8]
	STR R3,[R9]
	STR R1,[R11]
	POP {R2-R12}
	BX LR

end:
	B end
	.end
	
