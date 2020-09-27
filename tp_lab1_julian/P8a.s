    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

tabla:                  //Reservo memoria para la tabla (No es necesario cre)
    .space 1024,0xAA

    .section .text
    .global reset
    .func main

reset:
    MOV R1,#65000       //Numero a buscar la raiz cuadrada
    LDR R2,=tabla       //Apunto R2 a la tabla
    MOV R3,#1           //Contador
generartabla:           //Genero la tabla
    CMP R3,#256
    BEQ resetregistros
    MUL R4,R3,R3
    STRH R4,[R2],#2     //STRH guarda media palabra (16 bits) offset de 2 bytes
    ADD R3,R3,#1
    B generartabla    
resetregistros:
    MOV R3,#1
    LDR R2,=tabla    
loop:
    LDRH R4,[R2],#2     //Leo de la tabla
    CMP  R1,R4
    BMI  final
    ADD R3,R3,#1
    B loop
final:
    SUB R3,R3,#1        //Resto uno para obtener el resultado correcto, el loop 
    MOV R0,R3           //realiza una vuelta extra, pereza cambiar la bandera que
stop:                   //lee y arreglar
    B stop

.endfunc