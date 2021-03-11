    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
vector:
    .byte 0xA0,0x83,0x1B,0x85,0xF3
    .section .text   
    .global reset    
    .func main       
reset:
    LDR R0,=vector  //primer elemento
    MOV R1,#5       //cantidad
    BL ordenar
    B stop
////Funcion que ordena los elementos////
ordenar:
    PUSH {R0-R5}
    SUB R1,R1,#1    //tomo el primero y el segundo
    SUB R2,R1,#1    //auxiliar para ver con cuantos lo comparo
    ADD R3,R0,#1    //puntero actual
bucle:
    LDRB R4,[R0]  //menor elemento
    LDRB R5,[R3]  //elemento actual
    CMP R5,R4     //comparo el actual y el menor
    BHS siguiente //si son iguales o es mayor cambio el actual
    STRB R5,[R0]  //si el actual es menor los intercambio
    STRB R4,[R3]  //
siguiente:
    ADD R3,R3,#1  //apunto al siguiente
    CMP R2,#0     //si no quedan elementos por comparar
    BEQ cambiaelemento //cambio el elemento
    SUB R2,R2,#1  //resto 1 a la cantidad que quedan por comparar
    B bucle
cambiaelemento:
    SUB R1,R1,#1  //disminuyo en 1 la cantidad
    CMP R1,#0     //si no quedan elementos en el vector
    BEQ salir     //termino el ordenamientoto
    ADD R0,R0,#1  //apunto al siguiente elemento
    SUB R2,R1,#1  //auxiliar para saber con cuantos lo comparo
    ADD R3,R0,#1  //apunto al siguiente del menor
    B bucle       //realizo de nuevo las comparaciones
salir:
    POP {R0-R5}
    BX LR
////////////////////////////////////////
final:
    B stop
stop:
    B stop
