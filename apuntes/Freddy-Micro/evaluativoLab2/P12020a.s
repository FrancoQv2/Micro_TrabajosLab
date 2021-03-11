    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
    .section .text   
    .global reset    
    .func main       
reset:
    MOV R0,#6 //dividendo  //al salir se guarda aqui el modulo
    MOV R1,#3  //divisor
    BL modulo
    B final
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
final:
    B stop
stop:
    B stop
