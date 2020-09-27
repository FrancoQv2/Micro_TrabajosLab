    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data
tam:
    .byte 5
bloque:
    .byte 0x32,0x3A,0x21,0x1F,0x11
base:
    .byte 0x00,0x00,0x00,0x00,0x00
checksum:
    .byte 0x00

    .section .text
    .global reset
    .func main

reset:
    LDR     R3,=tam     //Apunto R3 a tam
    LDRB    R0,[R3]     //Guardo en R0 el tam del bloque
    LDR     R1,=bloque  //Apunto R1 al bloque
    LDR     R3,=base    //Apunto R3 a base
    STR     R1,[R3]     //Guardo en M[R3] (base) La direccion del bloque
    MOV     R2,#0       //Checksum
    MOV     R3,#0       //Contador
loop:
    LDRB R4,[R1],#1     //Leo del bloque
    CMP R3,R0
    BEQ final
    ADD R2,R2,R4
    ADD R3,R3,#1
    B loop
final:
    LDR R3,=base        //Apunto R3 a base
    STR R2,[R3,#4]!     //Guardo el checksum en base+4
stop:
    B stop

    .endfunc