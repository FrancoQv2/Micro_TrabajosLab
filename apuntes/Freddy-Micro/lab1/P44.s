    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
hora:
    .space 6,0x00
    .section .text   
    .global reset    
    .func main  
reset:
    LDR R0,=hora
    MOV R1,#0 //divisor
    MOV R2,#0 //segundo 0  R0+5
    MOV R3,#0 //segundo 1  R0+4
    MOV R4,#0 //minuto 0   R0+3
    MOV R5,#0 //minuto 1   R0+2
    MOV R6,#0 //hora 0     R0+1
    MOV R7,#0 //hora 1     R0
    MOV R8,#0 //base
lazo:
    ADD R1,R1,#1
    CMP R1,#1
    BEQ aumentas0
lazo2:
    CMP R2,#9
    BHI aumentas1
lazo3:
    CMP R3,#5
    BHI aumentom0
lazo4:
    CMP R4,#9
    BHI aumentam1
lazo5:
    CMP R5,#5
    BHI aumentah0
lazo6:
    CMP R7,#2
    BEQ verhora
lazo8:
    CMP R6,#9
    BHI aumentah1
    B lazo
aumentas0:
    MOV R1,#0
    ADD R2,R2,#1
    LDR R8,=hora+5
    STRB R2,[R8]
    B lazo2
aumentas1:
    MOV R2,#0
    LDR R8,=hora+5
    STRB R2,[R8]
    ADD R3,R3,#1
    LDR R8,=hora+4
    STRB R3,[R8]
    B lazo3
aumentom0:
    MOV R3,#0
    LDR R8,=hora+4
    STRB R3,[R8]
    ADD R4,R4,#1
    LDR R8,=hora+3
    STRB R4,[R8]
    B lazo4
aumentam1:
    MOV R4,#0
    LDR R8,=hora+3
    STRB R4,[R8]
    ADD R5,R5,#1
    LDR R8,=hora+2
    STRB R5,[R8]
    B lazo5
aumentah0:
    MOV R5,#0
    LDR R8,=hora+2
    STRB R5,[R8]
    ADD R6,R6,#1
    LDR R8,=hora+1
    STRB R6,[R8]
    B lazo6
aumentah1:
    MOV R6,#0
    LDR R8,=hora+1
    STRB R6,[R8]
    ADD R7,R7,#1
    STRB R7,[R0]
    LDR R8,=hora
    STRB R7,[R8]
    B lazo
verhora:
    CMP R6,#4
    BEQ lazo7
    B lazo8
lazo7:
    MOV R7,#0
    MOV R8,R0
    STRB R7,[R8],#1
    STRB R7,[R8]
    B lazo
stop:
    B stop
