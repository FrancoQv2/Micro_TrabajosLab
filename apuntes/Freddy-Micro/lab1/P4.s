    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
segundos:
    .byte 0x00,0x00
    .space 14,0xFF
    .section .text   
    .global reset    
    .func main       
reset:
    LDR R2,=segundos
    LDR R1,=segundos+1
    MOV R3,0
    MOV R4,0
    MOV R5,0
lazo1:
    ADD R5,R5,#1
    CMP R5,#2
    BEQ aumentarS0
lazo2:
    CMP R3,#9
    BHI aumentarS1
    STRB R3,[R1]
lazo3:
    CMP R4,5
    BHI reiniciar
    STRB R4,[R2]
    B lazo1
reiniciar: 
    MOV R4,#0
    STRB R4,[R2]
    MOV R5,#0
    B lazo1      
aumentarS1:
    MOV R3,#0
    STRB R3,[R1]
    ADD R4,R4,#1
    B lazo3
aumentarS0:
    MOV R5,0
    ADD R3,R3,#1
    B lazo2
