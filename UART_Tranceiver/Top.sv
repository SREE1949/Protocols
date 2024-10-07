`include "uart_tx.sv"
`include "uart_rx.sv"

module uart_tranceiver#(parameter CLK=1000,
                       parameter BAUD_RATE=100)
  (input clk,rst,in_enb,rx,
   input [7:0] in_data,
   output reg tx,done_tx,done_rx,
   output reg[7:0] rx_data);
  
  uart_tx U1(clk,rst,in_enb,in_data,tx,done_tx);
  uart_rx U2(clk,rst,rx,done_rx,rx_data);
  
endmodule
