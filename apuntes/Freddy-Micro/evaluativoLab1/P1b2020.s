    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
resultado:
    .byte 0x00,0x00,0x00,0x00
base:
    .byte 0x81,0xF2,0x03,0x04,0x05
    .byte 0x06,0x07,0xA8,0x09,0x00
    .section .text   
    .global reset    
    .func main       
reset:
    LDR R0,=base //base para el punto a
    LDR R1,=resultado+2 //cantidad de positivos
    LDR R2,=resultado+3 //cantidad de negativos
    MOV R3,#0 //valor a comprobar
    MOV R4,#0 //cantidad de positivos
    MOV R5,#0 //cantidad de negativos
//punto B
lazob:
    LDRB R3,[R0],#1
    CMP R3,0x00
    BEQ guardar
    AND R3,R3,0x80  //si el numero es positivo empeiza en 0
    CMP R3,#0
    BEQ aumentapos
    ADD R5,R5,#1 //aumenta negativos
    B lazob

aumentapos:
    ADD R4,R4,#1   //aumento positivos
    B lazob
guardar:
    STRB R4,[R1]
    STRB R5,[R2]
    B stop
stop:
    B stop

    .pool
    .endfunc    
