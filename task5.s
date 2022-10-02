.global _start

input_image: .word 1057442138,  2410420899, 519339369,  2908788659, 1532551093, 4249151175, 4148718620, 788746931,  3777110853, 2023451652
.word 3000595192,   1424215634, 3130581119, 3415585405, 2359913843, 1600975764, 1368061213, 2330908780, 3460755284, 464067332
.word 2358850436,   1191202723, 2461113486, 3373356749, 3070515869, 4219460496, 1464115644, 3200205016, 1316921258, 143509283
.word 3846979011,   2393794600, 618297079,  2016233561, 3509496510, 1966263545, 568123240,  4091698540, 2472059715, 2420085477
.word 395970857,    2217766702, 44993357,   694287440,  2233438483, 1231031852, 2612978931, 1464238350, 3373257252, 2418760426
.word 4005861356,   288491815, 3533591053,  754133199,  3745088714, 2711399263, 2291899825, 2117953337, 1710526325, 1989628126
.word 465096977,    3100163617, 195551247,  3884399959, 422483884,  2154571543, 3380017320, 380355875,  4161422042, 654077379
.word 2168260534,   3266157063, 3870711524, 2809320128, 3980588369, 2342816349, 1283915395, 122534782,  4270863000, 2232709752
.word 1946888581,   1956399250, 3892336886, 1456853217, 3602595147, 1756931089, 858680934,  2326906362, 2258756188, 1125912976
.word 1883735002,   1851212965, 3925218056, 2270198189, 3481512846, 1685364533, 1411965810, 3850049461, 3023321890, 2815055881

empty: .space 4 
result:	.space 100
empty2: .space 4
red:	.space 100 
empty3: .space 4
green:	.space 100
empty4: .space 4
blue: 	.space 100
empty5: .space 4
alpha: 	.space 100

_start:
	LDR R1,=input_image
	MOV R2, #0 //R2=j
	MOV R3, #0 //R3=i
	MOV R6,#5
	MOV R7,#0 //increment this by 1 to get next window 
	MOV R8,#0
	LDR R4,=result 
	B innerloop
top:
	ADD R2,R2,#1
	CMP R2,#5
	BGE populateRed
	MOV R3,#0
	ADD R7,R7,R6
innerloop:
	CMP R3,#4
	BGT top
	LDR R5,[R1,R7,LSL#2]
	STR R5,[R4,R8,LSL#2]
	ADD R8,R8,#1
	ADD R7,R7,#1
	ADD R3,R3,#1
	B innerloop

populateRed:
	LDR R4,=result
	LDR R5,=red
	MOV R2,#0
top2:
	CMP R2,#25
	BGE populateGreen
	LDR R3, [R4,R2,LSL#2]
	LSR R3,#24
	STR R3, [R5,R2,LSL#2]
	ADD R2,R2,#1
	B top2
	
populateGreen:
	LDR R4,=result
	LDR R5,=green
	MOV R2,#0
top3:
	CMP R2,#25
	BGE populateBlue
	LDR R3, [R4,R2,LSL#2]
	LSR R3,#16
	STR R3, [R5,R2,LSL#2]
	LDRB R6,[R5,R2,LSL#2]
	STR R6, [R5,R2,LSL#2]
	ADD R2,R2,#1
	B top3
	
populateBlue:
	LDR R4,=result
	LDR R5,=blue
	MOV R2,#0
top4:
	CMP R2,#25
	BGE populateAlpha
	LDR R3, [R4,R2,LSL#2]
	LSR R3,#8
	STR R3, [R5,R2,LSL#2]
	LDRB R6,[R5,R2,LSL#2]
	STR R6, [R5,R2,LSL#2]
	ADD R2,R2,#1
	B top4
	
populateAlpha:
	LDR R4,=result
	LDR R5,=alpha
	MOV R2,#0
top5:
	CMP R2,#25
	BGE sortRed
	LDR R3, [R4,R2,LSL#2]
	LSR R3,#0
	STR R3, [R5,R2,LSL#2]
	LDRB R6,[R5,R2,LSL#2]
	STR R6, [R5,R2,LSL#2]
	ADD R2,R2,#1
	B top5

sortRed:
	LDR R0,=red //pointer to array a.k.a base address of array 
	MOV R1,#25 //length of array (n)
	MOV R2,#1 //index i=1
TOPRED:
	CMP R2,R1 //R2-R1=i-n
	BLT OUTERLOOPRED //if R2<R1 => i<n then branch 
	B sortGreen
OUTERLOOPRED: 
	LDR R3,[R0,R2,LSL#2] //R3=value=arr[i]
	MOV R4, R2 //R4=j=i
INNERLOOP2CRED:
	CMP R4,#0 //R4-0
	BGT INNERLOOP1RED //if R4-0>0 => R4>0 =>j>0 then branch 
	STR R3, [R0,R4,LSL#2]// arr[j] = value
	ADD R2,R2,#1//i = i+1
	B TOPRED
INNERLOOP1RED:
	SUB R5,R4,#1 //R5 = j-1
	LDR R6,[R0,R5,LSL#2] //R6=arr[j-1]
	CMP R6,R3//R6-R3 = arr[j-1]-value
	BGT INNERLOOP2RED//if arr[j-1]-value>0 => arr[j-1]>value then branch 
	STR R3, [R0,R4,LSL#2]// arr[j] = value
	ADD R2,R2,#1//i = i+1
	B TOPRED
INNERLOOP2RED:
	STR R6,[R0,R4,LSL#2]//arr[j]=arr[j-1]
	MOV R7,R3
	STR R7,[R0,R5,LSL#2]
	SUB R4,R4,#1//R6=R6-1 => j=j-1
	B INNERLOOP2CRED

sortGreen:
	LDR R0,=green //pointer to array a.k.a base address of array 
	MOV R1,#25 //length of array (n)
	MOV R2,#1 //index i=1
TOPGREEN:
	CMP R2,R1 //R2-R1=i-n
	BLT OUTERLOOPGREEN //if R2<R1 => i<n then branch 
	B sortBlue
OUTERLOOPGREEN: 
	LDR R3,[R0,R2,LSL#2] //R3=value=arr[i]
	MOV R4, R2 //R4=j=i
INNERLOOP2CGREEN:
	CMP R4,#0 //R4-0
	BGT INNERLOOP1GREEN //if R4-0>0 => R4>0 =>j>0 then branch 
	STR R3, [R0,R4,LSL#2]// arr[j] = value
	ADD R2,R2,#1//i = i+1
	B TOPGREEN
INNERLOOP1GREEN:
	SUB R5,R4,#1 //R5 = j-1
	LDR R6,[R0,R5,LSL#2] //R6=arr[j-1]
	CMP R6,R3//R6-R3 = arr[j-1]-value
	BGT INNERLOOP2GREEN//if arr[j-1]-value>0 => arr[j-1]>value then branch 
	STR R3, [R0,R4,LSL#2]// arr[j] = value
	ADD R2,R2,#1//i = i+1
	B TOPGREEN
INNERLOOP2GREEN:
	STR R6,[R0,R4,LSL#2]//arr[j]=arr[j-1]
	MOV R7,R3
	STR R7,[R0,R5,LSL#2]
	SUB R4,R4,#1//R6=R6-1 => j=j-1
	B INNERLOOP2CGREEN
	
sortBlue:
	LDR R0,=blue //pointer to array a.k.a base address of array 
	MOV R1,#25 //length of array (n)
	MOV R2,#1 //index i=1
TOPBLUE:
	CMP R2,R1 //R2-R1=i-n
	BLT OUTERLOOPBLUE //if R2<R1 => i<n then branch 
	B sortAlpha
OUTERLOOPBLUE: 
	LDR R3,[R0,R2,LSL#2] //R3=value=arr[i]
	MOV R4, R2 //R4=j=i
INNERLOOP2CBLUE:
	CMP R4,#0 //R4-0
	BGT INNERLOOP1BLUE //if R4-0>0 => R4>0 =>j>0 then branch 
	STR R3, [R0,R4,LSL#2]// arr[j] = value
	ADD R2,R2,#1//i = i+1
	B TOPBLUE
INNERLOOP1BLUE:
	SUB R5,R4,#1 //R5 = j-1
	LDR R6,[R0,R5,LSL#2] //R6=arr[j-1]
	CMP R6,R3//R6-R3 = arr[j-1]-value
	BGT INNERLOOP2BLUE//if arr[j-1]-value>0 => arr[j-1]>value then branch 
	STR R3, [R0,R4,LSL#2]// arr[j] = value
	ADD R2,R2,#1//i = i+1
	B TOPBLUE
INNERLOOP2BLUE:
	STR R6,[R0,R4,LSL#2]//arr[j]=arr[j-1]
	MOV R7,R3
	STR R7,[R0,R5,LSL#2]
	SUB R4,R4,#1//R6=R6-1 => j=j-1
	B INNERLOOP2CBLUE
	
sortAlpha:
	LDR R0,=alpha //pointer to array a.k.a base address of array 
	MOV R1,#25 //length of array (n)
	MOV R2,#1 //index i=1
TOPALPHA:
	CMP R2,R1 //R2-R1=i-n
	BLT OUTERLOOPALPHA //if R2<R1 => i<n then branch 
	B getResult
OUTERLOOPALPHA: 
	LDR R3,[R0,R2,LSL#2] //R3=value=arr[i]
	MOV R4, R2 //R4=j=i
INNERLOOP2CALPHA:
	CMP R4,#0 //R4-0
	BGT INNERLOOP1ALPHA //if R4-0>0 => R4>0 =>j>0 then branch 
	STR R3, [R0,R4,LSL#2]// arr[j] = value
	ADD R2,R2,#1//i = i+1
	B TOPALPHA
INNERLOOP1ALPHA:
	SUB R5,R4,#1 //R5 = j-1
	LDR R6,[R0,R5,LSL#2] //R6=arr[j-1]
	CMP R6,R3//R6-R3 = arr[j-1]-value
	BGT INNERLOOP2ALPHA//if arr[j-1]-value>0 => arr[j-1]>value then branch 
	STR R3, [R0,R4,LSL#2]// arr[j] = value
	ADD R2,R2,#1//i = i+1
	B TOPALPHA
INNERLOOP2ALPHA:
	STR R6,[R0,R4,LSL#2]//arr[j]=arr[j-1]
	MOV R7,R3
	STR R7,[R0,R5,LSL#2]
	SUB R4,R4,#1//R6=R6-1 => j=j-1
	B INNERLOOP2CALPHA
	
getResult:
	LDR R1,=red
	LDR R2,=green
	LDR R3,=blue
	LDR R4,=alpha
	MOV R5,#12 //median is 12th 
	LDR R6,[R1,R5,LSL#2] //median red
	LSL R6, #24
	LDR R7,[R2,R5,LSL#2] //median green
	LSL R7, #16
	LDR R8,[R3,R5,LSL#2] //median blue
	LSL R8, #8
	LDR R9,[R4,R5,LSL#2] //median alpha
	LSL R9, #0
	ADD R6,R6,R7
	ADD R6,R6,R8
	ADD R6,R6,R9 //result 
	B end 
end: .end
