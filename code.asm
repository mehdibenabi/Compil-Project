DATA SEGMENT
A DW 0
B DW 0
C DW 327
D DW 0
I DW 0
N DW 0
T0 DW 0
T1 DW 0
T2 DW 0
T3 DW 0
T4 DW 0
T5 DW 0
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA
START:
MOV AX, DATA
MOV DS, AX

; Opération non supportée: (BOUNDS, , , 6)

; Opération non supportée: (ADEC, T, empty, empty)

; t2 = A * B
MOV AX, A
MOV BX, B
MUL BX
MOV t2, AX

; t3 = C * A
MOV AX, C
MOV BX, A
MUL BX
MOV t3, AX

; t4 = t3 * B
MOV AX, t3
MOV BX, B
MUL BX
MOV t4, AX

; 31 = t2 + t4
MOV AX, t2
ADD AX, t4
MOV 31, AX

; D = t5
MOV AX, t5
MOV D, AX

; Opération non supportée: (>=, A, B, ge7)

; Opération non supportée: (BZ, 15, ge7, vide)

; D = 31
MOV AX, 31
MOV D, AX

; Opération non supportée: (BR, 16, vide, vide)

; D = 5
MOV AX, 5
MOV D, AX

; I = 2
MOV AX, 2
MOV I, AX

; Opération non supportée: (<, 2, 6, t17)

; Opération non supportée: (BZ, , t17, vide)

; N = 6
MOV AX, 6
MOV N, AX

; Opération non supportée: (BZ, 28, ge7, vide)

; Opération non supportée: (BR, 29, vide, vide)

; I = 2 + 1
MOV AX, 2
ADD AX, 1
MOV I, AX

; Opération non supportée: (BR, , vide, 17)

MOV AH, 4CH
INT 21H
CODE ENDS
END START
