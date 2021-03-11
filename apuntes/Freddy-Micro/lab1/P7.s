    .cpu cortex-m4
    .syntax unified
    .thumb
    .section .text
    .global reset
    .func main
reset:
    LDR  R1,=tabla
    MOV  R3,#0
lazo:
    CMP  R3,#9
    BHI  stop
    ADD R4,R3,R1
    LDRB R0,[R4]
    ADD R3,R3,#1
    B    lazo
stop:
    B    stop

    .pool

tabla:
    .byte 0x3F,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x6F
    .endfunc
