    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
vector:
    .byte 0x00,0x04,0x03,0x3A,0xAA,0xF2
    .space 10,0xFF
    .section .text   
    .global reset    
    .func main       
reset:
    LDR R0,=vector
    MOV R1,R0
    ADD R1,R1,#1
    LDRB R2,[R1],#1  //tamaño
    SUB R2,R2,#2     //resto el tamaño por que estoy usando 2
    LDRB R3,[R1],#1  //primer numero
    LDRB R4,[R1]     //segundo numero
lazo:
    CMP R2,#0
    BEQ stop
    CMP R3,R4
    BLO menor
    MOV R3,R4
    ADD R1,R1,#1
    LDRB R4,[R1]
    B cambiar
menor:
    STRB R4,[R0]
    MOV R3,R4
    ADD R1,R1,#1
    LDRB R4,[R1]
    B cambiar
cambiar:
    SUB R2,R2,#1
    B lazo
stop:
    B stop
