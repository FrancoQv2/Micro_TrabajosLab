    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

//lista:
//    .byte 0xA0,0x83,0x1B,0x85,0xF3
listaord:
    .byte 0x1B,0x83,0x85,0xA0,0xF3
listatam:
    .byte 0x05

    .section .text
    .global reset
    .func main
reset:
    LDR R0,=listaord
    LDR R1,=listatam
    LDRB R1,[R1]
    MOV R2,0x05
    PUSH {R2}
loop:
    BL insertar
    //BL sort
final:
    B final
    .endfunc


    .func sort
sort:
    PUSH {R4-R6}
    PUSH {R0}
    MOV R2,#1           //Perm
sortt:
    POP {R0}
    PUSH {R0}
    MOV R3,#0           //Contador
    CMP R2,#0
    BEQ final
    MOV R2,#0
while:    
    CMP R3,R1
    BEQ sortt
    LDRB R4,[R0],#1
    LDRB R5,[R0],#0
    ADD R3,#1
    CMP R4,R5
    BHI intercambio
despuesintercambio:
    B while

intercambio:
    MOV R6,R4
    MOV R4,R5
    MOV R5,R6
    STRB R5,[R0],#-1
    STRB R4,[R0],#1
    MOV R2,#1
    B despuesintercambio

finintercambio:
    POP {R0}
    POP {R4-R6}
    BX LR
    .endfunc

    .func insertar
insertar:
    PUSH {R1,R4}
    MOV R4,#0
    LDRB R2,[SP,#8]
    ADD  R1,R1,R0
loopinsertar:
    CMP R1,R0
    BEQ finalinsertar
    LDRB R3,[R1,#-1]!
    ADD R1,#1
    CMP R2,R3
    ITTE HI
    STRBHI R2,[R1],#0
    MOVHI R4,#1
    STRBLS R3,[R1],#0
    CMP R4,#1
    BEQ finalinsertar
    SUB R1,#1
    B loopinsertar
finalinsertar:
    CMP R4,#0
    IT EQ
    STRBEQ R2,[R1],#0
    POP {R1,R4}
    ADD R1,#1
    BX LR
    .endfunc

