    .cpu cortex-m4              
    .syntax unified             
    .thumb        
    .section .text   
    .global reset    
    .func main       
reset:
    MOV R0,#3
    LDR R1,=base
    MOV R2,#4
    PUSH {R1-R3}
    BL tecla
    B final
tecla:
    MUL R0,R0,R2
    ADD R0,R0,R1
    LDR R0,[R0]
    MOV PC,R0
funcion0:
    B stop
funcion1:
    B stop
funcion2:
    B stop
funcion3:
    B stop
final:   
    B stop
stop:
    B stop

    .pool
base:
    .word 0x1000001a,0x1000001c,0x1000001e,0x10000020

    .endfunc
