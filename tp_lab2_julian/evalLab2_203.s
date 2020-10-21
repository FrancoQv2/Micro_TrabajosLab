    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

numero:
    .byte 0x00
maximo:
    .byte 0x00
vectordivisores:
    .space 128,0x00

    .section .text
    .global reset
    .func main
reset:
    MOV R0,#1                   //divisor
    LDR R1,=vectordivisores     
    LDR R2,=numero
    LDRB R4,[R2]
    LDR R3,=maximo
    LDRB R5,[R3]
    PUSH {R2,R3}                //Guardo estos valores, divisores los modifica
loop:
    CMP R0,#255
    BHI final
    MOV R6,R0                   //Guardo el divisor actual
    PUSH {R1}                   //Guardo la direccion del vectordivisores
    BL divisores    
    POP {R1}                    //La recupero
    CMP R0,R5                   //Si el numero de divisores es mayor al actual lo guardo y al numero
    ITT HI
    MOVHI R5,R0
    MOVHI R4,R6
    ADD R0,R6,#1                //Proximo divisor
    B loop
final:
    POP {R2,R3}             //Recupero las direcciones de maximo y numero
    STRB R4,[R2]
    STRB R5,[R3]
    B final
    .endfunc





    .func divisores
divisores:
    MOV R2,#1           //Divisor
    PUSH {R4,LR}        //Guardo
    MOV R4,R1           //R4 = direccion de vecrtor divisores
    MOV R1,R0
    MOV R3,#0           //Contador de divisores
loopdivisores:
    CMP R2,R1
    BHI finaldivisores
    PUSH {R3}
    BL modulo
    POP {R3}
    CMP R0,#0
    ITT EQ
    ADDEQ R3,#1
    STRBEQ R2,[R4],#1
    ADD R2,#1
    B loopdivisores
finaldivisores:
    MOV R1,R4
    MOV R0,R3
    POP {R4,LR}
    BX LR
    .endfunc

    .func modulo      
modulo:
    UDIV R0,R1,R2
    MUL R3,R0,R2    
    SUB R0,R1,R3
finalmodulo:
    BX LR
    .endfunc 