    .cpu cortex-m4              
    .syntax unified             
    .thumb                      
    .section .data
vector:
    .hword 8    //tengo 8 elementos en el vector
    .hword 0x55 //necesito si o si hacerlo así ya que la directiva .space solo reserva byte
    .hword 0x55
    .hword 0x55
    .hword 0x55
    .hword 0x55
    .hword 0x55
    .hword 0x55
    .hword 0x55

    .section .text   
    .global reset    
    .func main       
reset:
    B reset
