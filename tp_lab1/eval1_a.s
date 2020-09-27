    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data
vector:
    .byte 6,12,3,25     //Cargo un vector
    .byte 7,0,1,8
resultado:
    .space 2,0x00       //Reservo espacio para contadores
    
    .section .text
    .global .reset
    .func main
reset:
    LDR  R0,=vector        //Apunta R0 a la dirección de base
    LDR  R1,=resultado     //Apunto R1 a resultado (pares)
    LDRB  R2,[R1]        //Guardo en R2 la cantidad de pares
    MOV  R3,0x00         //Cantidad de impares
lazo:
    LDRB R4,[R0],#1     //Guarda en R4 el valor de R0
    CMP R4,0x00         //Compara con 0
    BEQ final
    AND R5,R4,0x01      //Comparo la unidad del numero con 1
    CMP R5,0x01         //Si R5 es igual a 1 entonces es impar
    ITE EQ
    ADDEQ R3,R3,#1        //Si es impar le sumo 1 al contador
    ADDNE R2,R2,#1        //Si es par le sumo 1 al contador
    B lazo
final:
    STRB R2,[R1]       //Guardo contador par en resultado
    STRB R3,[R1,#1]    //Guardo contador impar en resultado+1
stop:
    B stop
    .endfunc
