# Assembly Fundamentals 

This repository is for storing code for ECSE324 Computer Organization. Labs 1,2 and 3 will be stored here to enable access to code during development from any device.
To access the simulator use: http://ecse324.ece.mcgill.ca/simulator/?sys=arm-de1soc

## Assembler Directives 
Always start your program with: 
```
.global _start
_start:
```
To store a variable in memory: 
```
n:    .word 6
```
To access this variable later (i.e. assign it to a register) : 
```
.global _start
n:    .word 6

_start:
  LDR R0, n //put value of n(=6) into register R0
``` 
To end your program always place (at the very bottom): 
```
  .end
```

## Arithmetic Instructions 

```
ADD R1, R2, R3 // R1 <- R2 + R3
ADD R1, R2, #4 // R1 <- R2 + 4
ADD R0, R1, R2 // R0 <- R1 + R2 
SUB R1, R2, #8 // R1 <- R2 - 8
MUL R1, R2, R3 // R1 <- R2 * R3
MLA R2, R3, R4, R5 // R2 <- (R3 * R4) + 5

```
## Logic Instructions 
```
AND Rd, Rn, Op2 // bitwise AND operation 
ORR Rd, Rn, Op2 // bitwise OR operation 
EOR Rd, Rn, Op2 // bitwise XOR operation 
BIC Rd, Rn, Op2 // BIt Clear: Rd <- Rn AND NOT(Op2) 
```
## Move Instructions 
```
MOV Rd, Op2 // Moves value of Op2 into Rd
MOV Rd, #5 // Moves 5 (16-bit value) into Rd
MVN Rd, Op2 // Moves NOT of Op2 value into Rd
```
## Load Instructions 
```
LDR Rd, <EA> // Rd <- Mem[EA] 
LDR R4, [R1, R2] // R4 <- Mem[R1 + R2]
LDR R4, [R1, R0, LSL#2] // R4 <- Mem[R1+R0<<2]
```

## Store Instructions 
```
STR Rm, <EA> // Mem[EA] <- Rm 
STR R1, x // x <- R1 
STR R4, [R1, R0, LSL#2] // Mem[R1+R0<<2] <- R4
```
