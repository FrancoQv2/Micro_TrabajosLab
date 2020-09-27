.cpu cortex-m4
.syntax unified
.thumb
/**************************************************************************/
/*Variables                                                               */
/**************************************************************************/
    .section .data
base:
    .byte 13            //Tamaño del vector
contador:
    .byte 0             //Contador
vec:
    .hword 40      //Variable de 40 bits en blanco
/*************************************************************************/
/*Programa principal                                                     */
/*************************************************************************/

    .section .text
    .global .reset
    .func main

reset:
    LDR  R0,=base       //Apunta R0 a base
    LDRB R1,[R0]        //Guarda en R1 el valor de base
    LDRB R2,[R0]        //Guarda en R2 el valor de base 
    LDR  R3,=vec        //Apunta R3 al vector
lazo:
/******Lazo while********/
    B condicion         //Salta a la condicion
while:                  //Aqui va lo que se va la tarea a realizar
    MOV R3,0x5555       
    ADD  R2,R2,-1       
condicion:              
    cmp R2,0            
    BNE while           //BNE se fija en la Bandera Z 
/************************/
stop:  
    B   stop

    .pool