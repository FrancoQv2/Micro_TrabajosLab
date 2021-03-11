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
lazo:
    MOV R0,#1
    ADD R1,R2,#5
    BL aumentar
    ADD R1,R2,#3
    CMP R0,#1
    BNE lazo
    BL aumentar
aumentar:
    PUSH {R4-R5}
    LDRB R4,[R1]
    ADD R4,R0
    MOV R0,#0
    CMP R4,#9
    BLS aumenta0
    SUB R4,R4,#9
    SUB R1,#1
    LDRB R5,[R1]
    ADD R5,R4
    MOV R4,#0
    CMP R5,#5
    BLS aumenta1
    MOV R5,#0
    MOV R0,#1
aumenta1:
    STRB R5,[R1]
    ADD R1,#1
aumenta0:
    STRB R4,[R1]
    POP {R4-R5}
    BX LR
stop:
    B stop
