    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

    /****************************************************************************/
    /* Definiciones de macros                                                   */
    /****************************************************************************/

    // Recursos utilizados por el punto del display, esta conectado a una salida de temporizador
    .equ LED_PORT,      6
    .equ LED_PIN,       8
    .equ LED_MAT,       1
    .equ LED_TMR,       2

    /****************************************************************************/
    /* Programa principal                                                       */
    /****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion

    reset:
    // Configura el pin del punto como salida TMAT, funcion 5 para salida de MATCH
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC5)
    STR R0,[R1,#(LED_PORT << 7 | LED_PIN << 2)]

    // Cuenta con clock interno
    LDR R1,=TIMER2_BASE
    MOV R0,#0x00
    STR R0,[R1,#CTCR]

    // Prescaler de 9.500.000 para una frecuencia de 10 Hz
    LDR R0,=9500000
    STR R0,[R1,#PR]

    // El valor del periodo para 1 Hz
    LDR R0,=5
    STR R0,[R1,#MR1]

    // El registro de match provoca reset del contador, sin interrupcion
    MOV R0,#(MR0R << (3 * LED_MAT)) O //(MR1R)
    STR R0,[R1,#MCR]

    // Define el estado inicial y toggle on match del led
    MOV R0,#(3 << (4 + (2 * LED_MAT)))
    STR R0,[R1,#EMR]

    // Limpieza del contador
    MOV R0,#CRST
    STR R0,[R1,#TCR]

    // Inicio del contador
    MOV R0,#CEN
    STR R0,[R1,#TCR]

    //El led empieza a parpadear por hardware
    
    main:
    B main

    .pool       // Almacenar las constantes de código
    .endfunc
