    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
base:
    .byte 0x23,0x03,0x07
    .section .text   
    .global reset    
    .func main  
reset:
    LDR R0,=base      //puntero al vector
    MOV R4,R0         //
    MOV R3,#10        //la base para multiplicar
    LDRB R1,[R0,#1]!  //cargo el 3
    LDRB R2,[R0,#1]!  //cargo el 7
    LSL R1,R1,#4      //obtengo 30 a partir de 3
    ADD R1,R1,R2      //sumo 30 + 7 = 37
    STRB R1,[R0,#2]!  //guardo el 37 el base+4
    MOV R9,#0         //carry

    LDRB R5,[R4]      //cargo el 23 de base
    LDRB R6,[R4,#4]!  //cargo el 37 de base+4
    AND R1,R5,0xF0    //saco la parte alta, o sea 2-0
    LSR R1,R1,#4      //obtengo 2 a partir del 2-0
    AND R2,R5,0x0F    //saco la parte baja, o sea 3
    AND R7,R6,0xF0    //saco la parte alta, o sea 3-0
    LSR R7,R7,#4      //obtengo 3 a partir del 3-0
    ADD R1,R1,R7      //guardo en R1 la suma de la parte alta, 2+3=5
    AND R8,R6,0x0F    //saco la parte baja, o sea 7
    ADD R2,R2,R8      //guardo en R2 la suma de la parte baja, 3+7=10
lazo:
    CMP R2,#9         //si la parte baja supera el 9
    BHI restobase     //resto una base y agrego 1 a la decena
    ADD R1,R1,R9      //a la suma de la parte alta le agrego el carry si es que hay
    LSL R1,R1,#4      //transformo la parte alta a decena, o sea (R1+Carry)0
    ADD R1,R1,R2      //guardo en R1 la suma de parte alta y baja
    STRB R1,[R4,#2]!  //guardo el resultado en base+6

    LDRB R1,[R4]      //cargo el 60 de base+6
    AND R6,R1,0xF0    //cargo la parte alta, o sea el 6-0
    LSR R6,R6,#4      //obtengo la parte alta como unidad
    AND R7,R1,0x0F    //cargo la parte baja, o sea el 0
    MUL R6,R6,R3      //obtengo el numero en binario multiplicando por 10
    ADD R6,R6,R7      //sumo la decena y la unidad
    STRB R6,[R4,#2]!  //guardo el resultado en base+8
    B stop

restobase:
    SUB R2,R2,#10
    ADD R9,R9,#1
    B lazo    

stop:
    B stop
