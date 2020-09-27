    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

bloque:
    .byte 0x0,0x03,0x3A,0xF2,0xAA

    .section .text
    .global reset
    .func main

reset:
    LDR R0,=bloque      //Apunto R0 al inicio del bloque
    LDRB R1,[R0,#1]!    //Cargo en R1 base (Tamaño del bloque)
    LDRB R2,[R0,#1]!    //Cargo en R2 el primer elemento del bloque
    MOV R4,#0           //R4 contador en 0

loop:
    LDRB R3,[R0],#1     //Tomo en R3 un auxiliar para ir comparando
    CMP  R1,R4          //Condicion de parada, recorrer bloque
    BEQ  final
    CMP  R2,R3
    IT   MI             //MI flag N (negativo)
    MOVMI R2,R3
    ADD R4,0x01
    B loop

final:
    LDR R0,=bloque      //Apunto R0 al inicio del bloque
    STRB R2,[R0]
stop:
    B stop