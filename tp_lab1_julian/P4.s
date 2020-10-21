    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .text
    .global reset
    .func main

reset:
    LDR R0,=segundo
    LDR R0,[R0]
    CLKSOURCE R0
    MOV R1,#0
    MOV R2,#0
loop:
    CMP R2,#60
    BEQ final
second:
    CMP R0,R1
    BEQ endsecond
    ADD R1,R1,#1
    B second
endsecond:
    ADD R2,R2,#1
    MOV R1,#0
    B loop
/* 
loop:
    MOV R2,#0
    MOV R3,#0
    MOV R4,#0
    CMP R1,#60
    BEQ final
FF:
    TST R2,0xFF
    BEQ FFFF
    ADD R2,R2,#1
    B FF
FFFF:
    TST R3,0xFF
    BEQ FFFFF
    ADD R3,R3,#1
    MOV R2,#0
    B FF
FFFFF:
    TST R4,0xFF
    BEQ finsegundo
    ADD R4,R4,#1
    MOV R2,#0
    MOV R3,#0
    B FF
finsegundo:
    ADD R1,R1,#1
    B loop
    */
final:
stop:
    B stop

    .pool
segundo:
    .word 0x01312D00
