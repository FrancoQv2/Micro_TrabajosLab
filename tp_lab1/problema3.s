    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definición de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
palabra:
    .byte 0x06,0x7A,0x7B,0x7C,0x00

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Indica al depurador el inicio de una función

reset:
    LDR R0,=palabra
    MOV R1,0x01     
    MOV R2,0x00         //Cantidad de unos
    MOV R4,0x01         //Auxiliar variable que se ira corriendo
loop:
    LDRB R3,[R0],#1
    CMP  R3,0x00        //Compara si llego al final de la cadena
contarunos:
    CMP  R4,0x10        //Compara si llego al final del byte
    BEQ  fincontarunos
    TST  R3,R4          //AND bit a bit de R3 con R4
    IT   EQ             //Bloque if
    ADDEQ R2,#1
    LSL  R4,0x01        //Corre el 1 guardado en R4 un lugar a la izquierda
    B    contarunos
fincontarunos:
    TST  R2,0x01
    IT   EQ
    ADDEQ R3,R3,0x80
    MOV  R2,0x00       //Reinicio registros
    MOV  R4,0x01
    STRB R3,[R0,#-1]   //Guardo el resultado en la cadena original
    B loop
stop:
    B    stop               // Lazo infinito para terminar la ejecución
    