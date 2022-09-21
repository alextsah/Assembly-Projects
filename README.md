# Assembly

This repository is for storing code for ECSE324 Computer Organization. Labs 1,2 and 3 will be stored here to enable access to code during development from any device.

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
## Load/Store Instructions 
```
LDR Rd, <EA> // Rd <- Mem[EA] 
STR Rm, <EA> // Mem[EA] <- Rm 
