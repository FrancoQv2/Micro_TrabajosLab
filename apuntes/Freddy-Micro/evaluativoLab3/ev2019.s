    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    .include "configuraciones/ciaa.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/
//Recursos utilizados por los
// Recursos utilizados por el canal Verde del led RGB
    .equ LED_G_PORT,    2
    .equ LED_G_PIN,     1
    .equ LED_G_BIT,     1
    .equ LED_G_MASK,    (1 << LED_G_BIT)

// Recursos utilizados por el led RGB
    // Numero de puerto GPIO utilizado por los todos leds
    .equ LED_GPIO,      5
    // Desplazamiento para acceder a los registros GPIO de los leds
    .equ LED_OFFSET,    ( 4 * LED_GPIO )
    // Mascara de 32 bits con un 1 en los bits correspondiente a cada led
    .equ LED_MASK,      ( LED_G_MASK ) 
//-------------------------------- //
//-------------------------------------------------------------//

// Recursos utilizados por los botones S1,S2 y S3
// Recursos utilizados por el botone S1
    .equ S1_PORT, 1
    .equ S1_PIN, 0
    .equ S1_BIT, 4
    .equ S1_MASK, (1 << S1_BIT)

    .equ S1_GPIO, 0
    .equ S1_OFFSET, ( S1_GPIO << 2)
//---------------------------------------//
// Recursos utilizados por el boton S2
    .equ S2_PORT, 1
    .equ S2_PIN, 1
    .equ S2_BIT, 8
    .equ S2_MASK, (1 << S2_BIT)

    .equ S2_GPIO, 0
    .equ S2_OFFSET, ( S2_GPIO << 2)
//----------------------------------------//
// Recursos utilizados por el boton S3
    .equ S3_PORT, 1
    .equ S3_PIN, 2
    .equ S3_BIT, 9
    .equ S3_MASK, (1 << S3_BIT)

    .equ S3_GPIO, 0
    .equ S3_OFFSET, ( S3_GPIO << 2)
//----------------------------------------//
//Recursos ultizados por los tres botones
    .equ BOTONES_GPIO, 0
    .equ BOTONES_OFFSET, ( BOTONES_GPIO << 2)
    .equ BOTONES_MASK, ( S1_MASK | S2_MASK | S3_MASK )
//---------------------------------------//
//-------------------------------------------------------------//

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
    
// Recursos utilizados por el PUNTO
    .equ SEG_P_PORT, 6
    .equ SEG_P_PIN,  8
    .equ SEG_P_BIT,  16
    .equ SEG_P_MASK, (1 << SEG_P_BIT)

// Recursos utilizados por los segmentos
    .equ SEG_GPIO, 2
    .equ SEG_OFFSET, ( SEG_GPIO << 2)
    .equ SEG_MASK, ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK ) 
// Recursos utilizados por el punto
    .equ DP_GPIO, 5
    .equ DP_OFFSET, ( DP_GPIO << 2)
    .equ DP_MASK, ( SEG_P_MASK ) 
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
refresco:
    .byte 0x03
hora:
    .byte 0x02,0x01,0x00         // Vector correspondiente las HH:MM:SS

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
    LDR R9,=tabla  //Puntero a la primera dirección de la tabla
    MOV R10,#0x00  //Bandera para iniciar o pausar la cuenta

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

    // Se configuran el pin del LED verde como gpio sin pull-up
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(4 * (32 * LED_G_PORT + LED_G_PIN))]

    // Se configuran los pines de los BOTONES S1,S2 y S3 como gpio con pull-up
    MOV R0,#( SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0 )
    STR R0,[R1,#(S1_PORT << 7 | S1_PIN << 2)]
    STR R0,[R1,#(S2_PORT << 7 | S2_PIN << 2)]
    STR R0,[R1,#(S3_PORT << 7 | S3_PIN << 2)]

////////////APAGO LOS BITS PARA NO GENERAR BASURA//////////
    // Apaga el bit gpio del los Displays
    LDR R1,=GPIO_CLR0
    LDR R0,=DISP_MASK  //limpio el bit correpondiente a los display
    STR R0,[R1,#DISP_OFFSET]
    // Se apagan los bits gpio correspondientes a los SEGMENTOS A,B,C,D,E,F y G
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]
    // Se apaga el bit correspondiente al Punto del display
    LDR R0,=DP_MASK
    STR R0,[R1,#DP_OFFSET]
    // Se apaga el bit correspondiente al LED verde
    LDR R0,=LED_G_MASK  //limpio el bit correpondiente al led verde
    STR R0,[R1,#LED_OFFSET]
    // Se apagan los bits de los botones
    AND R0,#BOTONES_MASK
    STR R0,[R1,#BOTONES_OFFSET]
///////////////////////////////////////////////////////////

///////////////CONFIGURACIONES///////////////////////////
    // Se configuran el bit del gpio de los Displays como salida
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#DISP_OFFSET]
    ORR R0,DISP_MASK
    STR R0,[R1,#DISP_OFFSET]
    // Se configuran los bits gpio de los SEGMENTOS A,B,C,D,E,F y G como salidas
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,SEG_MASK
    STR R0,[R1,#SEG_OFFSET]
    // Se configura el bit gpio del Punto del display como salida
    LDR R0,[R1,#DP_OFFSET]
    ORR R0,DP_MASK
    STR R0,[R1,#DP_OFFSET]
    // Se configura el bit del LED verde como salida
    LDR R0,[R1,#LED_OFFSET]
    ORR R0,LED_G_MASK
    STR R0,[R1,#LED_OFFSET]
    // Se configuran los bits gpio de los botones S1,S2 y S3 como entrada
    LDR R0,[R1,#BOTONES_OFFSET]
    AND R0,#~BOTONES_MASK
    STR R0,[R1,#BOTONES_OFFSET]
    
//////////////////////////////////////////////////////////////

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0  //direccion base de GPIO
    LDR R5,=GPIO_NOT0  //invierte el estado actual del bit

verbotones:
//    LDR R3,[R4,#DP_OFFSET]
//    ORR R3,R3,#DP_MASK
//    STR R3,[R4,#DP_OFFSET]
//    LDR R3,[R4,#SEG_OFFSET]
//    ORR R3,R3,#SEG_F_MASK
//    STR R3,[R4,#SEG_OFFSET]
//    LDR R3,[R4,#DISP1_OFFSET]
//    ORR R3,#DISP1_MASK
//    STR R3,[R4,#DISP1_OFFSET]
//    B verbotones

    LDR R3,[R4,#BOTONES_OFFSET]  //Recupero el estado de los botones desde el GPIO5
    MOV R1,R3                    //Para usar la tecla S1
    AND R1,R1,#S1_MASK           //Dejos solo el bit 5
    LSR R1,R1,#S1_BIT            //Desplazo 4 bits a la derecha y me quedo con el bit 5 que corresponde al bit 4 del GPIO5 (S1)
    CMP R1,#0                    //Veo si el boton está apretado (bit 5 en 1)
    BEQ soltar_s1                //Si está apretado, espero a que se suelte
    MOV R2,R3                    //Para usar la tecla S2
    AND R2,R2,#S2_MASK           //Dejos solo el bit 5
    LSR R2,R2,#S2_BIT            //Desplazo 4 bits a la derecha y me quedo con el bit 5 que corresponde al bit 4 del GPIO5 (S1)
    CMP R2,#0                    //Veo si el boton está apretado (bit 5 en 1)
    BEQ soltar_s2                //Si está apretado, espero a que se suelte
    AND R3,R3,#S3_MASK           //Dejos solo el bit 5
    LSR R3,R3,#S3_BIT            //Desplazo 4 bits a la derecha y me quedo con el bit 5 que corresponde al bit 4 del GPIO5 (S1)
    CMP R3,#0                    //Veo si el boton está apretado (bit 5 en 1)
    BEQ soltar_s3                //Si está apretado, espero a que se suelte
    B verbotones                 //Repito el lazo infinitamente

soltar_s1:
    LDR R3,[R4,#BOTONES_OFFSET] //Recupero el estado de los botones desde el GPIO5
    MOV R1,R3
    AND R1,R1,#S1_MASK          //Dejos solo el bit 5
    LSR R1,R1,#S1_BIT           //Desplazo 4 bits a la derecha y me quedo con el bit 5 que corresponde al bit 4 del GPIO5 (S1)
    CMP R1,#1                   //Veo si el boton está apretado (bit 5 en 1)
    BNE soltar_s1               //Si el botón continua apretado, repito el lazo
    MOV R10,#0                  //Si el botón ya no está apretado, pongo la bandera habilitadora de cuenta en 0 para que no cuente
    B verbotones

soltar_s2:
    LDR R3,[R4,#BOTONES_OFFSET] //Recupero el estado de los botones desde el GPIO5
    MOV R2,R3
    AND R2,R2,#S2_MASK          //Dejos solo el bit 5
    LSR R2,R2,#S2_BIT           //Desplazo 4 bits a la derecha y me quedo con el bit 5 que corresponde al bit 4 del GPIO5 (S1)
    CMP R2,#1                   //Veo si el boton está apretado (bit 5 en 1)
    BNE soltar_s2               //Si el botón continua apretado, repito el lazo
    MOV R10,#1                  //Si el botón ya no está apretado, pongo la bandera habilitadora de cuenta en 0 para que no cuenta
    B verbotones


soltar_s3:
    LDR R3,[R4,#BOTONES_OFFSET] //Recupero el estado de los botones desde el GPIO5
    AND R3,R3,#S3_MASK          //Dejos solo el bit 5
    LSR R3,R3,#S3_BIT           //Desplazo 4 bits a la derecha y me quedo con el bit 5 que corresponde al bit 4 del GPIO5 (S1)
    CMP R3,#1                   //Veo si el boton está apretado (bit 5 en 1)
    BNE soltar_s3               //Si el botón continua apretado, repito el lazo
    MOV R3,#4                   //Si el boton ya se soló, pongo la unidad de los segundos en 4
    LDR R8,=hora+1              //Apunto a la direccion de la undidad de segundo en el vector de hora
    STRB R3,[R8]                //Guardo el valor 4 en la unidad de los segundos
    MOV R3,#2                   //Pongo la decena de los segundos en 2
    LDR R8,=hora+2              //Apunto a la direccion de la decena de segundo en el vector
    STRB R3,[R8]                //Guardo el valor 2 en la decena de los segundos
    LDR R0,[R4,#LED_OFFSET]     //Pongo en R0 el estado actual del bit del led green
    AND R0,#~LED_G_MASK         //Apago el led green poniendo en 0 su bit
    STR R0,[R4,#LED_OFFSET]     //Guardo el estado del bit del led
    B verbotones

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
    LDR R0,=#(4800000 - 1)
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
    LDR  R0,=espera             //Se apunta R0 a la variable espera
    LDRB R1,[R0]                //Se carga el valor de la variable espera
    SUBS R1,#1                  //Se decrementa el valor de espera

    PUSH {R0-R5,R7-R9,LR}       //Guardo el estado actual
    BL mostrar                  //Llamo a la funcion de mostrar display
    POP {R0-R5,R7-R9,LR}  

    BHI  disminuye           // Si Espera > 0 entonces NO pasaron 10 veces

    MOV  R1,#10               // Se recarga la espera con 10 iteraciones
systick_exit:


    //LDR R2,=refresco            // Uso una variable para saber cada cuanto muestro los displays
    //LDRB R3,[R2]                // Traigo su valor actual 
    //SUBS R3,#1                  // La decremento en 1 y activo una bandera
    //CMP R3,#0
    //BEQ ref                     // Si la bandera llego a 0 muestro el display
    //B systick_salir             // Si la bandera no llego a 0 continuo la ejecucion
//ref:
//    PUSH {R0-R5,R7-R9,LR}       //Guardo el estado actual
//    BL mostrar                  //Llamo a la funcion de mostrar display
//    POP {R0-R5,R7-R9,LR}        //Recupero el estado actual
//    MOV R2,#30                  //Vuelvo a 30 la variable
//    B systick_exit              //Retorno al programa principal

//systick_salir:
    //STRB R3,[R2]                // Se actualiza la variable refresco
    STRB R1,[R0]                // Se actualiza la variable espera
    BX   LR                     // Se retorna al programa principal

disminuye:
    CMP R10,#0                  //Verifico el estado de la bandera habilitadora de cuenta
    BEQ salir_disminuye           //Si la bandera está en 0, no aumento el reloj
    PUSH {R0-R9,LR}             //Si la bandera está en 1, guardo el estado y llamo a la rutina para aumentar la hora
    BL disminuir                 //Rutina para aumentar la hora
    POP {R0-R9,LR}              //Recupero el estado actual al salir de la rutina
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
    LDR R8,=hora//Apunto al minuto D1
    LDRB R5,[R8] //Cargo en R5 el valor del decremento D1
    CMP R5,#0
    BNE restoD1
    LDR R8,=hora+1//Apunto al segundo S0
    LDRB R6,[R8]  //Cargo en R6 el valor del segundo S0
    SUB R6,#1     //Decremento el valor del segundo S0
    CMP R6,#0
    BGE resetD1
    LDR R8,=hora+2//Apunto al segundo S1
    LDRB R7,[R8]  //Cargo en R7 el valor del segundo S1
    SUB R7,#1     //Decremento el valor del segundo S1
    CMP R7,#0
    BGE resetD1S0
    LDR R0,[R4,#LED_OFFSET]
    ORR R0,#LED_G_MASK
    STR R0,[R4,#LED_OFFSET]
    B salir_disminuir
restoD1:
    SUB R5,#1
    STRB R5,[R8]
    B salir_disminuir
resetD1:
    STRB R6,[R8]
    LDR R8,=hora
    MOV R6,#9
    STRB R6,[R8]
    B salir_disminuir
resetD1S0:
    LDR R8,=hora+2 //Apunto al segundo S1
    STRB R7,[R8]   //Guardo en S1 el valor R7
    MOV R6,#9      //Pongo S0 en 9
    LDR R8,=hora+1 //Apunto al segundo S0
    STRB R6,[R8]   //Guardo en S0 el valor 9
    LDR R8,=hora   //Apunto al decima D1
    STRB R6,[R8]   //Guardo en D1 el valor 9
salir_disminuir:
    BX LR

###################################################################

///////////////////////SUBRUTINA Mostrar Hora///////////////////////////////////////

mostrar:
    MOV R3,#0
    LDR R7,=switch //Apunta R7 al bloque con la tabla
//seguir:
    LDR R2,[R7,R6,LSL #2] // Cargar en R2 la dirección del caso switch
    ORR R2,0x01    // Fija el MSB para indicar instrucciones THUMB
    BX R2 
.align // Asegura que la tabla de saltos este alineada
switch: .word case0, case1, case2
case0: ORR R3,#DISP1_MASK
       AND R3,#~DISP2_MASK
       AND R3,#~DISP3_MASK
       AND R3,#~DISP4_MASK
       B break 
case1: ORR R3,#DISP2_MASK
       AND R3,#~DISP1_MASK
       AND R3,#~DISP3_MASK
       AND R3,#~DISP4_MASK
       B break 
case2: ORR R3,#DISP3_MASK
       AND R3,#~DISP1_MASK
       AND R3,#~DISP2_MASK
       AND R3,#~DISP4_MASK
       B break
break: LDR R7,=hora  //Apunto R7 a la direccion del vector del reloj
       ADD R7,R7,R6  //Apunto R7 al elemento que quiero mostrar (Hora, Min,Seg)
       LDRB R8,[R7]  //Extraigo del vector el numero que quiero mostrar
       ADD R8,R8,R9  //Apunto a la direccion del elemento convertido de tabla
       LDRB R8,[R8]  //Traigo el valor convertido a 7 SEGMENTOS de la tabla
       STR R8,[R4,#SEG_OFFSET]   //Pongo en alto los bits correspodientes al numero que quiero mostrar
      // CMP R6,#1
      // BEQ punto
      // B apago

       AND R2,R6,#0x01
       LSL R2,#SEG_P_BIT
       STR R2,[R4,#DP_OFFSET]

sigue:
       STR R3,[R4,#DISP_OFFSET]  //Activo el display correspondiente
       AND R3,#~DISP1_MASK       //Apago todos los segmentos luego de mostrarlos
       AND R3,#~DISP2_MASK
       AND R3,#~DISP3_MASK
       AND R3,#~DISP4_MASK
       STR R3,[R4,#DISP_OFFSET]
       ADD R6,R6,#1  //Aumento la bandera que indica cual display muestro
       CMP R6,#2      //Bandera para ver que display encender
       BHI cerar      //Si estoy en el cuarto display (que no existe) reinicio la bandera
       B salir_mostrar
//punto:
//       LDR R1,[R4,#DP_OFFSET]
//       ORR R1,#DP_MASK
//       STR R1,[R4,#DP_OFFSET]
//       B sigue
//apago:
//       LDR R1,[R4,#DP_OFFSET]
//       AND R1,#~DP_MASK
//       STR R1,[R4,#DP_OFFSET]
//       B sigue
cerar:
    MOV R6,#0
salir_mostrar:
    BX LR 

///////////////////////FIN DE SUBRUTINA AUMENTAR////////////////////////////////
