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
    MOV R5,#0x95
    PUSH {R5}
    BL insertar
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
    BEQ salir_ordenar     //termino el ordenamientoto
    ADD R0,R0,#1  //apunto al siguiente elemento
    SUB R2,R1,#1  //auxiliar para saber con cuantos lo comparo
    ADD R3,R0,#1  //apunto al siguiente del menor
    B bucle       //realizo de nuevo las comparaciones
salir_ordenar:
    POP {R0-R5}
    BX LR
////////////////////////////////////////
////Funcion que inserta un elemento/////
insertar:
    POP {R2}        //lo que se inserte desde la pila
    PUSH {R1-R7}    
    MOV R3,R0       //puntero al primer elemento
    MOV R6,#0       //indice de elemento
bucle2:
    LDRB R4,[R3]    //elemento actual
    CMP R4,R2       //si el actual es mayor o igua al que se va a insertar
    BHS posicion    //guardo su posicion
    ADD R3,R3,#1    //apunto al siguiente elemento
    ADD R6,R6,#1    //sumo 1 al indice
    CMP R6,R1       //si aun no se supera el tamaño
    BLO bucle2       //sigo comparando
    B guardar
posicion:
    MOV R5,R3       //posicion donde se insertara el elemento
    ADD R7,R0,R1    //asigno la direccion final
cambiar:
    CMP R7,R5       //si aun hay elementos para desplazar
    BHI desplazar   //realizo el desplazamiento
guardar:
    STRB R2,[R3]    //lo guardo en la posicion siguiente a la final
    B salir_insertar
desplazar:
    SUB R7,R7,#1    //asigno la direccion anterior
    LDRB R6,[R7],#1 //guardo en un auxiliar el elemento final
    STRB R6,[R7]    //almaceno el elemento actual en la posicion siguiente
    SUB R1,R1,#1    //disminuyo el tamaño
    ADD R7,R0,R1    //asigno la direccion anterior
    B cambiar       //vuelvo a ver si tengo elementos para desplazar
salir_insertar:
    POP {R1-R7}
    ADD R1,R1,#1
    BX LR
////////////////////////////////////////
final:
    B stop
stop:
    B stop
