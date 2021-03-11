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
    MOV R0,#0xFF
lazo:
    ADD R1,R2,#5
    BL modificasegundos
    B lazo
/////Función que decice si aumento o disminuyo/////
modificasegundos:
    CMP R0,#0xFF
    BEQ disminuyesegundos_final
    CMP R0,#1
    BEQ aumentasegundos_final
    B final
disminuyesegundos_final:
    PUSH {LR}
    BL disminuyesegundos
    B modificasegundos_salir
aumentasegundos_final:
    PUSH {LR}
    BL aumentasegundos
    B modificasegundos_salir
modificasegundos_salir:
    POP {R0,R4,R5}
    POP {LR}
    BX LR
/////////Fin de la funcion que decide/////////////
#########Funcion que disminuye los segundos#######
disminuyesegundos:
    PUSH {R0,R4,R5}
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
    BX LR
#######Fin de la funcion disminuir segundos#######
/////////Funcion que aumenta los segundos/////////
aumentasegundos:
    PUSH {R0,R4,R5}
    LDRB R4,[R1]
    ADD R4,#1
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
    BX LR
///////Fin de la funcion aumentar segundos///////
final:
    B stop
stop:
    B stop
