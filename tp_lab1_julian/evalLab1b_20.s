    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data
/* Utilizo los numeros en complemento A2 */
vector:
    .byte 0x13,0xA2,0xF2,0x13,0x44,0xB4,0x00
/*
Resultado
Posicion        Nombre          Valiniial   Contenido
resultado       Contpares       0           Cantidad de numeros pares en el vector
resutlado+1     Contimpares     0           Cantidad de numeros impares en el vector
resultado+2     Contpositivos   0           Cantidad de numeros positivos en el vector
resultado+3     Contnegativos   0           Cantidad de numeros negativos en el vector
 */
resultado:
    .space 4,0x00

    .section .text
    .global reset
    .func main

reset:
    LDR R0,=vector         //Apunto R0 al vector
    LDR R1,=resultado      //Apunto R1 al vector
    LDR R1,[R1]
loop:
    LDRB R2,[R0],#1         //Tomo un elemento del vector
    CMP  R2,0x00            
    BEQ  final
    TST  R2,0x1
    ITE    NE               //Bloque IF
    ADDNE  R1,R1,0x100         //Si no son iguales incremento contimpares
    ADDEQ  R1,R1,#1         //Si no son iguales el numero es par, incremento conpare
    TST    R2,0x80
    ITE    NE               //Bloque IF
    ADDNE  R1,R1,0x1000000         //Si no son iguales incremento contnegativos
    ADDEQ  R1,R1,0x10000         //Si no son iguales el numero es positivo, incremento contpositivos
    B      loop
final:
    LDR  R2,=resultado
    STR  R1,[R2]   
stop:
    B stop

    .endfunc




