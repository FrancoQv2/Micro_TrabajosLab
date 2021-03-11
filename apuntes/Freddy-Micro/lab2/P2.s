    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
numero1:
    //.byte 0x04,0x03,0x00,0x81,0x05,0x06,0x20,0x00
    .word 0x81000304,0x00200605
numero2:
    //.byte 0x02,0x01,0x56,0xA0
    .word 0xA0560102
    .section .text   
    .global reset    
    .func main       
reset:
    LDR R0,=numero1
    MOV R4,R0
    LDR R1,=numero2
    LDR R1,[R1]
    LDR R2,[R0]         //parte baja
    LDR R3,[R0,#4]!     //parte alta
    BL suma
    B final
suma:
    PUSH {R4-R11}       //mando a la pila los valores para recuperarlos
    MOV R5,#0
    MOV R6,#0
    ADDS R5,R2,R1       //sumo las partes bajas y afecto al carry
    ADC R6,R6,R3        //sumo la parte alta + carry y lo guardo en R6
    STR R5,[R4],#4      //guardo en M[R0] la parte baja
    STR R6,[R4]         //guardo en M[R0+4] la parte baja
    POP {R4-R11}        //devuelvo los valores de la pila
    BX LR               //vuelvo a la instrucción siguente a la llamada
final:   
    B stop
stop:
    B stop

    .pool
    .endfunc
