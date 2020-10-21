    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

vector:
    .byte 0x12,0xF3,0x24,0x45,0x12,0x13,0x00
/*
Resultado
Posicion        Nombre          Valiniial   Contenido
resultado       Contpares       0           Cantidad de numeros pares en el vector
resutlado+1     Contimpares     0           Cantidad de numeros impares en el vector
 */
resultado:
    .byte  0x00,0x00

    .section .text
    .global reset
    .func main

reset:
    LDR R0,=vector         //Apunto R0 al vector
    LDR R1,=resultado      //Apunto R1 al vector
loop:
    LDRB R2,[R0],#1         //Tomo un elemento del vector
    LDRB R4,[R1],#0         //Tomo el contador de pares
    CMP  R2,0x00            
    BEQ  final
    AND  R3,R2,0x01         // Num AND 0x01  -> 0000000x  con x = 1 si impar  x = 0 si par
    CMP  R3,0x01
    ITEE   NE               //Bloque IF
    ADDNE  R4,R4,#1         //Si no son iguales el numero es par y sumo
    LDRBEQ R4,[R1,#1]!      //Si son iguales muevo el puntero de resultado a resultado + 1 y tomo su valor
    ADDEQ  R4,R4,#1         //Si no son iguales incremento
    STRB   R4,[R1],#0       //Guardo el valor ya incrementado en resultado o resultado+1
    LDR    R1,=resultado    //Apunto R1 a resultado
    B      loop
final:
stop:
    B stop

    .endfunc