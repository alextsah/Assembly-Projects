.equ pixel_buffer,0xc8000000
.global _start
_start:
	BL VGA_fill_ASM
	B end
	
VGA_draw_point_ASM:
		push {r4-r9,lr}
		MOV R6,R2 //c
		LDR R7,=pixel_buffer
		LSL R4,R0,#1 //(x << 1)
		LSL R5,R1,#10 //(y << 10)
		ADD R8,R4,R5 // (y << 10) | (x << 1)
		ADD R9,R8,R7 //0xc8000000 | (y << 10) | (x << 1)
		STRH R6,[R9] // c -> 0xc8000000 | (y << 10) | (x << 1)
		pop {r4-r9,lr}
		BX LR

VGA_fill_ASM:
		push {r2,lr}
		MOV R0,#0 //x=0
		MOV R1,#0 //y=0
		MOV R2,#0 //c=0
		BL VGA_draw_point_ASM
LOOP_X:
		B START
increment_x:
		ADD R0,R0,#1 //increment x
		B START
START:
		MOV R1,#0 //reset y
		CMP R0,#320
		BEQ STOP
		B LOOP_Y
	LOOP_Y:
		CMP R1,#240
		BEQ increment_x
		BL VGA_draw_point_ASM
		ADD R1,R1,#1
		B LOOP_Y
STOP:
		pop {r2,lr}
		BX LR

end:
	B end 
