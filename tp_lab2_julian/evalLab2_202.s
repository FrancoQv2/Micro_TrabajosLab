    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data
numero:
    .byte 0x40
vectorvidisores:
    .space 128,0x00

    .section .text
    .global reset
    .func main
reset:
    LDR R0,=numero
    LDRB R0,[R0]
    LDR R1,=vectorvidisores
loop:
    PUSH {R1}
    BL divisores
    POP {R1}
final:
    B final
    .endfunc

    .func divisores
divisores:
    MOV R2,#1           //Divisor
    PUSH {R4,LR}        //Guardo
    MOV R4,R1           //R4 = direccion de vecrtor divisores
    MOV R1,R0
    MOV R3,#0           //Contador de divisores
loopdivisores:
    CMP R2,R1           //Si divisor es mayor que dividendo salgo
    BHI finaldivisores
    PUSH {R3}           //Modulo modifica R3 asi que la guardo
    BL modulo
    POP {R3}            //Recupero R3
    CMP R0,#0           //Modulo da resultado en R0, si es = 0 es un divisor
    ITT EQ
    ADDEQ R3,#1
    STRBEQ R2,[R4],#1
    ADD R2,#1
    B loopdivisores
finaldivisores:
    MOV R1,R4           //Pongo en R1 la direccion del vector de divisores
    MOV R0,R3           //Pongo en R0 la cantidad de divisores
    POP {R4,LR}         //Recupero el valor de R4, y el LR del salto inicial
    BX LR
    .endfunc

    .func modulo      
modulo:
    UDIV R0,R1,R2
    MUL R3,R0,R2    
    SUB R0,R1,R3
finalmodulo:
    BX LR
    .endfunc 