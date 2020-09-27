    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .text
    .global reset
    .func main
reset:
    MOV R1,#65000     //Valor a buscar al raiz
    MOV R2,#1       //i
    MOV R3,#0       //Sumatoria
    MOV R4,#0       //Aux = 2i-1       
loop:
    ADD R3,R3,R4    //Sumatoria
    CMP R1,R3       
    BMI final
    ADD R2,R2,#1    //i+1
    ADD R4,R2,R2    //2i
    SUB R4,R4,#1    //2i-1
    B loop
final:
    SUB R2,R2,#1    //Lo mismo  que en a, alta pereza
    MOV R0,R2
stop:
    B stop

    .endfunc
