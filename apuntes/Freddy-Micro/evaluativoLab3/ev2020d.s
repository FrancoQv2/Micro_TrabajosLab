    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    .include "configuraciones/ciaa.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/
// Recursos utilizados por los botones F1,F2, y Aceptar

// Recursos utilizados por el botone F1
    .equ F1_PORT, 4
    .equ F1_PIN, 8
    .equ F1_BIT, 12
    .equ F1_MASK, (1 << F1_BIT)

    .equ F1_GPIO, 5
    .equ F1_OFFSET, ( F1_GPIO << 2)
//---------------------------------------//
// Recursos utilizados por el boton F2
    .equ F2_PORT, 5
    .equ F2_PIN, 9
    .equ F2_BIT, 13
    .equ F2_MASK, (1 << F2_BIT)

    .equ F2_GPIO, 5
    .equ F2_OFFSET, ( F2_GPIO << 2)
//----------------------------------------//
// Recursos utilizados por el boton Aceptar
    .equ ACEPTAR_PORT, 3
    .equ ACEPTAR_PIN, 2
    .equ ACEPTAR_BIT, 9
    .equ ACEPTAR_MASK, (1 << ACEPTAR_BIT)

    .equ ACEPTAR_GPIO, 5
    .equ ACEPTAR_OFFSET, ( ACEPTAR_GPIO << 2)
//----------------------------------------//
//Recursos ultizados por los botones
    .equ BOTONES_GPIO, 5
    .equ BOTONES_OFFSET, ( BOTONES_GPIO << 2)
    .equ BOTONES_MASK, ( F1_MASK | F2_MASK | ACEPTAR_MASK )
//---------------------------------------//

//Recursos utilizados por los LEDS 1 y 2
//--------------------------------------//
// Recursos utilizados por el led 1
    .equ LED_2_PORT,    2
    .equ LED_2_PIN,     10
    .equ LED_2_BIT,     14
    .equ LED_2_MASK,    (1 << LED_2_BIT)

    
    .equ LED_1_GPIO,    0
    .equ LED_1_OFFSET,  ( LED_1_GPIO << 2 )

// Recursos utilizados por el led 2
    .equ LED_2_PORT,    2
    .equ LED_2_PIN,     11
    .equ LED_2_BIT,     11
    .equ LED_2_MASK,    (1 << LED_2_BIT)

    .equ LED_2_GPIO,    1
    .equ LED_2_OFFSET,  ( LED_2_GPIO << 2 )
//---------------------------------------------//

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
    .byte 0x03              // Vector correspondiente a los segundos

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

    MOV R6,#0x00   //Bandera para elejir que display mostrar
    MOV R10,#0x00  //Bandera para iniciar o pausar la cuentas

    MOV R7,0x00    //Bandera para saber si apretó antes de tiempo
    MOV R9,0x00    //Bandera para saber quien ganó

// Llama a una subrutina para configurar el systick
    BL systick_init

    // Se configuran los pines de los leds 1 y 2 como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(LED_1_PORT << 7 | LED_1_PIN << 2)]
    STR R0,[R1,#(LED_2_PORT << 7 | LED_2_PIN << 2)]

    // Se configuran el pin del LED verde como gpio sin pull-up
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(4 * (32 * LED_G_PORT + LED_G_PIN))]

    // Se configuran los pines de los BOTONES F1,F2 y Aceptar como gpio con pull-up
    MOV R0,#( SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0 )
    STR R0,[R1,#(F1_PORT << 7 | F1_PIN << 2)]
    STR R0,[R1,#(F2_PORT << 7 | F2_PIN << 2)]
    STR R0,[R1,#(ACEPTAR_PORT << 7 | ACEPTAR_PIN << 2)]

////////////APAGO LOS BITS PARA NO GENERAR BASURA//////////
    // Apaga el bit gpio del los Displays
    LDR R1,=GPIO_CLR0
    // Se apaga el bit correspondiente al LED 1 y 2
    LDR R0,=LED_1_MASK  //limpio el bit correpondiente al led 1
    STR R0,[R1,#LED_1_OFFSET]
    LDR R0,=LED_2_MASK  //limpio el bit correpondiente al led 2
    STR R0,[R1,#LED_2_OFFSET]
    // Se apagan los bits de los botones
    AND R0,#BOTONES_MASK
    STR R0,[R1,#BOTONES_OFFSET]
///////////////////////////////////////////////////////////

///////////////CONFIGURACIONES///////////////////////////
    // Se configura el bit de los LEDS verde como salida
    LDR R0,[R1,#LED_1_OFFSET]
    ORR R0,LED_1_MASK
    STR R0,[R1,#LED_1_OFFSET]
    LDR R0,[R1,#LED_2_OFFSET]
    ORR R0,LED_2_MASK
    STR R0,[R1,#LED_2_OFFSET]
    // Se configuran los bits gpio de los botones F1,F2 y ACEPTAR como entrada
    LDR R0,[R1,#BOTONES_OFFSET]
    AND R0,#~BOTONES_MASK
    STR R0,[R1,#BOTONES_OFFSET]
    
//////////////////////////////////////////////////////////////

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0  //direccion base de GPIO
    LDR R5,=GPIO_NOT0  //invierte el estado actual del bit

verbotones:

    LDR R3,[R4,#BOTONES_OFFSET]  //Recupero el estado de los botones desde el GPIO5
    MOV R1,R3                    //Para usar la tecla F1
    AND R1,R1,#F1_MASK           //Dejos solo el bit
    LSR R1,R1,#F1_BIT            //Desplazo bits a la derecha y me quedo con el bit que corresponde al bit del GPIO5 (F1)
    CMP R1,#1                    //Veo si el boton está apretado (bit en 1)
    BEQ soltar_F1                //Si está apretado, espero a que se suelte
    MOV R2,R3                    //Para usar la tecla F2
    AND R2,R2,#F2_MASK           //Dejos solo el bit
    LSR R2,R2,#F2_BIT            //Desplazo bits a la derecha y me quedo con el bit que corresponde al bit del GPIO5 (F2)
    CMP R2,#1                    //Veo si el boton está apretado (bit en 1)
    BEQ soltar_F2                //Si está apretado, espero a que se suelte
    AND R3,R3,#ACEPTAR_MASK      //Dejos solo el bit
    LSR R3,R3,#ACEPTAR_BIT       //Desplazo bits a la derecha y me quedo con el bit que corresponde al bit del GPIO5 (Aceptar)
    CMP R3,#1                    //Veo si el boton está apretado (bit en 1)
    BEQ soltar_Aceptar           //Si está apretado, espero a que se suelte
    CMP R9,#0                    //Verifico si ya hay un ganador
    BNE stop                     //Si lo hay enciendo el LED correspondiente y entro a un bucle infinito
    B verbotones                 //Repito el lazo infinitamente

soltar_F1:
    CMP R7,#1                    //Si se presionó antes de tiempo no lo toma como ganador
    BNE ganoF2                //Espera que la suelte para vovler a participar
    MOV R9,#1                    //Si se presionó correctamente el ganador es el 1
seguir_F1:
    LDR R3,[R4,#BOTONES_OFFSET] //Recupero el estado de los botones desde el GPIO5
    MOV R1,R3
    AND R1,R1,#F1_MASK          //Dejos solo el bit 5
    LSR R1,R1,#F1_BIT           //Desplazo 4 bits a la derecha y me quedo con el bit 5 que corresponde al bit 4 del GPIO5 (S1)
    CMP R1,#1                   //Veo si el boton está apretado (bit 5 en 1)
    BEQ seguir_F1               //Si el botón continua apretado, repito el lazo
    MOV R10,#0                  //Si el botón ya no está apretado, pongo la bandera habilitadora de cuenta en 0 para que no cuente
    B verbotones

soltar_F2:
    CMP R7,#1                    //Si se presionó antes de tiempo no lo toma como ganador
    BNE ganoF1                //Espera que la suelte para vovler a participar
    MOV R9,#2                    //Si se presionó correctamente el ganador es el 1
seguir_F2:
    LDR R3,[R4,#BOTONES_OFFSET] //Recupero el estado de los botones desde el GPIO5
    MOV R2,R3
    AND R2,R2,#F2_MASK          //Dejos solo el bit 5
    LSR R2,R2,#F2_BIT           //Desplazo 4 bits a la derecha y me quedo con el bit 5 que corresponde al bit 4 del GPIO5 (S1)
    CMP R2,#1                   //Veo si el boton está apretado (bit 5 en 1)
    BEQ seguir_F2               //Si el botón continua apretado, repito el lazo
    MOV R10,#1                  //Si el botón ya no está apretado, pongo la bandera habilitadora de cuenta en 0 para que no cuenta
    B verbotones

ganoF1:
    MOV R9,#1
    B stop
ganoF2:
    MOV R9,#2
    B stop

soltar_Aceptar:
    LDR R3,[R4,#BOTONES_OFFSET] //Recupero el estado de los botones desde el GPIO5
    AND R3,R3,#ACEPTAR_MASK          //Dejos solo el bit
    LSR R3,R3,#ACEPTAR_BIT           //Desplazo bits a la derecha y me quedo con el bit que corresponde al bit del GPIO5 (F1)
    CMP R3,#1                   //Veo si el boton está apretado (bit en 1)
    BEQ soltar_Aceptar               //Si el botón continua apretado, repito el lazo
    MOV R2,#3                   //Si el boton ya se soltó, pongo la unidad de los segundos en 3
    MOV R7,#0
    MOV R9,#0
    LDR R8,=hora              //Apunto a la direccion de la undidad de segundo en el vector de hora
    STRB R2,[R8]                //Guardo el valor 3 en la unidad de los segundos
    //Apago ambos leds
    LDR R0,[R4,#LED_1_OFFSET]     //Pongo en R0 el estado actual del bit del led 1
    AND R0,#~LED_1_MASK           //Apago el led 1 poniendo en 0 su bit
    STR R0,[R4,#LED_1_OFFSET]     //Guardo el estado del bit del led
    LDR R0,[R4,#LED_2_OFFSET]     //Pongo en R0 el estado actual del bit del led 2
    AND R0,#~LED_2_MASK           //Apago el led 2 poniendo en 0 su bit
    STR R0,[R4,#LED_2_OFFSET]     //Guardo el estado del bit del led
    MOV R10,#1                  //Ademas activo la bandera habilitadora de cuenta
    B verbotones

stop:
    CMP R9,#1
    ITT EQ
    MOVEQ R0,#LED_1_MASK 
    MOVEQ R1,#LED_1_OFFSET
    CMP R9,#2
    ITT EQ
    MOVEQ R0,#LED_2_MASK
    MOVEQ R1,#LED_2_OFFSET
    STR R0,[R4,R1]
final:

    LDR R3,[R4,#BOTONES_OFFSET]  //Recupero el estado de los botones desde el GPIO5
    AND R3,R3,#ACEPTAR_MASK      //Dejos solo el bit
    LSR R3,R3,#ACEPTAR_BIT       //Desplazo bits a la derecha y me quedo con el bit que corresponde al bit del GPIO5 (Aceptar)
    CMP R3,#1                    //Veo si el boton está apretado (bit en 1)
    BEQ soltar_Aceptar           //Si está apretado, espero a que se suelte
    B final
    .pool                        // Almacenar las constantes de código
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
    .pool                   // Almacenar las constantes de código
.endfunc

/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
    .func systick_isr
systick_isr:
    LDR  R0,=espera             //Se apunta R0 a la variable espera
    LDRB R1,[R0]                //Se carga el valor de la variable espera
    SUBS R1,#1                  //Se decrementa el valor de espera

    BHI  disminuye           // Si Espera > 0 entonces NO pasaron 10 veces

    MOV  R1,#10               // Se recarga la espera con 10 iteraciones
systick_exit:
    STRB R1,[R0]                // Se actualiza la variable espera
    BX   LR                     // Se retorna al programa principal

disminuye:
    CMP R10,#0                  //Verifico el estado de la bandera habilitadora de cuenta
    BEQ salir_disminuye           //Si la bandera está en 0, no disminuye el segundo
    PUSH {R5-R9,LR}             //Si la bandera está en 1, guardo el estado y llamo a la rutina para disminuir
    BL disminuir                 //Rutina para disminuir el segundo
    POP {R5-R9,LR}              //Recupero el estado actual al salir del pograma
salir_disminuye:
    BX LR                       //Retomo el programa

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

disminuir:
    MOV R7,#0
    LDR R6,=hora//Apunto a la unidad de los segundos en el vector
    LDRB R5,[R6] //Cargo en R5 el valor del segundo
    SUB R5,#1    //Disminuyo en 1 la cuenta
    CMP R5,#0    //Verifico si es cero
    BEQ deshabilitar //Si es cero deshabilito la cuenta
salir_disminuir:
    STR R5,[R6]      //Guardo el estado actual del segundo
    BX LR            //Retomo el programa principal

deshabilitar:
    MOV R7,#1
    MOV R10,#0  //pongo en 0 la bandera habilitadora
    B salir_disminuir //Salgo de la subrutina

###################################################################
