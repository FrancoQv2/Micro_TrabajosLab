    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
cadena:
    .byte 0x81,0x03,0x04,0x20,0x07,0x09,0x06,0x05,0x00
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
    PUSH {R0-R3,LR}
    BL invertir
    POP {R0-R3,LR}
    B final
///////funcion invertir//////
invertir:
    SUB R3,R1,R0
    CMP R3,#0
    BLE salir
    PUSH {LR}
    BL cambiar
    POP {LR}
    ADD R0,#1
    SUB R1,#1
    PUSH {LR}
    BL invertir
    POP {LR}
salir:
    BX LR
//////////////////////////////
######funcion cambiar#########
cambiar:
    PUSH {R4,R5}
    LDRB R4,[R0]
    LDRB R5,[R1]
    STRB R4,[R1]
    STRB R5,[R0]
    POP {R4,R5}
    BX LR
##############################
final:   
    B stop
stop:
    B stop

    .pool
    .endfunc
