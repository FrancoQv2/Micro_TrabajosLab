    .cpu cortex-m4
    .syntax unified
    .thumb
    .section .data
tabla:
    .space 512,0xFF
    .section .text
    .global reset
    .func main
reset:
    MOV R1,#145
    LDR R2,=tabla
    MOV R3,#1
    MOV R4,R2
lazo1:
    MUL R5,R3,R3
    CMP R3,#256
    BLO aumentar
    MOV R3,#1
lazo2:
    LDRH R5,[R2]
    CMP R5,R1
    BLO siguiente
    B stop
siguiente:
    MOV R0,R3
    ADD R3,R3,#1
    ADD R2,R2,#2
    B lazo2
aumentar:
    STRH R5,[R4],#2
    ADD R3,R3,#1
    B lazo1
stop:
    B stop
