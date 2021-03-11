    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
hora:
    .space 4,0x00
    .byte 0x03,0x00
    .section .text   
    .global reset    
    .func main  
reset:
    LDR R2,=hora
    MOV R3,#0 //divisor
lazo:
    MOV R0,#0xFF
    ADD R1,R2,#5
    BL modificasegundos
    B lazo
/////Función que decice si aumento o disminuyo/////
modificasegundos:
    PUSH {R4-R5}
    CMP R0,#0xFF
    BEQ disminuyesegundos_final
    B aumentasegundos_final
modificasegundos_salir:
    POP {R4-R5}
    BX LR
///////Funcion que disminuye los segundos/////////
disminuyesegundos_final:
    LDRB R4,[R1]
    SUB R4,#1
    MOV R0,#0
    CMP R4,#0
    BGE disminuye0
    SUB R1,#1
    LDRB R5,[R1]
    SUB R5,R5,#1
    MOV R4,#9
    CMP R5,#0
    BGE disminuye1
    MOV R5,#5
    MOV R0,#1
disminuye1:
    STRB R5,[R1]
    ADD R1,#1
disminuye0:
    STRB R4,[R1]
    B modificasegundos_salir
//////Fin de la funcion disminuir segundos////////
########Funcion que aumenta los segundos##########
aumentasegundos_final:
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
    B modificasegundos_salir
######fin de la funcion dismuinuir segundos######
stop:
    B stop
