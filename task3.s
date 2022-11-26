.equ pixel_buffer,0xc8000000
input_mazes:// First Obstacle Course
            .word 2,1,0,1,1,1,0,0,0,1,0,1
            .word 0,1,0,1,1,1,0,0,0,1,0,1
            .word 0,1,0,0,0,0,0,0,0,1,0,1
            .word 0,1,0,1,1,1,0,0,0,1,1,1
            .word 0,1,0,1,1,1,0,0,0,1,1,1
            .word 0,0,0,1,1,1,0,0,0,1,1,1
            .word 1,1,1,1,1,1,0,0,1,0,0,0
            .word 1,1,1,1,1,1,0,1,0,0,0,0
            .word 1,1,1,1,1,1,0,0,0,0,0,3
.global _start
_start:
	BL VGA_fill_ASM
	BL draw_grid_ASM
	B end
	
draw_grid_ASM:
	PUSH {LR}
	BL DRAW_Y_GRID
	BL DRAW_X_GRID
	POP {LR}
	BX LR
DRAW_X_GRID:
	PUSH {R0-R2,LR}
	MOV R0,#0
	MOV R1,#0
	MOV R2,#0xffffffff
LOOP_X_GRID:
	CMP R1,#240
	BEQ NEXT_X_LINE
	BL VGA_draw_point_ASM
	ADD R1,R1,#1
	B LOOP_X_GRID
	
NEXT_X_LINE:
	CMP R0,#260
	BGT RETURN_DRAW_X
	ADD R0,R0,#26
	MOV R1,#0
	B LOOP_X_GRID

RETURN_DRAW_X:
	POP {R0-R2,LR}
	BX LR
	
DRAW_Y_GRID:
	PUSH {R0-R2,LR}
	MOV R0,#0
	MOV R1,#0
	MOV R2,#0xffffffff
LOOP_Y_GRID:
	CMP R0,#320
	BEQ NEXT_Y_LINE
	BL VGA_draw_point_ASM
	ADD R0,R0,#1
	B LOOP_Y_GRID
	
NEXT_Y_LINE:
	CMP R1,#208
	BEQ RETURN_DRAW_Y
	ADD R1,R1,#26
	MOV R0,#0
	B LOOP_Y_GRID
	
RETURN_DRAW_Y:
	POP {R0-R2,LR}
	BX LR

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
