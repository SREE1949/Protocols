module uart_rx#(parameter CLK_FRQ=100,
         parameter BAUD_RATE=10)
  (input clk,rst,rx,
   output reg done_rx,
   output reg[7:0] rx_data);
  
  reg uclk=0;
  int count,rx_count;
  localparam baud_count=CLK_FRQ/BAUD_RATE;
  
  enum bit[0:0] {IDLE,RCX} state;
 
  //uclk generation
  
  always@(posedge clk) begin
    if(count<baud_count/2)
      count<=count+1;
    else begin
      count<=0;
      uclk<=~uclk;
    end
  end
  
  //FSM
  
  always@(posedge uclk) begin
    if(rst) begin
      state<=IDLE;
      rx_count<=0;
      rx_data<=0;
      done_rx<=0;
    end
    else begin
      case(state) 
        IDLE: begin
          rx_count<=0;
          rx_data<=0;
          done_rx<=0;
          if(rx==0)
            state<=RCX;
          else
            state<=IDLE;
        end
        RCX:begin
          if(rx_count<=7) begin
            rx_data[rx_count]<=rx;
            rx_count<=rx_count+1;
            state<=RCX;
          end
          else begin
            state<=IDLE;
            done_rx<=0;
          end
        end
      endcase
    end
  end
endmodule
            
