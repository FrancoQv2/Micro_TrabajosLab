    .cpu cortex-m4
    .syntax unified
    .thumb

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

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

// Recursos utilizados por la tercera tecla
    .equ TEC_4_PORT,    6
    .equ TEC_4_PIN,     7
    .equ TEC_4_BIT,     15
    .equ TEC_4_MASK,    (1 << TEC_4_BIT)

// Recursos utilizados por el teclado
    .equ TEC_GPIO,      5
    .equ TEC_MASK,      ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK | TEC_4_MASK)

    .equ TEC1, (TEC_GPIO << 5 | TEC_1_BIT)
    .equ TEC2, (TEC_GPIO << 5 | TEC_2_BIT)
    .equ TEC3, (TEC_GPIO << 5 | TEC_3_BIT)
    .equ TEC4, (TEC_GPIO << 5 | TEC_4_BIT)

//Recursos del display 7 segmentos 
    .equ SB_PORT,       4
    .equ SB_PIN,        1
    .equ SB_BIT,        1
    .equ SB_MASK,       (1 << SB_BIT)

    .equ SC_PORT,       4
    .equ SC_PIN,        2
    .equ SC_BIT,        2
    .equ SC_MASK,       (1 << SB_BIT)

    .equ SE_PORT,       4
    .equ SE_PIN,        4
    .equ SE_BIT,        4
    .equ SE_MASK,       (1 << SB_BIT)

    .equ SF_PORT,       4
    .equ SF_PIN,        5
    .equ SF_BIT,        5
    .equ SF_MASK,       (1 << SB_BIT)

    .equ SEG_GPIO,      2
    .equ SEG_MASK,      (SB_MASK | SC_MASK | SE_MASK | SF_MASK)

//Recursos de los digitos
    .equ DIG_PORT,      1
    .equ DIG_PIN,       17
    .equ DIG_BIT,       3
    .equ DIG_GPIO,      0
    .equ DIG_MASK,      (1 << DIG_BIT)

    /****************************************************************************/
    /* Vector de interrupciones                                                 */
    /****************************************************************************/
//
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
    .word   handler+1       // 15: System tick service routine
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
    .word   timer_isr+1     // 28: IRQ 12: TIMER0 service routine
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
    .word   handler+1       // 48: IRQ 32: PIN_INT0 service routine
    .word   handler+1       // 49: IRQ 33: PIN_INT1 service routine
    .word   handler+1       // 50: IRQ 34: PIN_INT2 service routine
    .word   handler+1       // 51: IRQ 35: PIN_INT3 service routine
    .word   handler+1       // 52: IRQ 36: PIN_INT4 service routine
    .word   handler+1       // 53: IRQ 37: PIN_INT5 service routine
    .word   handler+1       // 54: IRQ 38: PIN_INT6 service routine
    .word   handler+1       // 55: IRQ 39: PIN_INT7 service routine
    .word   handler+1       // 56: IRQ 40: GINT0 service routine
    .word   handler+1       // 56: IRQ 40: GINT1 service routine

    .section .data
    .global reset
    .section .text
    .func main
reset:
    CPSID I             //Deshabilita interrupciones
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Configura los pines de los leds como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(SB_PORT << 7 | SB_PIN << 2)]
    STR R0,[R1,#(SC_PORT << 7 | SC_PIN << 2)]
    STR R0,[R1,#(SE_PORT << 7 | SE_PIN << 2)]
    STR R0,[R1,#(SF_PORT << 7 | SF_PIN << 2)]

    // Configura los pines de las teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLDOWN | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(TEC_1_PORT << 7 | TEC_1_PIN << 2)]
    STR R0,[R1,#(TEC_2_PORT << 7 | TEC_2_PIN << 2)]
    STR R0,[R1,#(TEC_3_PORT << 7 | TEC_3_PIN << 2)]
    STR R0,[R1,#(TEC_4_PORT << 7 | TEC_4_PIN << 2)]
