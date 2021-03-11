    .cpu cortex-m4              
    .syntax unified             
    .thumb        
    .section .data
vector:
    .hword 8
    .space 16,0xFF

    .section .text          
    .global reset           
    .func main              
reset:
    MOV R0,0x55
    LDR R2,=vector
    LDRH R1,[R2],#4
lazo:
    CMP R1,#0        
    BEQ stop
    STRH R0,[R2],#2
    SUB R1,R1,#1
    B lazo
stop:
    B stop
