.global _start
.equ PUSHBUTTONS, 0xFF200050 
.equ PBEDGECAPTURE, 0xFF20005C
.equ PBINTERRUPT, 0xFF200058
n: .word 0x05

PB0: .word 0x00000001
PB1: .word 0x00000002
PB2: .word 0x00000004
PB3: .word 0x00000008

_start:
	MOV R0,#0x3
	BL enable_PB_INT_ASM
	MOV R0,#0x1
	BL disable_PB_INT_ASM
	B end 
read_PB_data_ASM:
	LDR R0,=PUSHBUTTONS
	LDR R1,[R0]
	BX LR
	
read_PB_edgecp_ASM:
	LDR R0,=PBEDGECAPTURE
	LDR R1,[R0]
	BX LR
	
PB_data_is_pressed_ASM:
	LDR R1,=PUSHBUTTONS
	LDR R1,[R1]
	ANDS R2,R1,R0
	BEQ not_pressed
	BNE pressed
	pressed:
		MOV R1,#0x00000001
		BX LR
	not_pressed:
		MOV R1,#0x00000000
		BX LR

PB_edgecp_is_pressed_ASM:
	LDR R1,=PBEDGECAPTURE
	LDR R1,[R1]
	ANDS R2,R1,R0
	BEQ edgecp_not_pressed
	BNE edgecp_pressed
	edgecp_pressed:
		MOV R1,#0x00000001
		BX LR
	edgecp_not_pressed:
		MOV R1,#0x00000000
		BX LR
		
PB_clear_edgecp_ASM:
	LDR R0,=PBEDGECAPTURE
	LDR R1,[R0]
	STR R1,[R0]
	BX LR 
	
enable_PB_INT_ASM:
	PUSH {R1-R4}
	CMP R0,#0x0000
	BEQ write0
	CMP R0,#0x0001
	BEQ write1
	CMP R0,#0x0002
	BEQ write2
	CMP R0,#0x0003
	BEQ write3
	CMP R0,#0x0004
	BEQ write4
	CMP R0,#0x0005
	BEQ write5
	CMP R0,#0x0006
	BEQ write6
	CMP R0,#0x0007
	BEQ write7
	CMP R0,#0x0008
	BEQ write8
	CMP R0,#0x0009
	BEQ write9
	CMP R0,#0x000a
	BEQ writea
	CMP R0,#0x000b
	BEQ writeb
	CMP R0,#0x000c
	BEQ writec
	CMP R0,#0x000d
	BEQ writed
	CMP R0,#0x000e
	BEQ writee
	CMP R0,#0x000f
	BEQ writef
write0: MOV R2,#0b0000
		B updatereg
write1: MOV R2,#0b0001
		B updatereg
write2: MOV R2,#0b0010
		B updatereg
write3: MOV R2,#0b0011
		B updatereg
write4: MOV R2,#0b0100
		B updatereg
write5: MOV R2,#0b0101
		B updatereg
write6: MOV R2,#0b0110
		B updatereg
write7: MOV R2,#0b0111
		B updatereg
write8: MOV R2,#0b1000
		B updatereg
write9: MOV R2,#0b1001
		B updatereg
writea: MOV R2,#0b1010
		B updatereg
writeb: MOV R2,#0b1011
		B updatereg
writec: MOV R2,#0b1100
		B updatereg
writed: MOV R2,#0b1101
		B updatereg
writee: MOV R2,#0b1110
		B updatereg
writef: MOV R2,#0b1111
		B updatereg
updatereg:
	LDR R3,=PBINTERRUPT
	LDR R4,[R3]
	ORR R4,R4,R2
	STR R4,[R3]
	POP {R1-R4}
	BX LR 
	
disable_PB_INT_ASM:
	PUSH {R1-R4}
	CMP R0,#0x0000
	BEQ disable0
	CMP R0,#0x0001
	BEQ disable1
	CMP R0,#0x0002
	BEQ disable2
	CMP R0,#0x0003
	BEQ disable3
	CMP R0,#0x0004
	BEQ disable4
	CMP R0,#0x0005
	BEQ disable5
	CMP R0,#0x0006
	BEQ disable6
	CMP R0,#0x0007
	BEQ disable7
	CMP R0,#0x0008
	BEQ disable8
	CMP R0,#0x0009
	BEQ disable9
	CMP R0,#0x000a
	BEQ disablea
	CMP R0,#0x000b
	BEQ disableb
	CMP R0,#0x000c
	BEQ disablec
	CMP R0,#0x000d
	BEQ disabled
	CMP R0,#0x000e
	BEQ disablee
	CMP R0,#0x000f
	BEQ disablef
disable0: MOV R2,#0b1111
		B updatereg2
disable1: MOV R2,#0b1110
		B updatereg2
disable2: MOV R2,#0b1101
		B updatereg2
disable3: MOV R2,#0b1100
		B updatereg2
disable4: MOV R2,#0b1011
		B updatereg2
disable5: MOV R2,#0b1010
		B updatereg2
disable6: MOV R2,#0b1001
		B updatereg2
disable7: MOV R2,#0b1000
		B updatereg2
disable8: MOV R2,#0b0111
		B updatereg2
disable9: MOV R2,#0b0110
		B updatereg2
disablea: MOV R2,#0b0101
		B updatereg2
disableb: MOV R2,#0b0100
		B updatereg2
disablec: MOV R2,#0b0011
		B updatereg2
disabled: MOV R2,#0b0010
		B updatereg2
disablee: MOV R2,#0b0001
		B updatereg2
disablef: MOV R2,#0b0000
		B updatereg2
updatereg2:
	LDR R3,=PBINTERRUPT
	LDR R4,[R3]
	AND R4,R4,R2
	STR R4,[R3]
	POP {R1-R4}
	BX LR 
end:
	B end
.end
