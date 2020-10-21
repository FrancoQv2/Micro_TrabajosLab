    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data
dividendo:
    .hword 0x00F3
divisor:
    .hword 0x00F3

    .section .text
    .global reset
    .func main
reset:
    LDR R0,=dividendo
    LDRH R1,[R0]
    LDR R0,=divisor
    LDRH R2,[R0]
loop:
    BL modulo
final:
    B final
    .endfunc

    .func modulo      
modulo:
    UDIV R0,R1,R2
    MUL R3,R0,R2    
    SUB R0,R1,R3
finalmodulo:
    BX LR
    .endfunc     

