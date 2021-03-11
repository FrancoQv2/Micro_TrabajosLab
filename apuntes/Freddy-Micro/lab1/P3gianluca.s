    .cpu cortex-m4 
    .syntax unified
    .thumb
    .section .data
cadena: 
    .byte 0x06,0x7A,0x7B,0x7C,0x00     
    .section .text          
    .global reset           
    .func main              
reset:
    LDR R0,=cadena
    LDRB R1,[R0],#1
    MOV R4,#0
    MOV R3,#0
bucle:
    CMP R3,#8
    BEQ stop
    AND R2,R1,#0x01
    ADD R4,R4,R2
    ADD R3,R3,#1
    LSR R1,R1,#1
    B bucle
stop:
    B stop
