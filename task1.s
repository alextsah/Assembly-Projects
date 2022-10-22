.global _start

HEX0: .word 0x00000001
HEX1: .word 0x00000002
HEX2: .word 0x00000004
HEX3: .word 0x00000008
HEX4: .word 0x00000010
HEX5: .word 0x00000020

_start:
	MOV R0,#12
	LDR R1,#HEX0
	AND R2,R0,R1

.end
