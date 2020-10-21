    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data
serie:
    .space 7,0x00
    
    .section .text
    .global reset
    .func main
reset:
    MOV R1,#7
    LDR R0,=serie
loop:
    BL fibonacci
final:
    B final
    .endfunc

    .func fibonacci
fibonacci:
    PUSH {R4}
    MOV R2,#0
    MOV R3,#1
    STRB R2,[R0]
    STRB R3,[R0,#1]!
    SUB R1,#2
loopfibonacci:
    CMP R1,#0
    BEQ finalfibonacci
    ADD R4,R2,R3
    STRB R4,[R0,#1]!
    MOV R2,R3
    MOV R3,R4
    SUB R1,#1
    B loopfibonacci
finalfibonacci:
    POP {R4}
    BX LR
    .endfunc