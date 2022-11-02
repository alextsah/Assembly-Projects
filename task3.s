.section .vectors, "ax"
B _start
B SERVICE_UND       // undefined instruction vector
B SERVICE_SVC       // software interrupt vector
B SERVICE_ABT_INST  // aborted prefetch vector
B SERVICE_ABT_DATA  // aborted data vector
.word 0 // unused vector
B SERVICE_IRQ       // IRQ interrupt vector
B SERVICE_FIQ       // FIQ interrupt vector

.global _start

PB_int_flag : .word 0x0
tim_int_flag : .word 0x0

.equ PUSHBUTTONS, 0xFF200050 
.equ PBEDGECAPTURE, 0xFF20005C
.equ PBINTERRUPT, 0xFF200058

.equ TIMERLOAD, 0xFFFEC600
.equ TIMERCOUNTER, 0xFFFEC604
.equ TIMERCONTROL, 0xFFFEC608
.equ TIMERINTERUP, 0xFFFEC60C

.equ HEX0_3, 0xFF200020
.equ HEX4_5, 0xFF200030

PB0: .word 0x00000001
PB1: .word 0x00000002
PB2: .word 0x00000004
PB3: .word 0x00000008

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
	 /* Set up stack pointers for IRQ and SVC processor modes */
    MOV    R1, #0b11010010      // interrupts masked, MODE = IRQ
    MSR    CPSR_c, R1           // change to IRQ mode
    LDR    SP, =0xFFFFFFFF - 3  // set IRQ stack to A9 onchip memory
    /* Change to SVC (supervisor) mode with interrupts disabled */
    MOV    R1, #0b11010011      // interrupts masked, MODE = SVC
    MSR    CPSR, R1             // change to supervisor mode
    LDR    SP, =0x3FFFFFFF - 3  // set SVC stack to top of DDR3 memory
    BL     CONFIG_GIC           // configure the ARM GIC
    // To DO: write to the pushbutton KEY interrupt mask register
    // Or, you can call enable_PB_INT_ASM subroutine from previous task
	MOV R0,#0b0111
	BL enable_PB_INT_ASM
    // to enable interrupt for ARM A9 private timer, use ARM_TIM_config_ASM subroutine
	LDR R1,=2000000000
	MOV R2,#0b111
	BL ARM_TIM_config_ASM
	
    LDR    R0, =0xFF200050      // pushbutton KEY base address
    MOV    R1, #0xF             // set interrupt mask bits
    STR    R1, [R0, #0x8]       // interrupt mask register (base + 8)
    // enable IRQ interrupts in the processor
    MOV    R0, #0b01010011      // IRQ unmasked, MODE = SVC
    MSR    CPSR_c, R0
IDLE:
	MOV R5,#0
	MOV R6,#0
	MOV R7,#0
	MOV R8,#0
	MOV R9,#0
	MOV R10,#0
	MOV R0,#0x3f
	MOV R1,#0
	BL HEX_write_ASM
	
start:
	MOV R5,#1
	B begin 
	
start_min:
	MOV R5,#1
	MOV R7,#0
	B begin 
	
start_hour:
	MOV R5,#1
	MOV R7,#0
	MOV R9,#0
	B begin
	
begin:

increment_mili:
	MOV R1,R5
	MOV R0,#0x01
	BL HEX_write_ASM
	ADD R5,R5,#1
	CMP R5,#11
	BEQ reset_mili
	B begin
	
reset_mili:
	ADD R6,R6,#1
	MOV R5,#0
	MOV R1,R5
	MOV R0,#0x01
	BL HEX_write_ASM
	B increment_seconds
	
increment_seconds:
	CMP R6,#10
	BEQ reset_seconds
	MOV R1,R6
	MOV R0,#0x02
	BL HEX_write_ASM
	B start

reset_seconds:
	ADD R7,R7,#1
	MOV R6,#0
	MOV R1,R6
	MOV R0,#0x02
	BL HEX_write_ASM
	B increment_seconds2

increment_seconds2:
	CMP R7,#6
	BEQ reset_seconds2
	MOV R1,R7
	MOV R0,#0x04
	BL HEX_write_ASM
	B start
	
reset_seconds2:
	ADD R8,R8,#1
	MOV R7,#0
	MOV R1,R7
	MOV R0,#0x04
	BL HEX_write_ASM
	MOV R1,R6
	MOV R0,#0X02
	BL HEX_write_ASM
	B increment_minutes
	
increment_minutes:
	CMP R8,#10
	BEQ reset_minutes
	MOV R1,R8
	MOV R0,#0x08
	BL HEX_write_ASM
	B start_min

reset_minutes:
	ADD R9,R9,#1
	MOV R8,#0
	MOV R1,R8
	MOV R0,#0x08
	BL HEX_write_ASM
	B increment_minutes2
	
increment_minutes2:
	CMP R9,#6
	BEQ reset_minutes2
	MOV R1,R9
	MOV R0,#0x10
	BL HEX_write_ASM
	B start_min
	
reset_minutes2:
	ADD R10,R10,#1
	MOV R9,#0
	MOV R1,R9
	MOV R0,#0x10
	BL HEX_write_ASM
	MOV R1,R8
	MOV R0,#0X08
	BL HEX_write_ASM
	B increment_hours

increment_hours:
	CMP R10,#10
	BEQ end
	MOV R1,R10
	MOV R0,#0x20
	BL HEX_write_ASM
	B start_hour
	B IDLE 

/*--- Undefined instructions ---------------------------------------- */
SERVICE_UND:
    B SERVICE_UND
/*--- Software interrupts ------------------------------------------- */
SERVICE_SVC:
    B SERVICE_SVC
/*--- Aborted data reads -------------------------------------------- */
SERVICE_ABT_DATA:
    B SERVICE_ABT_DATA
/*--- Aborted instruction fetch ------------------------------------- */
SERVICE_ABT_INST:
    B SERVICE_ABT_INST
/*--- IRQ ----------------------------------------------------------- */
SERVICE_IRQ:
    PUSH {R0-R7, LR}
/* Read the ICCIAR from the CPU Interface */
    LDR R4, =0xFFFEC100
    LDR R5, [R4, #0x0C] // read from ICCIAR

/* To Do: Check which interrupt has occurred (check interrupt IDs)
   Then call the corresponding ISR
   If the ID is not recognized, branch to UNEXPECTED 
   See the assembly example provided in the De1-SoC Computer_Manual on page 46 */     
Pushbutton_check:
    CMP R5, #73
UNEXPECTED:
    BNE UNEXPECTED      // if not recognized, stop here
    BL KEY_ISR
EXIT_IRQ:
Timer_check:
	CMP R5,#29
UNEXPECTED2:
    BNE UNEXPECTED2
	BL ARM_TIM_ISR
/* Write to the End of Interrupt Register (ICCEOIR) */
    STR R5, [R4, #0x10] // write to ICCEOIR
    POP {R0-R7, LR}
SUBS PC, LR, #4
/*--- FIQ ----------------------------------------------------------- */
SERVICE_FIQ:
    B SERVICE_FIQ

CONFIG_GIC:
    PUSH {LR}
/* To configure the FPGA KEYS interrupt (ID 73):
* 1. set the target to cpu0 in the ICDIPTRn register
* 2. enable the interrupt in the ICDISERn register */
/* CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1)); */
/* To Do: you can configure different interrupts
   by passing their IDs to R0 and repeating the next 3 lines */  
    MOV R0, #73            // KEY port (Interrupt ID = 73)
    MOV R1, #1             // this field is a bit-mask; bit 0 targets cpu0
    BL CONFIG_INTERRUPT
	MOV R0, #29            // KEY port (Interrupt ID = 29)
    MOV R1, #1             // this field is a bit-mask; bit 0 targets cpu0
    BL CONFIG_INTERRUPT

/* configure the GIC CPU Interface */
    LDR R0, =0xFFFEC100    // base address of CPU Interface
/* Set Interrupt Priority Mask Register (ICCPMR) */
    LDR R1, =0xFFFF        // enable interrupts of all priorities levels
    STR R1, [R0, #0x04]
/* Set the enable bit in the CPU Interface Control Register (ICCICR).
* This allows interrupts to be forwarded to the CPU(s) */
    MOV R1, #1
    STR R1, [R0]
/* Set the enable bit in the Distributor Control Register (ICDDCR).
* This enables forwarding of interrupts to the CPU Interface(s) */
    LDR R0, =0xFFFED000
    STR R1, [R0]
    POP {PC}

/*
* Configure registers in the GIC for an individual Interrupt ID
* We configure only the Interrupt Set Enable Registers (ICDISERn) and
* Interrupt Processor Target Registers (ICDIPTRn). The default (reset)
* values are used for other registers in the GIC
* Arguments: R0 = Interrupt ID, N
* R1 = CPU target
*/
CONFIG_INTERRUPT:
    PUSH {R4-R5, LR}
/* Configure Interrupt Set-Enable Registers (ICDISERn).
* reg_offset = (integer_div(N / 32) * 4
* value = 1 << (N mod 32) */
    LSR R4, R0, #3    // calculate reg_offset
    BIC R4, R4, #3    // R4 = reg_offset
    LDR R2, =0xFFFED100
    ADD R4, R2, R4    // R4 = address of ICDISER
    AND R2, R0, #0x1F // N mod 32
    MOV R5, #1        // enable
    LSL R2, R5, R2    // R2 = value
/* Using the register address in R4 and the value in R2 set the
* correct bit in the GIC register */
    LDR R3, [R4]      // read current register value
    ORR R3, R3, R2    // set the enable bit
    STR R3, [R4]      // store the new register value
/* Configure Interrupt Processor Targets Register (ICDIPTRn)
* reg_offset = integer_div(N / 4) * 4
* index = N mod 4 */
    BIC R4, R0, #3    // R4 = reg_offset
    LDR R2, =0xFFFED800
    ADD R4, R2, R4    // R4 = word address of ICDIPTR
    AND R2, R0, #0x3  // N mod 4
    ADD R4, R2, R4    // R4 = byte address in ICDIPTR
/* Using register address in R4 and the value in R2 write to
* (only) the appropriate byte */
    STRB R1, [R4]
    POP {R4-R5, PC}
	
KEY_ISR:
    LDR R0, =0xFF200050    // base address of pushbutton KEY port
    LDR R1, [R0, #0xC]     // read edge capture register
	LDR R2, =PB_int_flag
	STR R1, [R2]
    MOV R2, #0xF
    STR R2, [R0, #0xC]     // clear the interrupt
    
END_KEY_ISR:
    BX LR

ARM_TIM_ISR:
	MOV R0,#1
	LDR R2,=tim_int_flag
	STR R0,[R2]
	LDR R0,=0xFFFEC60C
	MOV R1,#0xF
	STR R1,[R0]

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
	STR R2,[R8]
	STR R3,[R9]
	POP {R2-R12}
	BX LR
	
ARM_TIM_config_ASM:
	PUSH {R3-R4}
	LDR R3,=TIMERLOAD
	STR R1,[R3]
	LDR R4,=TIMERCONTROL
	STR R2,[R4]
	POP {R3-R4}
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
	
