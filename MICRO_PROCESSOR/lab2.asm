DATA SEGMENT
    BUFFER DB 100 DUP(?)
    N      DB 1 DUP(?)
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA
START:
    MOV AX, DATA
    MOV DS, AX
    MOV BX, AX
    MOV AX, 0000H
    LEA DI, N
    MOV AH, 01H
    INT 21H
    MOV DL, AL
    SUB DL, 30H
    MOV [DI], DL
    MOV DL, 0AH
    MOV AH, 02H
    INT 21H 
;calculate N^2
    MOV BX, AX
    MUL BL
    LEA DI, BUFFER
    MOV BX, AX
    MOV AL, 01H
INITIALIZE:
    MOV [DI], AL
    INC AL
    INC DI
    CMP AL, BL
    JLE INITIALIZE
    JG OUTPUT
OUTPUT:
    MOV CL, 0
    MOV BL, 1
    MOV SI, OFFSET BUFFER
    MOV DL, 0AH
    MOV AH, 02H
    INT 21H 
WHILE:
    CMP CL, BL
    JL PRINT
    JGE NEWLINE   

PRINT:
    MOV AX, 0000H
    MOV DL, [SI]
    CMP DL, 0AH
    JGE ABOVETEN
    
    ADD DL, 30H ;to ASCII
    MOV AH, 02H
    INT 21H

    MOV DL, 20H
    MOV AH, 02H
    INT 21H  
    
    INC CL
    INC SI
    JMP WHILE

ABOVETEN:
    MOV AX, 0000H
    MOV DL, [SI]
MINUS:
    INC AL
    SUB DL, 0AH
    JNS MINUS
    
    SUB AL, 01H
    ADD DL, 0AH
    ADD DL, 30H
    MOV DH, DL
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 02H
    INT 21H ;tens place
    MOV DL, DH
    MOV AH, 02H
    INT 21H ;ones place
    MOV DL, 20H
    MOV AH, 02H
    INT 21H
    INC CL
    INC SI
    JMP WHILE

NEWLINE:
    MOV AX, 0000H
    MOV DL, 0AH
    MOV AH, 02H
    INT 21H 
    CMP BL, [N]
    JE EXIT
    MOV AX, 0000H
    LEA SI, N
    MOV AL, [SI]
    LEA SI, BUFFER
    MUL BL
    INC BL
    ADD SI, AX
    MOV CL, 0
    JMP WHILE
EXIT:
    MOV AX,4C00H
    INT 21H
CODE ENDS
END START

