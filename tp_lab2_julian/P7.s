    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

cadena:
    .byte 0x05,0x22,0xB4,0x72,0x53,0x11

    .section .text
    .global reset
    .global intercambiari
    .func main

reset:
    LDR R0,=cadena
    LDRB R1,[R0]
    ADD R1,R1,R0
    ADD R0,#1
loop:
    BL intercambiar
    MOV R8,#55
final:
    B final
   .endfunc

    .func intercambiar
intercambiar:
    CMP R0,R1           //Condicion de salida
    IT CS
    MOVCS PC,LR         //Pongo en el PC el ultimo LR;
    PUSH {R0,R1,LR}     //Cuando se usa BL LR <- PC +4
    ADD R0,#1           //De modo que si hacemos PC <- LR
    SUB R1,#1           //PC ira a la instruccion proxima al uso de BL
    BL intercambiar
    POP {R0,R1,LR}      //Si ya salimos 
    push {R4,R5}
    LDRB R4,[R0]
    LDRB R5,[R1]
    STRB R4,[R1]
    STRB R5,[R0]
    pop {R4,R5}
    MOV PC,LR           //Volvemos hacia atras colocando en PC los sucesivos
    .endfunc            //valores de LR, entonces va a parar siempre una
                        //instruccion mas adelante al uso de BL

if(){
    return}
    proceso
return funcion(variables de entrada cambiadas)

if(x == 1){
    return 1
}
return factoria(x-1)*x

1 * 2 