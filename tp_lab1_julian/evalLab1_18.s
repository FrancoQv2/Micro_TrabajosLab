    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

base:
    .byte 0x023,0x3,0x7

    .section .text
    .global reset
    .func main

reset:
    LDR R0,=base
loop:
//Obtengo el primer numero en BDC comprimido
    LDRB R1,[R0],#1
//Transformo los dos en BCD no comprimido a BCD comprimido
    LDRB R2,[R0],#1
    LSL  R2,R2,#4
    LDRB R3,[R0],#1
    ADD  R2,R2,R3
//Suma de ambos numeros
    ADD R4,R1,R2
    AND R5,R4,0xF0
    LSR R5,R5,#4
    AND R6,R4,0x0F
    CMP R5,#10
    IT PL           //Si la decena es >10 se le resta 10
    SUBPL R5,R5,#10
    CMP R6,#10
    ITT PL          //Si la unidad es >10 se le resta 10 y se suma 1 a la decena
    SUBPL R6,R6,#10
    ADDPL R5,R5,#1
    LSL R5,#4       
    ADD  R4,R5,R6
//Separo el numero ya sumado para convertirlo
    AND R5,R4,0xF0
    LSR R5,R5,#4
    AND R6,R4,0x0F
//Tomo la decena y la multiplico por 10, sumo unidad
    MOV R3,#10
    MUL R5,R5,R3
    ADD R5,R5,R6    //Numero en Binario
//Guardo datos en memoria en los lugares indicados
    LDR R0,=base
    STRB R2,[R0,#4]!
    STRB R4,[R0,#2]!
    STRB R5,[R0,#2]!
stop:
    B    stop

    .endfunc