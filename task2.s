.global _start
.equ pixel_buffer,0xc8000000
.equ character_buffer,0xc9000000
.equ PS2_data, 0xff200100
_start:
        bl      input_loop
end:
        b       end

@ TODO: copy VGA driver here.
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

VGA_clear_pixelbuff_ASM:
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
		push {r2,lr}
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
		pop {r2,lr}
		BX LR

@ TODO: insert PS/2 driver here.
read_PS2_data_ASM:
		PUSH {R1-R3,LR}
 		LSR R1,R0,#15
		AND R2,R1,#0b1
		CMP R1,#1
		BEQ VALID
		B NOT_VALID
VALID:
		LDR R3,[R0]
		STR R3,[R0]
		MOV R0,#1
		POP {R1-R3,LR}
		BX LR
NOT_VALID:
		MOV R0,#0
		POP {R1-R3,LR}
		BX LR
write_hex_digit:
        push    {r4, lr}
        cmp     r2, #9
        addhi   r2, r2, #55
        addls   r2, r2, #48
        and     r2, r2, #255
        bl      VGA_write_char_ASM
        pop     {r4, pc}
write_byte:
        push    {r4, r5, r6, lr}
        mov     r5, r0
        mov     r6, r1
        mov     r4, r2
        lsr     r2, r2, #4
        bl      write_hex_digit
        and     r2, r4, #15
        mov     r1, r6
        add     r0, r5, #1
        bl      write_hex_digit
        pop     {r4, r5, r6, pc}
input_loop:
        push    {r4, r5, lr}
        sub     sp, sp, #12
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r4, #0
        mov     r5, r4
        b       .input_loop_L9
.input_loop_L13:
        ldrb    r2, [sp, #7]
        mov     r1, r4
        mov     r0, r5
        bl      write_byte
        add     r5, r5, #3
        cmp     r5, #79
        addgt   r4, r4, #1
        movgt   r5, #0
.input_loop_L8:
        cmp     r4, #59
        bgt     .input_loop_L12
.input_loop_L9:
        add     r0, sp, #7
        bl      read_PS2_data_ASM
        cmp     r0, #0
        beq     .input_loop_L8
        b       .input_loop_L13
.input_loop_L12:
        add     sp, sp, #12
        pop     {r4, r5, pc}
