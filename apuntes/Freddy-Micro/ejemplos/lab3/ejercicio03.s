    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    .include "configuraciones/ciaa.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// Recursos utilizados por el display correspondiente al digito 1
    .equ DISP1_PORT, 0
    .equ DISP1_PIN, 0
    .equ DISP1_BIT, 0
    .equ DISP1_MASK, (1 << DISP1_BIT)

    .equ DISP1_GPIO, 0
    .equ DISP1_OFFSET, ( DISP1_GPIO << 2)
//-------------------------------------------------------------//
// Recursos utilizados por el display correspondiente al digito 2
    .equ DISP2_PORT, 0
    .equ DISP2_PIN, 1
    .equ DISP2_BIT, 1
    .equ DISP2_MASK, (1 << DISP2_BIT)

    .equ DISP2_GPIO, 0
    .equ DISP2_OFFSET, ( DISP2_GPIO << 2)
//-------------------------------------------------------------//
// Recursos utilizados por el display correspondiente al digito 3
    .equ DISP3_PORT, 1
    .equ DISP3_PIN, 15
    .equ DISP3_BIT, 2
    .equ DISP3_MASK, (1 << DISP3_BIT)

    .equ DISP3_GPIO, 0
    .equ DISP3_OFFSET, ( DISP3_GPIO << 2)
//-------------------------------------------------------------//
// Recursos utilizados por el display correspondiente al digito 4
    .equ DISP4_PORT, 1
    .equ DISP4_PIN, 16
    .equ DISP4_BIT, 3
    .equ DISP4_MASK, (1 << DISP4_BIT)

    .equ DISP4_GPIO, 0
    .equ DISP4_OFFSET, ( DISP4_GPIO << 2)

    .equ DISP_GPIO, 0
    .equ DISP_OFFSET, ( DISP_GPIO << 2)
    .equ DISP_MASK, ( DISP1_MASK | DISP2_MASK | DISP3_MASK | DISP4_MASK )

//-------------------------------------------------------------//
//Recursos utilizados por los segmentos de los 4 displays//
// Recursos utilizados por el segmento Horizontar A
    .equ SEG_A_PORT, 4
    .equ SEG_A_PIN,  0
    .equ SEG_A_BIT,  0
    .equ SEG_A_MASK, (1 << SEG_A_BIT)

// Recursos utilizados por el segmento vertical B
    .equ SEG_B_PORT, 4
    .equ SEG_B_PIN,  1
    .equ SEG_B_BIT,  1
    .equ SEG_B_MASK, (1 << SEG_B_BIT)

// Recursos utilizados por el segmento vertical C
    .equ SEG_C_PORT, 4
    .equ SEG_C_PIN, 2
    .equ SEG_C_BIT, 2
    .equ SEG_C_MASK, (1 << SEG_C_BIT)
    
// Recursos utilizados por el segmento Horizontar D
    .equ SEG_D_PORT, 4
    .equ SEG_D_PIN,  3
    .equ SEG_D_BIT,  3
    .equ SEG_D_MASK, (1 << SEG_D_BIT)

// Recursos utilizados por el segmento vertical E
    .equ SEG_E_PORT, 4
    .equ SEG_E_PIN, 4
    .equ SEG_E_BIT, 4
    .equ SEG_E_MASK, (1 << SEG_E_BIT)

// Recursos utilizados por el segmento vertical F
    .equ SEG_F_PORT, 4
    .equ SEG_F_PIN, 5
    .equ SEG_F_BIT, 5
    .equ SEG_F_MASK, (1 << SEG_F_BIT)
    
// Recursos utilizados por el segmento Horozontal G
    .equ SEG_G_PORT, 4
    .equ SEG_G_PIN,  6
    .equ SEG_G_BIT,  6
    .equ SEG_G_MASK, (1 << SEG_G_BIT)


    .equ SEG_GPIO, 2
    .equ SEG_OFFSET, ( SEG_GPIO << 2)
    .equ SEG_MASK, ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )
// -------------------------------------------------------------------------//

/****************************************************************************/
/* Vector de interrupciones                                                 */
/****************************************************************************/

    .section .isr           // Define una seccion especial para el vector
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value
    .word   handler+1       //  2: Non mascarable interrupt service routine
    .word   handler+1       //  3: Hard fault system trap service routine
    .word   handler+1       //  4: Memory manager system trap service routine
    .word   handler+1       //  5: Bus fault system trap service routine
    .word   handler+1       //  6: Usage fault system tram service routine
    .word   0               //  7: Reserved entry
    .word   0               //  8: Reserved entry
    .word   0               //  9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call trap service routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service system trap service routine
    .word   systick_isr+1   // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM)
espera:
    .zero 1                 // Variable compartida con el tiempo de espera
hora:
    .space 6,0x00           // Vector correspondiente las HH:MM:SS

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    MOV R6,#0x00   //bandera para los displays

// Llama a una subrutina para configurar el systick
    BL systick_init

    // Se configuran los pines de los displays como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DISP1_PORT << 7 | DISP1_PIN << 2)]
    STR R0,[R1,#(DISP2_PORT << 7 | DISP2_PIN << 2)]
    STR R0,[R1,#(DISP3_PORT << 7 | DISP3_PIN << 2)]
    STR R0,[R1,#(DISP4_PORT << 7 | DISP4_PIN << 2)]

    // Se configuran los pines de los SEGMENTOS A,B,C,D,E,F y G como gpio sin pull-up
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)]
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]

    // Apaga el bit gpio del los Displays
    LDR R1,=GPIO_CLR0
    LDR R0,=DISP_MASK  //limpio el bit correpondiente a los display
    STR R0,[R1,#DISP_OFFSET]
    // Se apagan los bits gpio correspondientes a los SEGMENTOS A,B,C,D,E,F y G
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    // Se configuran el bit del gpio de los Displays como salida
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#DISP_OFFSET]
    ORR R0,DISP_MASK
    STR R0,[R1,#DISP_OFFSET]
    // Se configuran los bits gpio de los SEGMENTOS A,B,C,D,E,F y G como salidas
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0  //direccion base de GPIO
    LDR R5,=GPIO_NOT0  //invierte el estado actual del bit

    LDR R9,=tabla
    MOV R8,#0
stop:
    B stop
    .pool                   // Almacenar las constantes de código
    .endfunc

/************************************************************************************/
/* Rutina de inicialización del SysTick                                             */
/************************************************************************************/
.func systick_init
systick_init:
    CPSID I                     // Se deshabilitan globalmente las interrupciones

    // Se sonfigura prioridad de la interrupcion
    LDR R1,=SHPR3               // Se apunta al registro de prioridades
    LDR R0,[R1]                 // Se cargan las prioridades actuales
    MOV R2,#2                   // Se fija la prioridad en 2
    BFI R0,R2,#29,#3            // Se inserta el valor en el campo
    STR R0,[R1]                 // Se actualizan las prioridades

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]                 // Se quita el bit ENABLE

    // Se configura el desborde para un periodo de 1 ms
    LDR R1,=SYST_RVR
    LDR R0,=#(480000 - 1)
    STR R0,[R1]                 // Se especifica el valor de RELOAD

    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0
    // Escribir cualquier valor limpia el contador
    STR R0,[R1]                 // Se limpia COUNTER y flag COUNT

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07
    STR R0,[R1]                 // Se fijan ENABLE, TICKINT y CLOCK_SRC

    CPSIE I                     // Se habilitan globalmente las interrupciones
    BX  LR                      // Se retorna al programa principal
    .pool                   // Almacenar las constantes de código
tabla:
    .byte 0x3F,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x6F
.endfunc

/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
    .func systick_isr
systick_isr:
    LDR  R0,=espera             // Se apunta R0 a la variable espera
    LDRB R1,[R0]                // Se carga el valor de la variable espera
    SUBS R1,#1                  // Se decrementa el valor de espera
    PUSH {R0-R5,R7-R9,LR}
    BL mostrar
    POP {R0-R5,R7-R9,LR}
    
    BHI  aumenta           // Si Espera > 0 entonces NO pasaron 10 veces

    MOV  R1,#1000             // Se recarga la espera con 10 iteraciones
    
systick_exit:
    STRB R1,[R0]                // Se actualiza la variable espera
    BX   LR                     // Se retorna al programa principal

aumenta:
    PUSH {R0-R9,LR}
    BL aumentar                 //Rutina para aumentar la hora
    POP {R0-R9,LR}
    BX LR

    .pool                       // Se almacenan las constantes de codigo
    .endfunc

/************************************************************************************/
/* Rutina de servicio generica para excepciones                                     */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.          */
/* Se declara como una medida de seguridad para evitar que el procesador            */
/* se pierda cuando hay una excepcion no prevista por el programador                */
/************************************************************************************/
    .func handler
handler:
    LDR R1,=GPIO_SET0           // Se apunta a la base de registros SET
    MOV R0,#LED_1_MASK          // Se carga la mascara para el LED 1
    STR R0,[R1,#LED_1_OFFSET]   // Se activa el bit GPIO del LED 1
    B handler                   // Lazo infinito para detener la ejecucion
    .pool                       // Se almacenan las constantes de codigo
    .endfunc

#####################SUBRUTINA AUMENTAR HORA#######################

aumentar:

    LDR R2,=hora  //Apunto a los segundos 0 del vector
    LDRB R2,[R2]   //Extraigo el valor de los segundos del vector
    
    LDR R3,=hora+1//Apunto a los segundos 1 del vector
    LDRB R3,[R3]   //Extraigo el valor de los segundos del vector
    
    LDR R4,=hora+2//Apunto a los minutos 0 del vector
    LDRB R4,[R4]   //Extraigo el valor de los segundos del vector
    
    LDR R5,=hora+3//Apunto a los minutos 1 del vector
    LDRB R5,[R5]   //Extraigo el valor de los segundos del vector
    
    LDR R6,=hora+4//Apunto a los horas 0 del vector
    LDRB R6,[R6]   //Extraigo el valor de los segundos del vector

    LDR R7,=hora+5//Apunto a los horas 1 del vector
    LDRB R7,[R7]   //Extraigo el valor de los segundos del vector
    
lazo:
    B aumentas0
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
    BEQ verhora //si el valor de H1 supero a 1 verifico el valor de H0
lazo8:
    CMP R6,#9
    BHI aumentah1
salir_aumentar:
    BX LR

aumentas0:
    ADD R2,R2,#1  //Aumento en 1 el valor de los segundos0
    LDR R8,=hora  //Apunto al segundo S0 del vector
    STRB R2,[R8]  //Guardo el valor aumentado en el vector
    B lazo2
aumentas1:
    LDR R8,=hora  //Apunto al segundo S0 del vector
    MOV R2,#0     //Vuelvo el S0 a 0
    STRB R2,[R8]  //Guardo el valor 0 en S0
    LDR R8,=hora+1//Apunto al segundo S1 del vector
    LDR R3,[R8]   //Extraigo el valor S1 del vector
    ADD R3,R3,#1  //Aumento en 1 el valor de los segundos1
    STRB R3,[R8]  //Guardo el valor aumentado en el vector
    B lazo3
aumentom0:
    LDR R8,=hora+1//Apunto al segundo S1 del vector
    MOV R3,#0     //Vuelvo el S1 a 0
    STRB R3,[R8]  //Guardo el valor 0 en el segundo S1
    LDR R8,=hora+2//Apunto al minuto M0 del vector
    LDR R4,[R8]   //Extraigo el valor M0 del vector
    ADD R4,R4,#1  //Aumento en 1 el valor de los minutos0
    STRB R4,[R8]  //Guardo el valor aumentado en el vector
    B lazo4
aumentam1:
    LDR R8,=hora+2//Apunto al minuto M0 del vector
    MOV R4,#0     //Vuelvo el M0 a 0
    STRB R4,[R8]  //Guardo el valor 0 en el minuto M0
    LDR R8,=hora+3//Apunto al minuto M1 del vector
    LDR R5,[R8]   //Extraigo el valor M1 del vector
    ADD R5,R5,#1  //Aumento en 1 el valor de los minutos1
    STRB R5,[R8]  //Guardo el valor aumentado en el vector
    B lazo5
aumentah0:
    LDR R8,=hora+3//Apunto al minuto M1 del vector
    MOV R5,#0     //Vuelvo el M1 a 0
    STRB R5,[R8]  //Guardo el valor 0 en el minuto M1
    LDR R8,=hora+4//Apunto al hora H0 del vector
    LDR R6,[R8]   //Extraigo el valor H0 del vector
    ADD R6,R6,#1  //Aumento en 1 el valor de las horas0
    STRB R6,[R8]  //Guardo el valor aumentado en el vector
    B lazo6       //Si el valor de horas H0 superó a 3 verifico si H1 no supero a 2
aumentah1:
    LDR R8,=hora+4//Apunto al hora H0 del vector
    MOV R6,#0     //Vuelvo el H0 a 0
    STRB R6,[R8]  //Guardo el valor 0 en el hora H0
    LDR R8,=hora+5//Apunto al hora H1 del vector
    LDR R7,[R8]   //Extraigo el valor H1 del vector
    ADD R7,R7,#1  //Aumento en 1 el valor de las horas1
    STRB R7,[R8]  //Guardo el valor aumentado en el vector
    B lazo
verhora:
    CMP R6,#4     //Si el valor de H1 supero a 4
    BEQ lazo7     //Vuelvo todo a cero
    B lazo8       //Aumento en 1 el valor H1
lazo7:
    LDR R8,=hora+5//Apunto al hora H1 del vector
    MOV R7,#0     //Vuelvo 0 al valor de H1
    STR R7,[R8],#1//Guardo el valor 0 en H1
    LDR R8,=hora+4//Apunto al hora H0 del vector
    STR R7,[R8]   //Guardo el valor 0 en H0
    B salir_aumentar 

###################################################################

///////////////////////SUBRUTINA Mostrar Hora///////////////////////////////////////

mostrar:
    MOV R3,#0
    LDR R7,=switch //Apunta R7 al bloque con la tabla
    CMP R6,#3      //Bandera para ver que display encender
    BHI cerar      //Si estoy en el quinto display (que no existe) reinicio la bandera
seguir:
    LDR R2,[R7,R6,LSL #2] // Cargar en R2 la dirección del caso switch
    ORR R2,0x01    // Fija el MSB para indicar instrucciones THUMB
    BX R2 
.align // Asegura que la tabla de saltos este alineada
switch: .word case0, case1, case2, case3
case0: LDR R0,[R4,#DISP_OFFSET]  //Enciende display 1 y apaga 2,3,4
       ORR R3,#DISP1_MASK
       AND R3,#~DISP2_MASK
       AND R3,#~DISP3_MASK
       AND R3,#~DISP4_MASK
       B break 
case1: LDR R0,[R4,#DISP_OFFSET]  //Enciende display 2 y apaga 1,3,4
       ORR R3,#DISP2_MASK
       AND R3,#~DISP1_MASK
       AND R3,#~DISP3_MASK
       AND R3,#~DISP4_MASK
       B break
case2: LDR R0,[R4,#DISP_OFFSET]  //Enciende display 3 y apaga 2,3,4
       ORR R3,#DISP3_MASK
       AND R3,#~DISP1_MASK
       AND R3,#~DISP2_MASK
       AND R3,#~DISP4_MASK
       B break 
case3: LDR R0,[R4,#DISP_OFFSET]  //Enciende display 4 y apaga 1,2,3
       ORR R3,#DISP4_MASK
       AND R3,#~DISP1_MASK
       AND R3,#~DISP2_MASK
       AND R3,#~DISP3_MASK
break: LDR R7,=hora  //Apunto R7 a la direccion del vector del reloj
       ADD R7,R7,R6  //Apunto R7 al elemento que quiero mostrar (Hora, Min,Seg)
       LDRB R8,[R7]  //Extraigo del vector el numero que quiero mostrar
       ADD R8,R8,R9  //Apunto a la direccion del elemento convertido de tabla
       LDRB R8,[R8]  //Traigo el valor convertido a 7 SEGMENTOS de la tabla
       STR R8,[R4,#SEG_OFFSET]   //Pongo en alto los bits correspodientes al numero que quiero mostrar
       STR R3,[R4,#DISP_OFFSET]  //Activo el display correspondiente
       AND R3,#~DISP1_MASK       //Apago todos los display luego de mostrarlos
       AND R3,#~DISP2_MASK
       AND R3,#~DISP3_MASK
       AND R3,#~DISP4_MASK
       STR R3,[R4,#DISP_OFFSET]
       ADD R6,R6,#1  //Aumento la bandera
       B salir_mostrar
cerar:
    MOV R6,#0
salir_mostrar:
    BX LR 

///////////////////////FIN DE SUBRUTINA AUMENTAR////////////////////////////////
