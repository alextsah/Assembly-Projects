.equ pixel_buffer,0xc8000000
.equ character_buffer,0xc9000000
.equ PS2_data, 0xff200100
input_mazes:// First Obstacle Course
            .word 0,1,1,1,1,1,1,1,1,1,0,1
            .word 0,1,0,0,0,1,0,0,0,1,0,1
            .word 0,1,0,1,0,1,0,1,0,1,0,1
            .word 0,1,0,1,0,1,0,1,0,1,0,1
            .word 0,1,0,1,0,1,0,1,0,1,0,1
            .word 0,1,0,1,0,1,0,1,0,1,0,1
            .word 0,1,0,1,0,1,0,1,0,1,0,0
            .word 0,0,0,1,0,0,0,1,0,1,0,1
            .word 1,1,1,1,1,1,1,1,0,0,0,3
.global _start
_start:
	BL VGA_clear_charbuff_ASM
	BL VGA_fill_ASM
	BL draw_grid_ASM
	BL draw_ampersand_ASM
	BL draw_exit_ASM
	BL draw_obstacles_ASM
	BL read_PS2_data_ASM
	B end
	
read_PS2_data_ASM:
		PUSH {R0-R2,LR}
		MOV R0,#3
		MOV R1,#3
		MOV R2,#83
read_again:
		LDR R3,=PS2_data
		LDR R3,[R3]
 		LSR R4,R3,#15
		TST R4,#0b1
		BEQ read_again
		B determine_action
determine_action:
		
		LDR R3,=PS2_data
		LDRB R3,[R3]
		CMP R3,#0xe0
		BEQ MOVE_DOWN
		B read_again
MOVE_DOWN:
		BL VGA_clear_not_all_charbuff_ASM
		ADD R1,R1,#7
		BL VGA_write_char_ASM
		B read_again
	
draw_obstacles_ASM:
	PUSH {R3-R11, LR}
	MOV R0,#-1 //x
	MOV R1,#1 //y
	LDR R3,=input_mazes
	MOV R4,#0
	MOV R5,#4
LOOP:
	ADD R0,R0,#1
	MUL R7,R4,R5
	ADD R8,R3,R7
	LDR R6,[R8],#0
	CMP R6,#1
	BEQ setup
continue:
	ADD R4,R4,#1
	CMP R4,#108
	BEQ return 
	CMP R4,#12
	BLEQ reset_x_y
	CMP R4,#24
	BLEQ reset_x_y
	CMP R4,#36
	BLEQ reset_x_y
	CMP R4,#48
	BLEQ reset_x_y
	CMP R4,#60
	BLEQ reset_x_y
	CMP R4,#72
	BLEQ reset_x_y
	CMP R4,#84
	BLEQ reset_x_y
	CMP R4,#96
	BLEQ reset_x_y
	CMP R4,#108
	BLEQ reset_x_y
	MOV R7,#0
	B LOOP

return:
	POP {R3-R11,LR}
	BX LR 

reset_x_y:
	PUSH {LR}
	MOV R0,#-1
	ADD R1,R1,#1
	POP {LR}
	BX LR 
	
setup:
	MOV R10,R0
	MOV R11,R1
	BL draw_block
	MOV R0,R10
	MOV R1,R11
	B continue
	
	
draw_block:
		push {R3-R6,lr}
		MOV R6,#26
		MUL R0,R0,R6
		MUL R1,R1,R6
		MOV R5,R1
		SUB R3,R1,#26
		ADD R4,R0,#26
		MOV R2,#0xffffffff //c=0
		BL VGA_draw_point_ASM
LOOP_X_obstacles:
		B START_obstacles
increment_x_obstacles:
		MOV R1,R3 //=R1-26
		ADD R0,R0,#1 //increment x
		B START_obstacles
START_obstacles:
		CMP R0,R4 //=R0+26
		BEQ STOP_obstacles
		B LOOP_Y_obstacles
	LOOP_Y_obstacles:
		CMP R1,R5 //=R1
		BEQ increment_x_obstacles
		BL VGA_draw_point_ASM
		ADD R1,R1,#1
		B LOOP_Y_obstacles
STOP_obstacles:
		pop {R3-R6,lr}
		BX LR
		
		
draw_exit_ASM:
	push {r0-r2,lr}
	MOV R0,#75
	MOV R1,#55
	MOV R2,#88
	BL VGA_write_char_ASM
	pop {r0-r2,lr}
	BX LR
	
	
draw_ampersand_ASM:
	push {r0-r2,lr}
	MOV R0,#3
	MOV R1,#3
	MOV R2,#83
	BL VGA_write_char_ASM
	pop {r0-r2,lr}
	BX LR 
	
	
VGA_write_char_ASM:
		push {r4-r9,lr}
		MOV R6,R2 //c
		LDR R7,=character_buffer
		LSL R5,R1,#7 //(y << 7)
		ADD R8,R5,R0 //(y << 7) | x
		ADD R9,R8,R7 //0xc9000000 | (y << 7) | x
		STRB R6,[R9] // c -> 0xc9000000 | (y << 7) | x
		pop {r4-r9,lr}
		BX LR

VGA_clear_charbuff_ASM:
		push {r0-r2,lr}
		MOV R0,#0 //x=0
		MOV R1,#0 //y=0
		MOV R2,#0 //c=0
		BL VGA_write_char_ASM
LOOP_X_2:
		B START_2
increment_x_2:
		ADD R0,R0,#1 //increment x
		B START_2
START_2:
		MOV R1,#0 //reset y
		CMP R0,#80
		BEQ STOP_2
		B LOOP_Y_2
	LOOP_Y_2:
		CMP R1,#60
		BEQ increment_x_2
		BL VGA_write_char_ASM
		ADD R1,R1,#1
		B LOOP_Y_2
STOP_2:
		pop {r0-r2,lr}
		BX LR
		
VGA_clear_not_all_charbuff_ASM:
		push {r0-r2,lr}
		MOV R0,#0 //x=0
		MOV R1,#0 //y=0
		MOV R2,#0 //c=0
		BL VGA_write_char_ASM
LOOP_X_2_not_all:
		B START_2_not_all
increment_x_2_not_all:
		ADD R0,R0,#1 //increment x
		B START_2_not_all
START_2_not_all:
		MOV R1,#0 //reset y
		CMP R0,#75
		BEQ STOP_2_not_all
		B LOOP_Y_2_not_all
	LOOP_Y_2_not_all:
		CMP R1,#55
		BEQ increment_x_2_not_all
		BL VGA_write_char_ASM
		ADD R1,R1,#1
		B LOOP_Y_2_not_all
STOP_2_not_all:
		pop {r0-r2,lr}
		BX LR
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
	CMP R1,#235
	BEQ NEXT_X_LINE
	BL VGA_draw_point_ASM
	ADD R1,R1,#1
	B LOOP_X_GRID
	
NEXT_X_LINE:
	CMP R0,#288
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
	CMP R0,#312
	BEQ NEXT_Y_LINE
	BL VGA_draw_point_ASM
	ADD R0,R0,#1
	B LOOP_Y_GRID
	
NEXT_Y_LINE:
	CMP R1,#234
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
		MOV R2,#0x0 //c=0
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
