
    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    .include "configuraciones/ciaa.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// Recursos utilizados el BOTON 1
    // Numero de puerto de entrada/salida utilizado en BOTON 1
    .equ BOTON_1_PORT, 4
    // Numero de terminal dentro del puerto de e/s utilizado en el BOTON 1
    .equ BOTON_1_PIN, 8
    // Numero de bit GPIO utilizado en el BOTON 1
    .equ BOTON_1_BIT, 12
    // Mascara de 32 bits con un 1 en el bit correspondiente al BOTON 1
    .equ BOTON_1_MASK, (1 << BOTON_1_BIT)

//Recursos utilizados el Boton2
    .equ BOTON_2_PORT, 4
    .equ BOTON_2_PIN, 9
    .equ BOTON_2_BIT, 13
    .equ BOTON_2_MASK, (1 << BOTON_2_BIT)
//Recursos utilizados el Boton3    
    .equ BOTON_3_PORT, 4
    .equ BOTON_3_PIN, 10
    .equ BOTON_3_BIT, 14
    .equ BOTON_3_MASK, (1 << BOTON_3_BIT)
//Recursos utilizados el Boton4    
    .equ BOTON_4_PORT, 6
    .equ BOTON_4_PIN, 7
    .equ BOTON_4_BIT, 15
    .equ BOTON_4_MASK, (1 << BOTON_4_BIT)

// Recursos utilizados por los BOTONES
    // Numero de puerto GPIO utilizado por todos los BOTONES
    .equ BOTON_GPIO, 5
    // Desplazamiento para acceder a los registros GPIO de los BOTONES
    .equ BOTON_OFFSET, ( BOTON_GPIO  << 2 )
    // Mascara de 32 bits con un 1 en los bits correspondiente a cada BOTON
    .equ BOTON_MASK, ( BOTON_1_MASK | BOTON_2_MASK | BOTON_3_MASK | BOTON_4_MASK )

// -------------------------------------------------------------------------//
// Recursos utilizados por el display correspondiente al digito 4
    .equ DISP4_PORT, 0
    .equ DISP4_PIN, 0
    .equ DISP4_BIT, 0
    .equ DISP4_MASK, (1 << DISP4_BIT)

    .equ DISP4_GPIO, 0
    .equ DISP4_OFFSET, ( DISP4_GPIO << 2)

// Recursos utilizados por el segmento vertical B
    .equ DIG4_B_PORT, 4
    .equ DIG4_B_PIN,  1
    .equ DIG4_B_BIT,  1
    .equ DIG4_B_MASK, (1 << DIG4_B_BIT)

// Recursos utilizados por el segmento vertical C
    .equ DIG4_C_PORT, 4
    .equ DIG4_C_PIN, 2
    .equ DIG4_C_BIT, 2
    .equ DIG4_C_MASK, (1 << DIG4_C_BIT)

// Recursos utilizados por el segmento vertical E
    .equ DIG4_E_PORT, 4
    .equ DIG4_E_PIN, 4
    .equ DIG4_E_BIT, 4
    .equ DIG4_E_MASK, (1 << DIG4_E_BIT)

// Recursos utilizados por el segmento vertical F
    .equ DIG4_F_PORT, 4
    .equ DIG4_F_PIN, 5
    .equ DIG4_F_BIT, 5
    .equ DIG4_F_MASK, (1 << DIG4_F_BIT)


    .equ DIG4_GPIO, 2
    .equ DIG4_OFFSET, ( DIG4_GPIO << 2)
    .equ DIG4_MASK, ( DIG4_B_MASK | DIG4_C_MASK | DIG4_E_MASK | DIG4_F_MASK )
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

    // Configura los pines de los BOTONES como gpio con pull-up
    LDR R1,=SCU_BASE
    MOV R0,#( SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4 )
    STR R0,[R1,#(4 * (32 * BOTON_1_PORT + BOTON_1_PIN))]
    STR R0,[R1,#(4 * (32 * BOTON_2_PORT + BOTON_2_PIN))]
    STR R0,[R1,#(4 * (32 * BOTON_3_PORT + BOTON_3_PIN))]
    STR R0,[R1,#(4 * (32 * BOTON_4_PORT + BOTON_4_PIN))]

    // Se configuran el pin del display 4 como gpio sin pull-up
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DISP4_PORT << 7 | DISP4_PIN << 2)]

    // Se configuran los pines de los SEGMENTOS B,C,E y F como gpio sin pull-up
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG4_B_PORT << 7 | DIG4_B_PIN << 2)]
    STR R0,[R1,#(DIG4_C_PORT << 7 | DIG4_C_PIN << 2)]
    STR R0,[R1,#(DIG4_E_PORT << 7 | DIG4_E_PIN << 2)]
    STR R0,[R1,#(DIG4_F_PORT << 7 | DIG4_F_PIN << 2)]

    // Apaga el bit gpio del Display 4
    LDR R1,=GPIO_CLR0
    LDR R0,=DISP4_MASK  //limpio el bit correpondientes al display
    STR R0,[R1,#DISP4_OFFSET]
    // Se apagan los bits gpio correspondientes a los SEGMENTOS B,C,E y F
    LDR R0,=DIG4_MASK
    STR R0,[R1,#DIG4_OFFSET]

    //LDR R0,=DIG4_B_MASK
    //STR R0,[R1,#DIG4_B_OFFSET]
    //LDR R0,=DIG4_C_MASK
    //STR R0,[R1,#DIG4_C_OFFSET]
    //LDR R0,=DIG4_E_MASK
    //STR R0,[R1,#DIG4_E_OFFSET]
    //LDR R0,=DIG4_F_MASK
    //STR R0,[R1,#DIG4_F_OFFSET]

    // Configura los bits gpio de los BOTONES como entradas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#BOTON_OFFSET]
    AND R0,#~BOTON_MASK
    STR R0,[R1,#BOTON_OFFSET]
    // Se configuran el bit del gpio del display 4 como salida
    LDR R0,[R1,#DISP4_OFFSET]
    ORR R0,DISP4_MASK
    STR R0,[R1,#DISP4_OFFSET]
    // Se configuran los bits gpio de los SEGMENTOS B,C,E y F como salidas
    LDR R0,[R1,#DIG4_OFFSET]
    ORR R0,DIG4_MASK
    STR R0,[R1,#DIG4_OFFSET]

    //LDR R0,=DIG4_B_MASK
    //STR R0,[R1,#DIG4_B_OFFSET]
    //LDR R0,=DIG4_C_MASK
    //STR R0,[R1,#DIG4_C_OFFSET]
    //LDR R0,=DIG4_E_MASK
    //STR R0,[R1,#DIG4_E_OFFSET]
    //LDR R0,=DIG4_F_MASK
    //STR R0,[R1,#DIG4_F_OFFSET]
    
    //Pongo el bit del display 4 en alto
    LDR R1,=GPIO_SET0
    LDR R0,[R1,#DISP4_OFFSET]
    ORR R0,#DISP4_MASK
    STR R0,[R1,#DISP4_OFFSET]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0  //direccion base de GPIO
    LDR R5,=GPIO_NOT0  //invierte el estado actual del bit

refrescar:
    // Define el estado actual de los SEGMENTOS como todos apagados
    MOV   R3,#0x00  //Registro donde se ubican los bits correspondientes al valor de cada segmento del display
    // Carga el estado actual de los BOTONES
    LDR   R0,[R4,#BOTON_OFFSET] //Me muevo al gpio 5 para revisar los botones

    // Verifica el estado del bit correspondiente al BOTON 1
    TST R0,#BOTON_1_MASK   //veo el bit 12
    // Si el BOTON 1 esta apretado
    ITE EQ
    // Enciende el bit del SEGMENTO F del display 4
    ANDEQ R3,#~DIG4_F_MASK
    ORRNE R3,#DIG4_F_MASK

    TST R0,#BOTON_2_MASK
    // Si el BOTON 2 esta apretado
    ITE EQ
    // Enciende el bit del SEGMENTO B del display 4
    ANDEQ R3,#~DIG4_B_MASK
    ORRNE R3,#DIG4_B_MASK

    TST R0,#BOTON_3_MASK
    // Si el BOTON 3 esta apretado
    ITE EQ
    // Enciende el bit del SEGMENTO E del display 4
    ANDEQ R3,#~DIG4_E_MASK
    ORRNE R3,#DIG4_E_MASK

    TST R0,#BOTON_4_MASK
    // Si el BOTON 4 esta apretado
    ITE EQ
    // Enciende el bit del segmento C del display 4
    ANDEQ R3,#~DIG4_C_MASK
    ORRNE R3,#DIG4_C_MASK

    // Actualiza las salidas con el estado definido para los SEGMENTOS del Display 4
    STR   R3,[R4,#DIG4_OFFSET]

    // Repite el lazo de refresco indefinidamente
    B     refrescar
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

    // Se configura el desborde para un periodo de 100 ms
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
    .pool                       // Se almacenan las constantes de código
.endfunc

/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
    .func systick_isr
systick_isr:
    LDR  R0,=espera             // Se apunta R0 a la variable espera
    LDRB R1,[R0]                // Se carga el valor de la variable espera
    SUBS R1,#1                  // Se decrementa el valor de espera
    BHI  systick_exit           // Si Espera > 0 entonces NO pasaron 10 veces
    LDR R1,=GPIO_NOT0           // Se apunta a la base de registros NOT
    MOV R0,#LED_1_MASK          // Se carga la mascara para el LED 1
    STR R0,[R1,#LED_1_OFFSET]   // Se invierte el bit GPIO del LED 1
    MOV  R1,#10                 // Se recarga la espera con 10 iteraciones
systick_exit:
    STRB R1,[R0]                // Se actualiza la variable espera
    BX   LR                     // Se retorna al programa principal
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
