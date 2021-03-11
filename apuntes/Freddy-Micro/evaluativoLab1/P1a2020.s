    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
resultado:
    .byte 0x00,0x00,0x00,0x00
base:
    .byte 0x01,0x02,0x03,0x04,0x05
    .byte 0x06,0x07,0x08,0x09,0x00
    .section .text   
    .global reset    
    .func main       
reset:
    LDR R0,=base //base para el punto a
    LDR R1,=resultado //cantidad de pares
    LDR R2,=resultado+1 //cantidad de impares
    MOV R3,#0 //valor a comprobar
    MOV R4,#0 //cantidad de pares
    MOV R5,#0 //cantidad de impares
//punto A
lazoa:
    LDRB R3,[R0],#1
    CMP R3,0x00
    BEQ guardar
    AND R3,R3,0x01
    CMP R3,0x00
    BEQ aumentapar
    ADD R5,R5,#1    //aumento impares
    B lazoa
aumentapar:
    ADD R4,R4,#1   //aumento pares
    B lazoa
guardar:
    STRB R4,[R1]
    STRB R5,[R2]
    B stop
stop:
    B stop

    .pool
    .endfunc
