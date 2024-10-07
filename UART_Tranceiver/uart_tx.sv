module uart_tx#(parameter CLK_FRQ=100,
         parameter BAUD_RATE=10)
  (input clk,rst,in_enb,
   input [7:0] in_data,
   output reg tx,done_tx);
  
  localparam baud_count=CLK_FRQ/BAUD_RATE;
  reg uclk=0;
  reg [7:0] data;
  int count,tx_count;
  enum bit[0:0] {IDLE,TRX} state;
 
  //uclk generation
  
  always@(posedge clk) begin
    if(count<baud_count/2)
      count<=count+1;
    else begin
      count<=0;
      uclk<=~uclk;
    end
  end
  
  // FSM
  
  always@(posedge uclk) begin
    if(rst)
      state<=IDLE;
    else begin
      case(state)
        IDLE: begin
          tx_count<=0;
          done_tx<=0;
          tx<=0;
          if(in_data) begin
            state<=TRX;
            data<=in_data;
            tx<=0;
          end
          else
            state<=IDLE;
        end
        
        TRX: begin
          if(tx_count<=7) begin
            tx_count<=tx_count+1;
            tx<=data[tx_count];
            state<=TRX;
          end
          else begin
            tx_count<=0;
            tx<=1;
            state<=IDLE;
            done_tx=1;
          end
        end
        
        default : begin
          state<=IDLE;
        end
      endcase
    end
  end
endmodule
