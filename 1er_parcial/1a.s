
    //Subrutina para codificar binario a cadena
    //R4 puntero al bloque de datos binarios
    //R5 puntero a la cadena de texto destino
    //R6 cantidad de bytes del bloque binario a convertir
    .func convertircadena
convertir:
    LDRB R0,[R6],#3             //Cargo en R0 la cantidad de bytes del bloque
    MOV R1,#3

    UDIV R0,R1              //Realizo R0=R0/R1
    MUL R2,R0,R1            //Realizo R2=R0*R1
    SUB R0,R1,R2            //Obtengo el modulo de la division
    
    CMP R0,#0               //Verifico si el modulo es cero
    BEQ covertirbloque




    STRB R2,[R5],#1         //Guardo en R5 el bloque de binario convertido a cadena

    B final


    B convertir

convertirbloque:
    LDR R1,[R4],#3          //Cargo 3 bytes del vector binario para convertirlos
    AND R1,0x00FFFFFF       //Obtengo 6 bits del 



convertircaracter:

final:
    BX LR
    .endfunc 