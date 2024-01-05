module register 
#(parameter BitCount=16)
  (input wire st,clk,
   input wire[BitCount-1:0] in,
   output reg [BitCount-1:0] out);
///st->write enable,clk-clock
//st=0 -> readonly mode
 always @(posedge clk) begin
   if(st)
     out<=in;
 end
 endmodule