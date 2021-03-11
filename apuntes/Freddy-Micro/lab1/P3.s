    .cpu cortex-m4 
    .syntax unified
    .thumb
    .section .data
cadena: 
    .byte 0x06,0x7A,0x7B,0x7C,0x00     
    .section .text          
    .global reset           
    .func main              
reset:
    LDR R0,=cadena //apunto el registro R0 al inicio de la cadena
    MOV R5,#0 //variable para guardarel valor de M[R2]
    MOV R4,#0 //varialbe para saber cuantos bits voy contando (hasta 8)
    MOV R3,#0 //variable para guardar el resultado de AND
    MOV R1,#0 //contador de bits iguales a 1        
lazo:
    LDRB R2,[R0] //cargo en el regitro R2 el valor M[R0]
    MOV R5,R2 //cargo en el registro R5 el valor del registro R2
    CMP R2,0x00 //Comparo el valor que tiene el registro R2 con el valor 0x00
    BEQ final //si el valor que tiene el registro R2 es 0x00, termino la ejecición
    B bucle1 // si el valor que tiene el registro R2 no se 0x00, voy al bucle1
bucle1:
    CMP R4,#8 //comparo el valor que tiene el registro R2 con el valor 8 (los 8 bits de cada elemento de la cadena)
    BEQ bucle2 //si el valor que tiene el registro R4 es 8, voy al bucle2
    AND R3,R2,0x01 //si el valor que tiene el registro R4 no es 8, guardo en el registro R3 el valor del bit menos significativo del valor contenido en el registro R2
    ADD R1,R1,R3 //guardo en el registro R1 el valor del registro R3, este ultimo valdrá 0 o 1 dependiendo del bit menos significativo del valor contenido en el registro R2
    ADD R4,R4,#1 //aumento el contador de bits verificados
    LSR R2,R2,#1 //guardo en el registro R2, el valor resultante del desplazamiento de 1 bit a la derecha del valor que estaba contenido anteriormente en el registro R2
    B bucle1 //al haber verificado el bit, vuelvo a iniciar el bucle1 hasta que llegue a los 8 bits del caracter contenido en el registro R2
bucle2:
    MOV R4,#0 //cargo el valor 0 en el registro R4
    AND R3,R1,0x01 //guardo en el registro R3 el valor del bit menos significativo del valor contenido en el registro R2
    MOV R1,#0 //cargo en el registro R0 el valor 0
    CMP R3,#0 //comparo el valor contenido en el registro R3 con el valor 0
    BEQ avanzar //si el valor contenido en el registro R3 es el 0, quiere decir que el numero bits es par, por lo tanto no debo sumarle nada, y debo ir a la etiqueta avanzar
    ADD R5,R5,0x80 //si el valor contenido en el registro R3 es el valor 1, quiere decir que el numero de bits es impar, por lo tanto devol sumarle 1 al bit más significativo del valor contenido en R2
    STRB R5,[R0],#1 //luego de poner en 1 el bit mas significativo de valor contenido en el registro R2,lo almaceno en la direccion de memoria R0, y al mismo tiempo aumento R0 en 1
    MOV R5,#0 //cargo en el registro R5, el valor 0
    B lazo //luego de guardar el caracter modificado, paso al siguiente caracter
avanzar:
    ADD R0,R0,#1 //guardo en el registro R0, el valor anterio contenido en el aumentado en 1
    B lazo //luego de pasar a la direccion del siguiente caracter, vuelvo a iniciar el lazo
final:
    B final  //bucle infinito para que no ejecute mas instrucciones
    .endfunc
    