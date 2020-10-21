    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

lista:
    .byte 0xA0,0x83,,0x1B,0x85,0xF3
listatam:
    .byte 0x05

    .section .text
    .global reset
    .func main

reset:
    MOV R0,#12
    MOV R1,#24
    PUSH {R0,R1}
    MOV R0,#0
    MOV R1,#0
    POP {R1,R0}
stop:
    B stop