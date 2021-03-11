    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
display: 
    .byte 0xFF,0xFF
    .section .text   
    .global reset    
    .func main  
reset:
    MOV R7,#0xFF
    MOV R0,#50000
    LSL R0,R0,#1      //Variable contador
    MOV R1,#0         //Digito del display2
    MOV R2,#0         //Digito del display1         
    MOV R3,#1         //para controlar que diplay muestro
    LDR R4,=display   //2° digito del display
    LDR R5,=display+1 //1° digito del display
init:
    SUB R0,R0,#1
    CMP R0,#1
    BHI init
    B lazo
lazo:
    CMP R3,#1
    BEQ muestror1
    B muestror2
muestror1:
    MOV R3,#2
    CMP R2,#9
    BHI aumenta2
    STRB R2,[R5]
    STRB R7,[R4]
    ADD R2,R2,#1
    B contar
aumenta2:
    MOV R2,#0
    STRB R2,[R5]
    STRB R7,[R4]
    ADD R1,R1,#1
    ADD R2,R2,#1
    B contar
contar:
    MOV R0,#50000
    LSL R0,R0,#1
    B init
muestror2:
    MOV R3,#1
    CMP R1,#9
    BHI cerar
    STRB R1,[R4]
    STRB R7,[R5]
    B contar
cerar:
   MOV R1,#0
   MOV R2,#0
   STRB R1,[R5]
   STRB R7,[R4]
   B contar
stop:
    B stop
     
     .pool
tabla:
     .byte 0x3F,0x06,0x5B,0x4F,0x66
     .byte 0x6D,0x7D,0x07,0x7F,0x6F
