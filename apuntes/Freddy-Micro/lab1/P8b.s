    .cpu cortex-m4
    .syntax unified
    .thumb
    .section .text
    .global reset
    .func main
reset:
    MOV R1,#145
    MOV R2,#1
    MOV R4,#2
    MOV R5,#0
lazo:
    MUL R3,R2,R4
    SUB R3,R3,#1
    ADD R5,R5,R3
    CMP R5,R1
    BLO aumentar
    B stop
aumentar:
    MOV R0,R5
    ADD R2,R2,#1
    B lazo
stop:
    B stop
