    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
cadena:
    .byte 0x81,0x03,0x04,0x20,0x06,0x05,0x00
    .section .text   
    .global reset    
    .func main       
reset:
    LDR R0,=cadena
    MOV R1,R0
contar:
    LDRB R3,[R1,#1]!
    CMP R3,#0
    BEQ lazo
    B contar
lazo:
    SUB R1,R1,#1
    BL cambiar
    B final
cambiar:
    LDRB R2,[R0]
    LDRB R3,[R1]
    STRB R2,[R1]
    STRB R3,[R0]
    BX LR               //vuelvo a la instrucción siguente a la llamada
final:   
    B stop
stop:
    B stop

    .pool
    .endfunc
