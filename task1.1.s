.global _start
.equ SW_MEMORY, 0xFF200040
.equ LED_MEMORY, 0xFF200000
_start:

read_slider_switches_ASM:
    LDR R1, =SW_MEMORY
    LDR R0, [R1]
    B write_LEDs_ASM

write_LEDs_ASM:
    LDR R1, =LED_MEMORY
    STR R0, [R1]
    BX  LR
