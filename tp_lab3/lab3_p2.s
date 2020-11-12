    .cpu cortex-m4          // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    
/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// Recursos utilizados por el canal Rojo del led RGB
    .equ LED_R_PORT,    2
    .equ LED_R_PIN,     0
    .equ LED_R_BIT,     0
    .equ LED_R_MASK,    (1 << LED_R_BIT)

// Recursos utilizados por el canal Verde del led RGB
    .equ LED_G_PORT,    2
    .equ LED_G_PIN,     1
    .equ LED_G_BIT,     1
    .equ LED_G_MASK,    (1 << LED_G_BIT)

// Recursos utilizados por el canal Azul del led RGB
    .equ LED_B_PORT,    2
    .equ LED_B_PIN,     2
    .equ LED_B_BIT,     2
    .equ LED_B_MASK,    (1 << LED_B_BIT)

// Recursos utilizados por el led RGB
    .equ LED_GPIO,      5
    .equ LED_MASK,      ( LED_R_MASK | LED_G_MASK | LED_B_MASK )

// -------------------------------------------------------------------------
// Recursos utilizados por la primera tecla
    .equ TEC_1_PORT,    4
    .equ TEC_1_PIN,     8
    .equ TEC_1_BIT,     12
    .equ TEC_1_MASK,    (1 << TEC_1_BIT)

// Recursos utilizados por la segunda tecla
    .equ TEC_2_PORT,    4
    .equ TEC_2_PIN,     9
    .equ TEC_2_BIT,     13
    .equ TEC_2_MASK,    (1 << TEC_2_BIT)

// Recursos utilizados por la tercera tecla
    .equ TEC_3_PORT,    4
    .equ TEC_3_PIN,     10
    .equ TEC_3_BIT,     14
    .equ TEC_3_MASK,    (1 << TEC_3_BIT)

// Recursos utilizados por la cuarta tecla
    .equ TEC_4_PORT,    6
    .equ TEC_4_PIN,     7
    .equ TEC_4_BIT,     15
    .equ TEC_4_MASK,    (1 << TEC_4_BIT)

// Recursos utilizados por el teclado (las cuatro teclas)
    .equ TEC_GPIO,      0
    .equ TEC_MASK,      ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK | TEC_4_MASK )

    .equ TEC1, (TEC_GPIO << 5 | TEC_1_BIT)
    .equ TEC2, (TEC_GPIO << 5 | TEC_2_BIT)
    .equ TEC3, (TEC_GPIO << 5 | TEC_3_BIT)
    .equ TEC4, (TEC_GPIO << 5 | TEC_4_BIT)

// Recursos los 4 segmentos verticales del display 7 segmentos
    .equ SEG_B_PORT,    4
    .equ SEG_B_PIN,     1
    .equ SEG_B_BIT,     0
    .equ SEG_B_MASK,    (1 << SEG_B_BIT)
    
    .equ SEG_C_PORT,    4
    .equ SEG_C_PIN,     2
    .equ SEG_C_BIT,     2
    .equ SEG_C_MASK,    (1 << SEG_C_BIT)
    
    .equ SEG_E_PORT,    4
    .equ SEG_E_PIN,     4
    .equ SEG_E_BIT,     4
    .equ SEG_E_MASK,    (1 << SEG_E_BIT)
    
    .equ SEG_F_PORT,    4
    .equ SEG_F_PIN,     5
    .equ SEG_F_BIT,     5
    .equ SEG_F_MASK,    (1 << SEG_F_BIT)

    .equ SEG_GPIO,      2
    .equ SEG_MASK,      (SB_MASK | SC_MASK | SE_MASK | SF_MASK)

//Recursos del display 7 segmentos
    .equ DIG_PORT,      1
    .equ DIG_PIN,       17
    .equ DIG_BIT,       3
    .equ DIG_GPIO,      0
    .equ DIG_MASK,      (1 << DIG_BIT)




/****************************************************************************/
/* Vector de interrupciones                                                 */
/****************************************************************************/

    .section .isr
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value: Program entry point
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
    .word   handler+1       // 16: IRQ 0: DAC service routine
    .word   handler+1       // 17: IRQ 1: M0APP service routine
    .word   handler+1       // 18: IRQ 2: DMA service routine
    .word   0               // 19: Reserved entry
    .word   handler+1       // 20: IRQ 4: FLASHEEPROM service routine
    .word   handler+1       // 21: IRQ 5: ETHERNET service routine
    .word   handler+1       // 22: IRQ 6: SDIO service routine
    .word   handler+1       // 23: IRQ 7: LCD service routine
    .word   handler+1       // 24: IRQ 8: USB0 service routine
    .word   handler+1       // 25: IRQ 9: USB1 service routine
    .word   handler+1       // 26: IRQ 10: SCT service routine
    .word   handler+1       // 27: IRQ 11: RTIMER service routine
    .word   handler+1       // 28: IRQ 12: TIMER0 service routine
    .word   handler+1       // 29: IRQ 13: TIMER1 service routine
    .word   handler+1       // 30: IRQ 14: TIMER2 service routine
    .word   handler+1       // 31: IRQ 15: TIMER3 service routine
    .word   handler+1       // 32: IRQ 16: MCPWM service routine
    .word   handler+1       // 33: IRQ 17: ADC0 service routine
    .word   handler+1       // 34: IRQ 18: I2C0 service routine
    .word   handler+1       // 35: IRQ 19: I2C1 service routine
    .word   handler+1       // 36: IRQ 20: SPI service routine
    .word   handler+1       // 37: IRQ 21: ADC1 service routine
    .word   handler+1       // 38: IRQ 22: SSP0 service routine
    .word   handler+1       // 39: IRQ 23: SSP1 service routine
    .word   handler+1       // 40: IRQ 24: USART0 service routine
    .word   handler+1       // 41: IRQ 25: UART1 service routine
    .word   handler+1       // 42: IRQ 26: USART2 service routine
    .word   handler+1       // 43: IRQ 27: USART3 service routine
    .word   handler+1       // 44: IRQ 28: I2S0 service routine
    .word   handler+1       // 45: IRQ 29: I2S1 service routine
    .word   handler+1       // 46: IRQ 30: SPIFI service routine
    .word   handler+1       // 47: IRQ 31: SGPIO service routine
    .word   gpio_isr+1      // 48: IRQ 32: PIN_INT0 service routine
    .word   gpio_isr+1      // 49: IRQ 33: PIN_INT1 service routine
    .word   gpio_isr+1      // 50: IRQ 34: PIN_INT2 service routine
    .word   gpio_isr+1      // 51: IRQ 35: PIN_INT3 service routine
    .word   handler+1       // 52: IRQ 36: PIN_INT4 service routine
    .word   handler+1       // 53: IRQ 37: PIN_INT5 service routine
    .word   handler+1       // 54: IRQ 38: PIN_INT6 service routine
    .word   handler+1       // 55: IRQ 39: PIN_INT7 service routine
    .word   handler+1       // 56: IRQ 40: GINT0 service routine
    .word   handler+1       // 56: IRQ 40: GINT1 service routine


/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM)

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    CPSID I                 // Deshabilita interrupciones

    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Llama a una subrutina existente en flash para configurar los leds
    LDR R1,=leds_init
    BLX R1

    //Calcula el desplazamiento usando el puerto y el pin

    // Configura los pines de los leds como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]

    // Configura los pines de las teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLDOWN | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(TEC_1_PORT << 7 | TEC_1_PIN << 2)]
    STR R0,[R1,#(TEC_2_PORT << 7 | TEC_2_PIN << 2)]
    STR R0,[R1,#(TEC_3_PORT << 7 | TEC_3_PIN << 2)]
    STR R0,[R1,#(TEC_4_PORT << 7 | TEC_4_PIN << 2)]

    // Selecciono las cuatro teclas como fuente de interrupcion
    LDR R0,=(TEC3 << 16 | TEC2 << 8 | TEC1 << 0)
    STR R0,[R1,#PINTSEL0]

    // Apaga todos los bits gpio de los leds
    LDR R1,=GPIO_CLR0
    LDR R0,=LED_MASK
    STR R0,[R1,#(LED_GPIO << 2)]

    // Configura los bits gpio de los leds como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#(LED_GPIO << 2)]
    ORR R0,#LED_MASK
    STR R0,[R1,#(LED_GPIO << 2)]

    // Configura los bits gpio de los botones como entradas
    LDR R0,[R1,#(TEC_GPIO << 2)]
    AND R0,#~TEC_MASK
    STR R0,[R1,#(TEC_GPIO << 2)]

    // Borro los pedidos pendientes de interrupciones del GPIO
    MOV R0,#0xFF
    STR R0,[R4,#IST]

    LDR R1,=NVIC_ICPR1
    MOV R0,0x0F
    STR R0,[R1]

    // Habilito los pedidos de interrupciones del GPIO en el NVIC
    LDR R1,=NVIC_ISER1
    MOV R0,0x0F
    STR R0,[R1]

    CPSIE I                 // Rehabilita interrupciones

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0

refrescar:
    // Define el estado actual de los leds como todos apagados 
    MOV   R3,#0x00
    // Carga el estado arctual de las teclas
    LDR   R0,[R4,#(TEC_GPIO << 2)]

    // Verifica el estado del bit correspondiente a la tecla uno
    ANDS  R1,R0,#(1 << TEC_1_BIT)
    // Si la tecla esta apretada
    IT    EQ
    // Enciende el bit del canal rojo del led rgb
    ORREQ R3,#(1 << LED_R_BIT)

    // Prende el canal verde si la tecla dos esta apretada
    ANDS  R1,R0,#(1 << TEC_2_BIT)
    IT    EQ
    ORREQ R3,#(1 << LED_G_BIT)

    // Prende el canal azul si la tecla tres esta apretada
    ANDS  R1,R0,#(1 << TEC_3_BIT)
    IT    EQ
    ORREQ R3,#(1 << LED_B_BIT)

    // Actualiza las salidas con el estado definido para los leds
    STR   R3,[R4,#(LED_GPIO << 2)]

    // Repite el lazo de refresco indefinidamente
    B     refrescar

stop:
    B stop

    .pool                   // Almacenar las constantes de código

    .endfunc    

/****************************************************************************/
/* Rutina de servicio para la interrupcion del GPIO                         */
/****************************************************************************/
.func gpio_isr
gpio_isr:
    // Leo el registro con la causa de interupción y borro los eventos
    LDR R1,=PINT_BASE
    LDR R0,[R1,#IST]
    STR R0,[R1,#IST]
    
    // Verifico si la causa de interupcion es el primer boton
    TST R0, #0x01
    ITE NE
    LDRNE R0,=toggle_led_1
    LDREQ R0,=toggle_led_2

    // Llamo a la rutina correspondiente
    PUSH {LR}
    BLX  R0
    POP  {LR}

    BX   LR             // Retorna al programa principal
    .pool
    .endfunc

/****************************************************************************/
/* Rutina de servicio generica para excepciones                             */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.  */
/* Se declara como una medida de seguridad para evitar que el procesador    */
/* se pierda cuando hay una excepcion no prevista por el programador        */
/****************************************************************************/
    .func handler
handler:
    LDR R0,=set_led_1       // Apuntar al incio de una subrutina lejana
    BLX R0                  // Llamar a la rutina para encender el led rojo
    B handler               // Lazo infinito para detener la ejecucion
    .pool                   // Almacenar las constantes de codigo    
    .endfunc