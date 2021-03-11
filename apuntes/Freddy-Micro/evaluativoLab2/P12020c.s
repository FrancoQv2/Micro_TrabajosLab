    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
vector:
    .byte 0xFF
numero:
    .byte 0x00
maximo:
    .byte 0x00
    .section .text   
    .global reset 
.global numero
.global maximo
    .func main       
reset:
    MOV R0,#255     //dividendo
    LDR R1,=vector  //direccion para guardar los divisores
    MOV R4,R0       //numero a disminuir
    MOV R5,#1
    LDR R9,=maximo //maxima cantidad de divisores
    LDRB R6,[R6]
    LDR R10,=numero //numero con maxima cantidad de divisores
    LDRB R8,[R8]
repito:
    SUB R4,R4,#1
    CMP R5,R4
    BEQ final
    MOV R0,R4     //muevo a R4 el valor del número
    BL divisores  //devuleve en R0 la cantidad de divisores
    CMP R0,R6
    BLO repito
    MOV R6,R0
    MOV R8,R4
    B repito
####Funcion divisores####
divisores:
    PUSH {R1,R4}
    MOV R3,#2 //cantidad de divisores, el 1 y el mismo numero ya son divisores
    STRB R0,[R1],#1
    MOV R4,R0
calcular:
    SUB R4,R4,#1
    CMP R4,#1
    BEQ salir_divisores
    PUSH {R1,LR}
    MOV R1,R4
    BL modulo
    POP {R1,LR}
    CMP R2,#0
    BNE calcular
    STRB R4,[R1],#1
    ADD R3,R3,#1
    B calcular
salir_divisores:
    MOV R0,R3
    MOV R4,#1
    STRB R4,[R1]
    POP {R1,R4}
    BX LR
#########################
//////Funcion modulo/////
modulo:
    PUSH {R0,R1,R3}
    MOV R3,R0
bucle:
    SUB R3,R3,R1
    MOV R2,R3
    CMP R1,R3
    BHI salir
    B bucle
salir:
    POP {R0,R1,R3}
    BX LR
////////////////////////
final:
    STRB R6,[R9]
    STRB R8,[R10]
    B stop
stop:
    B stop
