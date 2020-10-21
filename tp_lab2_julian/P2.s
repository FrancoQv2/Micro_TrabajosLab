    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

dato1:
    .word   0x81000304,0x00200605
dato2:
    .word   0xA0560102

    .section .text
    .global reset
    .func main

reset:
    LDR R0,=dato2
    LDR R1,[R0]
    LDR R0,=dato1
loop:
    BL suma
    B  stop
suma:
    LDR R2,[R0]!
    LDR R3,[R0,#4]!
    ADCS R2,R2,R1
    IT  CS
    ADDCS R3,R3,#1
    STR   R3,[R0]
    STR   R2,[R0,#-4]
    BX  LR
stop:
    B stop
