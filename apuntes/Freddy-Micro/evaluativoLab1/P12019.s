    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
display: 
    .byte 0xFF
    .section .text   
    .global reset    
    .func main  
reset:
    LDR R0,=tabla
    LDR R1,=display
    MOV R2,#0
lazo:
    CMP R2,0x0F
    BHI stop
    ADD R3,R0,R2
    ADD R2,R2,#1
    LDRB R4,[R3]
    STRB R4,[R1]
    B lazo
stop:
     B stop
     
     .pool
tabla:
     .byte 0x3F,0x06,0x5B,0x4F,0x66
     .byte 0x6D,0x7D,0x07,0x7F,0x6F
     .byte 0x77,0x7C,0x79,0x3E,0x79,0x71
