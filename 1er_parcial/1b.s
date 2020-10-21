//Subrutina para codificar binario a cadena
//R4 puntero al bloque de datos binarios
//R5 puntero a la cadena de texto destino
//R6 cantidad de bytes del bloque binario a convertir

    .func convertirbloque
convertirbloque:
    LDRB R0,[R6]            //Cargo en R0 la cantidad de bytes del bloque
    LDRB R1,[R4],#3        //Cargo en R1 para pasarle a la subrutina para convertir y luego desplazo 3 bytes

    UDIV R2,R0,#3            //Realizo R2=R0/3

    CMP R2,R0               //Verifico si el modulo - 3 es cero
    BLT final               //Termino la conversion si el modulo es menor a 3
    
    LDRB R1,[R4],#3        //Cargo en R1 para pasarle a la subrutina para convertir y luego desplazo 3 bytes
    BL convertirtresbytes  //Llamo a la subrutina para convertir
final:
    BX LR
    .endfunc 