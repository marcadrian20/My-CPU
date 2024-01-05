module counter
#(parameter BitCount=16)
(input SEL,clk,reset,DEC,
 input [BitCount-1:0] in,
 output reg [BitCount-1:0] out);
//SEL used for switching the counter to another value
//reset to use on reseting the counter
//DEC -> decrement
  initial out=0;//count starts from 0;
  always @(posedge clk) begin
      if(SEL)
        out<=in;
        else out<=(DEC)?(out-1):(out+1);
  end
  always @(posedge reset) begin
    out<=0;
  end
endmodule