.equ pixel_buffer,0xc8000000
.equ character_buffer,0xc9000000
.equ PS2_data, 0xff200100
input_mazes:
            .word 2,1,0,1,1,1,0,0,0,0,0,1
            .word 0,1,0,1,1,1,0,0,0,1,0,1
            .word 0,1,0,0,0,0,0,0,0,1,0,1
            .word 0,1,0,1,1,1,0,0,0,1,0,1
            .word 0,1,0,1,1,1,0,0,0,1,0,1
            .word 0,0,0,1,1,1,0,0,0,1,0,1
            .word 1,1,1,1,1,1,0,0,1,0,0,0
            .word 1,1,1,1,1,1,0,1,0,0,0,0
            .word 1,1,1,1,1,1,1,0,0,0,0,3
            // Third Obstacle Course
            .word 2,0,0,0,0,1,0,0,0,1,0,1
            .word 0,1,1,1,0,1,1,1,0,1,0,1
            .word 0,1,0,0,0,0,0,0,0,0,0,1
            .word 0,1,1,1,1,1,0,1,1,1,0,1
            .word 0,1,0,0,0,0,0,0,0,1,0,1
            .word 1,1,0,1,1,1,1,1,1,1,1,1
            .word 0,1,0,0,0,0,0,0,0,0,0,1
            .word 0,1,1,1,0,1,1,1,1,1,0,1
            .word 0,0,0,0,0,0,0,1,0,0,0,3
			// Fourth Obstacle Course
            .word 2,1,0,0,0,0,0,0,0,0,0,1
            .word 0,1,0,1,1,1,0,1,1,1,0,1
            .word 0,1,0,0,0,1,0,1,0,1,0,1
            .word 0,1,0,1,0,1,1,1,0,1,0,1
            .word 0,0,0,1,0,0,0,0,0,1,0,1
            .word 0,1,0,1,1,1,1,1,1,1,0,1
            .word 0,1,0,1,0,0,0,1,0,0,0,1
            .word 0,1,0,1,1,1,0,1,0,1,1,1
            .word 0,1,0,1,0,0,0,0,0,0,0,3
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
		MOV R5,#0
		MOV R6,#0
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
		CMP R3,#0x72
		BEQ MOVE_DOWN
		CMP R3,#0x75
		BEQ MOVE_UP
		CMP R3,#0x6b
		BEQ MOVE_LEFT
		CMP R3,#0x74
		BEQ MOVE_RIGHT
		B read_again
MOVE_DOWN:
		ADD R5,R5,#1
		CMP R5,#1
		BEQ mov1
		CMP R5,#2
		BEQ mov2
		CMP R5,#3
		BEQ mov3
		CMP R5,#4
		BEQ mov4
		CMP R5,#5
		BEQ mov5
		CMP R5,#6
		BEQ mov6
		CMP R5,#7
		BEQ mov7
		CMP R5,#8
		BEQ possibly_end_2
possibly_end_2:
		CMP R6,#11
		BEQ kill_2
		B mov7
kill_2:
		BL VGA_clear_charbuff_ASM
		BL draw_exit_ASM
		ADD R1,R1,#6
		BL VGA_write_char_ASM
		B end
mov1:
		ADD R1,R1,#6
		B move
mov2:
		ADD R1,R1,#7
		B move
mov3:
		ADD R1,R1,#6
		B move
mov4:
		ADD R1,R1,#7
		B move
mov5:
		ADD R1,R1,#6
		B move
mov6:
		ADD R1,R1,#7
		B move
mov7:
		ADD R1,R1,#6
		B move
move:
		BL VGA_clear_charbuff_ASM
		BL draw_exit_ASM
		BL VGA_write_char_ASM
		B read_again
MOVE_UP:
		SUB R5,R5,#1
		CMP R5,#1
		BEQ mov1_up
		CMP R5,#2
		BEQ mov2_up
		CMP R5,#3
		BEQ mov3_up
		CMP R5,#4
		BEQ mov4_up
		CMP R5,#5
		BEQ mov5_up
		CMP R5,#6
		BEQ mov6_up
		CMP R5,#7
		BEQ mov7_up
		CMP R5,#8
		BEQ end
		
mov1_up:
		SUB R1,R1,#6
		B move_up
mov2_up:
		SUB R1,R1,#7
		B move_up
mov3_up:
		SUB R1,R1,#6
		B move_up
mov4_up:
		SUB R1,R1,#7
		B move_up
mov5_up:
		SUB R1,R1,#6
		B move_up
mov6_up:
		SUB R1,R1,#7
		B move_up
mov7_up:
		SUB R1,R1,#6
		B move_up
move_up:
		BL VGA_clear_charbuff_ASM
		BL draw_exit_ASM
		BL VGA_write_char_ASM
		B read_again
MOVE_LEFT:
		SUB R6,R6,#1
		CMP R6,#1
		BEQ mov1_left
		CMP R6,#2
		BEQ mov2_left
		CMP R6,#3
		BEQ mov3_left
		CMP R6,#4
		BEQ mov4_left
		CMP R6,#5
		BEQ mov5_left
		CMP R6,#6
		BEQ mov6_left
		CMP R6,#7
		BEQ mov7_left
		CMP R6,#8
		BEQ mov8_left
		CMP R6,#9
		BEQ mov9_left
		CMP R6,#10
		BEQ mov10_left
		CMP R6,#11
		BEQ end
		
mov1_left:
		SUB R0,R0,#6
		B move_left
mov2_left:
		SUB R0,R0,#7
		B move_left
mov3_left:
		SUB R0,R0,#6
		B move_left
mov4_left:
		SUB R0,R0,#7
		B move_left
mov5_left:
		SUB R0,R0,#6
		B move_left
mov6_left:
		SUB R0,R0,#7
		B move_left
mov7_left:
		SUB R0,R0,#6
		B move_left
mov8_left:
		SUB R0,R0,#7
		B move_left
mov9_left:
		SUB R0,R0,#6
		B move_left
mov10_left:
		SUB R0,R0,#7
		B move_left
move_left:
		BL VGA_clear_charbuff_ASM
		BL draw_exit_ASM
		BL VGA_write_char_ASM
		B read_again
		
MOVE_RIGHT:
		ADD R6,R6,#1
		CMP R6,#1
		BEQ mov1_right
		CMP R6,#2
		BEQ mov2_right
		CMP R6,#3
		BEQ mov3_right
		CMP R6,#4
		BEQ mov4_right
		CMP R6,#5
		BEQ mov5_right
		CMP R6,#6
		BEQ mov6_right
		CMP R6,#7
		BEQ mov7_right
		CMP R6,#8
		BEQ mov8_right
		CMP R6,#9
		BEQ mov9_right
		CMP R6,#10
		BEQ mov10_right
		CMP R6,#11
		BEQ possibly_end
possibly_end:
		CMP R5,#8
		BEQ kill
		B mov10_right
kill:
		BL VGA_clear_charbuff_ASM
		BL draw_exit_ASM
		ADD R0,R0,#6
		BL VGA_write_char_ASM
		B end
mov1_right:
		ADD R0,R0,#7
		B move_right
mov2_right:
		ADD R0,R0,#6
		B move_right
mov3_right:
		ADD R0,R0,#7
		B move_right
mov4_right:
		ADD R0,R0,#6
		B move_right
mov5_right:
		ADD R0,R0,#7
		B move_right
mov6_right:
		ADD R0,R0,#6
		B move_right
mov7_right:
		ADD R0,R0,#7
		B move_right
mov8_right:
		ADD R0,R0,#6
		B move_right
mov9_right:
		ADD R0,R0,#7
		B move_right
mov10_right:
		ADD R0,R0,#6
		B move_right
move_right:
		BL VGA_clear_charbuff_ASM
		BL draw_exit_ASM
		BL VGA_write_char_ASM
		B read_again
	
draw_obstacles_ASM:
	PUSH {R4-R12, LR}
	MOV R0,#-1 //x
	MOV R1,#1 //y
	LDR R4,=input_mazes //was R3
	MOV R3,#216
	ADD R12,R3,#108
	MOV R9,R3
	MOV R5,#4
LOOP:
	ADD R0,R0,#1
	MUL R7,R3,R5
	ADD R8,R4,R7 //was R3
	LDR R6,[R8],#0
	CMP R6,#1
	BEQ setup
continue:
	ADD R3,R3,#1
	CMP R3,R12
	BEQ return 
	ADD R9,R9,#12
	CMP R3,R9
	SUB R9,R9,#12
	BLEQ reset_x_y
	ADD R9,R9,#24
	CMP R3,R9
	SUB R9,R9,#24
	BLEQ reset_x_y
	ADD R9,R9,#36
	CMP R3,R9
	SUB R9,R9,#36
	BLEQ reset_x_y
	ADD R9,R9,#48
	CMP R3,R9
	SUB R9,R9,#48
	BLEQ reset_x_y
	ADD R9,R9,#60
	CMP R3,R9
	SUB R9,R9,#60
	BLEQ reset_x_y
	ADD R9,R9,#72
	CMP R3,R9
	SUB R9,R9,#72
	BLEQ reset_x_y
	ADD R9,R9,#84
	CMP R3,R9
	SUB R9,R9,#84
	BLEQ reset_x_y
	ADD R9,R9,#96
	CMP R3,R9
	SUB R9,R9,#96
	BLEQ reset_x_y
	ADD R9,R9,#108
	CMP R3,R9
	SUB R9,R9,#108
	BLEQ reset_x_y
	MOV R7,#0
	B LOOP

return:
	POP {R4-R12,LR}
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

get_pixel:
		MOV R3,#0
		push {r4-r9,lr}
		LDR R7,=pixel_buffer
		LSL R4,R0,#1 //(x << 1)
		LSL R5,R1,#10 //(y << 10)
		ADD R8,R4,R5 // (y << 10) | (x << 1)
		ADD R3,R8,R7 //0xc8000000 | (y << 10) | (x << 1)
		pop {r4-r9,lr}
		
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
