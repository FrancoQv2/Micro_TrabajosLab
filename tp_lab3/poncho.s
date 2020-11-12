/****************************************************************************/
/* Definiciones de macros del poncho                                        */
/****************************************************************************/

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

// Recursos utilizados por la tecla ACEPTAR
    .equ TEC_A_PORT,    3
    .equ TEC_A_PIN,     1
    .equ TEC_A_BIT,     8
    .equ TEC_A_MASK,    (1 << TEC_A_BIT)

// Recursos utilizados por la tecla CANCELAR
    .equ TEC_C_PORT,    3
    .equ TEC_C_PIN,     2
    .equ TEC_C_BIT,     9
    .equ TEC_C_MASK,    (1 << TEC_C_BIT)

// Recursos utilizados por el teclado (los cuatro botones + aceptar + cancelar)
    .equ TEC_GPIO,      5
    .equ TEC_MASK,      ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK | TEC_4_MASK | TEC_A_MASK | TEC_C_MASK )


// -------------------------------------------------------------------------
// Recursos de cada digito de la pantalla
    .equ DIG1_PORT,    0
    .equ DIG1_PIN,     0
    .equ DIG1_BIT,     0
    .equ DIG1_MASK,    (1 << DIG1_BIT)

    .equ DIG2_PORT,    0
    .equ DIG2_PIN,     1
    .equ DIG2_BIT,     1
    .equ DIG2_MASK,    (1 << DIG2_BIT)

    .equ DIG3_PORT,    1
    .equ DIG3_PIN,     15
    .equ DIG3_BIT,     2
    .equ DIG3_MASK,    (1 << DIG3_BIT)

    .equ DIG4_PORT,    1
    .equ DIG4_PIN,     17
    .equ DIG4_BIT,     3
    .equ DIG4_MASK,    (1 << DIG4_BIT)

    .equ DIG_GPIO,      0
    .equ DIG_MASK,      ( DIG1_MASK | DIG2_MASK | DIG3_MASK | DIG4_MASK )


// -------------------------------------------------------------------------
// Recursos los segmentos del display 7 segmentos
    .equ SA_PORT,    4
    .equ SA_PIN,     0
    .equ SA_BIT,     0
    .equ SA_MASK,    (1 << SA_BIT)

    .equ SB_PORT,    4
    .equ SB_PIN,     1
    .equ SB_BIT,     1
    .equ SB_MASK,    (1 << SB_BIT)

    .equ SC_PORT,    4
    .equ SC_PIN,     2
    .equ SC_BIT,     2
    .equ SC_MASK,    (1 << SC_BIT)

    .equ SD_PORT,    4
    .equ SD_PIN,     3
    .equ SD_BIT,     3
    .equ SD_MASK,    (1 << SD_BIT)

    .equ SE_PORT,    4
    .equ SE_PIN,     4
    .equ SE_BIT,     4
    .equ SE_MASK,    (1 << SE_BIT)

    .equ SF_PORT,    4
    .equ SF_PIN,     5
    .equ SF_BIT,     5
    .equ SF_MASK,    (1 << SF_BIT)

    .equ SG_PORT,    4
    .equ SG_PIN,     6
    .equ SG_BIT,     6
    .equ SG_MASK,    (1 << SG_BIT)

    .equ S_GPIO,      2
    .equ S_MASK,      (SA_MASK | SB_MASK | SC_MASK | SD_MASK | SE_MASK | SF_MASK | SG_MASK)

    .equ SDP_PORT,    6
    .equ SDP_PIN,     8
    .equ SDP_BIT,     16
    .equ SDP_GPIO,      5
    .equ SDP_MASK,    (1 << SDP_BIT)
    
// -------------------------------------------------------------------------
//Recursos del display 7 segmentos
    .equ DIG_PORT,      1
    .equ DIG_PIN,       17
    .equ DIG_BIT,       3
    .equ DIG_GPIO,      0
    .equ DIG_MASK,      (1 << DIG_BIT)