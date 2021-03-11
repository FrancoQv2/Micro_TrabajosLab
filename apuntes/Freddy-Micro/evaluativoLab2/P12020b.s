    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
vector:
    .byte 0xFF
    .section .text   
    .global reset    
    .func main       
reset:
    MOV R0,#25     //dividendo
    LDR R1,=vector  //direccion para guardar los divisores
    BL divisores
    B final
####Funcion divisores####
divisores:
    PUSH {R1}
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
    POP {R1}
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
    B stop
stop:
    B stop
