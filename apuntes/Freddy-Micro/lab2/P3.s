    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
hora:
    .space 6,0x00
    .section .text   
    .global reset    
    .func main  
reset:
    LDR R2,=hora
    MOV R3,#0 //divisor
    ADD R1,R2,#5
lazo:
    MOV R0,#1
    BL aumentasegundos
    B lazo
aumentasegundos:
    PUSH {R4-R5} //guardo los registros en la pila
    LDRB R4,[R1] //cargo el digito menos significativo
    ADD R4,R0    //a lo que habia en el digito menos significativo le sumo 1
    MOV R0,#0    //por defecto retorna 0
    CMP R4,#9    //si el digito menos significativo no desborda
    BLS aumentas0//aumento el digito mas significativo
    SUB R4,R4,#9 //sino, resto R4-9 (R4 sigue aumentando despues de 9)
    SUB R1,#1    //voy al bit mas significativo
    LDRB R5,[R1] //muestro en digito mas significativo en el display
    ADD R5,R4    //sumo lo que hay el digito mas significativo el valor del desborde
    MOV R4,#0    //vuelvo a 0 el bit menos significativo
    CMP R5,#5    //si el digito mas significativo no desborda
    BLS aumentas1//aumento el digito mas significativo
    MOV R5,#0    //vuelvo a 0 al bit mas significativo
    MOV R0,#1    //como hay desborde retorno 1
aumentas1:
    STRB R5,[R1] //muestro el digito mas significativo
    ADD R1,#1    //voy al digito menos significativo
aumentas0:
    STRB R4,[R1] //muestro el digito menos significativo
    POP {R4-R5}  //devulevo los valores iniciales de R4,R5
    BX LR        //retorno a la siguiente instruccion
stop:
    B stop
