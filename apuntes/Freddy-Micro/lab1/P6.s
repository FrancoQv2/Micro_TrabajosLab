    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
origen:
    .byte 0x01,0x0A,0x3B,0x45,0x56,0xFF,0x3C
    .space 9,0xFF
    .section .text   
    .global reset    
    .func main       
reset:
    MOV R0,#7           //cantidad de elementos a sumar
    LDR R1,=0x10080030  //direccion de "base"
    LDR R2,=origen      //cargoen R2 la direccion de origen del vector
    STR R2,[R1]         //guardo la direccion de origen del vector en la direccion de memoria "base"
    LDR R3,[R1]         //cargo en R3 el contenido de la dirección de memoria base
    LDRB R4,[R3],#1     //cargo en R4 el contenido de la la direccion de memoria R3, o sea que traigo el primer elemento del vector y luego apunto al siguiente
    SUB R0,R0,#1        //como ya traje un elemento del vector, queda por traer R0-1
    MOV R5,R4           //sumo en R5 el valor del primero elemento del vector
lazo:
    CMP R0,#0           //comparo el valor de elementos restantes por traer
    BEQ guardar         //si ya no quedan elementos restanter por traer, guardo la suma de todos los elementos en "base"+4
    LDRB R4,[R3],#1     //cargo en R4 el valor del elemento del vector y apunto al siguiente
    SUB R0,R0,#1        //como ya traje un elemento del vector, a la cantidad actual que quedan por traer le resto 1
    ADD R5,R5,R4        //sumo el valor del elemento actual del vector a los que ya tenia acumulados en el registro R5
    B lazo              //vuelvo a ejecutar el lazo
guardar:
    ADD R1,R1,#4        //apunto a la direccion "base" + 4
    STR R5,[R1]        //guardo en la direccion "base"+ 4 el valor de la suma de los N elementos del vector origen
    B stop              
stop:
    B stop
