    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
vector:
    .byte 0x1B,0x83,0x85,0xA0,0xF3
    .section .text   
    .global reset    
    .func main       
reset:
    LDR R0,=vector  //primer elemento
    MOV R1,#5       //cantidad
    MOV R7,#0x95
    PUSH {R7}
    BL insertar
    B stop
////Funcion que inserta un elemento/////
insertar:
    POP {R2}        //lo que se inserte desde la pila
    PUSH {R1-R7}    
    MOV R3,R0       //puntero al primer elemento
    MOV R6,#0       //indice de elemento
bucle:
    LDRB R4,[R3]    //elemento actual
    CMP R4,R2       //si el actual es mayor o igua al que se va a insertar
    BHS posicion    //guardo su posicion
    ADD R3,R3,#1    //apunto al siguiente elemento
    ADD R6,R6,#1    //sumo 1 al indice
    CMP R6,R1       //si aun no se supera el tamaño
    BLO bucle       //sigo comparando
    B guardar
posicion:
    MOV R5,R3       //posicion donde se insertara el elemento
    ADD R7,R0,R1    //asigno la direccion final
cambiar:
    CMP R7,R5       //si aun hay elementos para desplazar
    BHI desplazar   //realizo el desplazamiento
guardar:
    STRB R2,[R3]    //lo guardo en la posicion siguiente a la final
    B salir
desplazar:
    SUB R7,R7,#1    //asigno la direccion anterior
    LDRB R6,[R7],#1 //guardo en un auxiliar el elemento final
    STRB R6,[R7]    //almaceno el elemento actual en la posicion siguiente
    SUB R1,R1,#1    //disminuyo el tamaño
    ADD R7,R0,R1    //asigno la direccion anterior
    B cambiar       //vuelvo a ver si tengo elementos para desplazar
salir:
    POP {R1-R7}
    ADD R1,R1,#1
    BX LR
////////////////////////////////////////
final:
    B stop
stop:
    B stop
