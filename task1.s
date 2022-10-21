.global _start
.equ LED_MEMORY, 0xFF200000
.equ HEX0_3, 0xFF200020
.equ HEX4_5, 0xFF200030
.equ on, 0xffffffff
.equ off,0x00000000
_start:

HEX_flood_ASM:
	LDR R1,=HEX0_3 //to be removed 
	LDR R2,=on
	STR R2,[R1]

HEX_clear_ASM:
	LDR R1,=HEX4_5 //to be removed 
	LDR R2,=off
	STR R2,[R1]

.end

