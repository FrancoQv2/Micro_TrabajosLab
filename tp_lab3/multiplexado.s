    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    .include "configuraciones/ciaa.s"
    .include "tp_lab3/poncho.s"         //Hacer una libreria para el poncho

    .section .data          //Define la seccón de variables
pantalla:
    .word SB_MASK + SC_MASK                                     //1
    .word SA_MASK + SB_MASK + SD_MASK + SE_MASK + SG_MASK       //2
    .word SA_MASK + SB_MASK + SC_MASK + SD_MASK + SG_MASK       //3
    .word SB_MASK + SC_MASK + SF_MASK + SG_MASK                 //4 

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    puntero     .req R0
    valor       .req R1

    //Llama a una subrutina existente en flash para configurar los leds
    LDR puntero,=leds_init
    BLX puntero

    // ------------------------------------------------------------------------- 
    //Configuracion de los pines de segmentos como gpio sin pull-up
    LDR puntero,=SCU_BASE
    MOV valor,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR valor,[puntero,#((SA_PORT * 32 + SA_PIN) * 4)]
    STR valor,[puntero,#((SB_PORT * 32 + SB_PIN) * 4)]
    STR valor,[puntero,#((SC_PORT * 32 + SC_PIN) * 4)]
    STR valor,[puntero,#((SD_PORT * 32 + SD_PIN) * 4)]
    STR valor,[puntero,#((SE_PORT * 32 + SE_PIN) * 4)]
    STR valor,[puntero,#((SF_PORT * 32 + SF_PIN) * 4)]
    STR valor,[puntero,#((SG_PORT * 32 + SG_PIN) * 4)]
    STR valor,[puntero,#((SDP_PORT * 32 + SDP_PIN) * 4)]

    //Configuracion de los pines de digitos como gpio sin pull-up
    STR valor,[puntero,#((D1_PORT << 5 + D1_PIN) << 2)]
    STR valor,[puntero,#((D2_PORT << 5 + D2_PIN) << 2)]
    STR valor,[puntero,#((D3_PORT << 5 + D3_PIN) << 2)]
    STR valor,[puntero,#((D4_PORT << 5 + D4_PIN) << 2)]

    // ------------------------------------------------------------------------- 
    //Apagado de todos los bits gpio de los segmentos
    LDR puntero,=GPIO_CLR0
    LDR valor,=SEG_MASK
    STR valor,[puntero,#SEG_OFFSET]
    LDR valor,=SDP_MASK
    STR valor,[puntero,#SDP_OFFSET]

    //Apagado de todos los bits gpio de los digitos
    LDR valor,=DIG_MASK
    STR valor,[puntero,#DIG_OFFSET]

    // ------------------------------------------------------------------------
    //Configuracion de los bits gpio de segmentos como salidas
    LDR puntero,=GPIO_DIR0
    LDR valor,[puntero,#SEG_OFFSET]
    ORR valor,#SEG_MASK
    STR valor,[puntero,#SEG_OFFSET]

    LDR valor,[puntero,#SDP_OFFSET]
    ORR valor,#SDP_MASK
    STR valor,[puntero,#SDP_OFFSET]

    //Configuracion de los bits gpio de digitos como salidas
    LDR valor,[puntero,#DIG_OFFSET]
    ORR valor,#DIG_MASK
    STR valor,[puntero,#DIG_OFFSET]

    posicion     .req R2

    MOV posicion,#0

refrescar:
    // Se apagan los puntos comunes de todas las posiciones
    LDR puntero,=GPIO_CLR0
    MOV valor,#DIG_MASK
    STR valor,[puntero,#DIG_OFFSET]

    // Se apagan todos los segmentos
    MOV valor,#SEG_MASK
    STR valor,[puntero,#SEG_OFFSET]

    // Se calcula la nueva posicion como (posicion - 1) mod 4
    ADD posicion,#1
    AND posicion,#3

    // Se recupera la imagen del digito correspondiente a la posicion
    LDR puntero,=pantalla
    LDR valor,[puntero, posicion, LSL #2]

    // Se prenden los segmentos del numero actual
    LDR puntero,=GPIO_SET0
    STR valor,[puntero,#SEG_OFFSET]

    // Se prende el punto comun de la posicion actual
    LDR puntero,=posiciones
    LDR valor,[puntero, posicion, LSL #2]
    LDR puntero,=GPIO_SET0
    STR valor,[puntero,#DIG_OFFSET]

    // Se genera una demora con un lazo que no hace nada
    MOV valor,#0x1000000
demora:
    SUBS valor,#1
    BNE demora

    // Repite el lazo de refresco indefinidamente
    B refrescar
    .pool                       // Almacenar las constantes de codigo
    .endfunc

posiciones:
    .word D1_MASK
    .word D2_MASK
    .word D3_MASK
    .word D4_MASK