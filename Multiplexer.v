module Multiplexer
#(parameter BitCount=16)
(input SEL_LINE,
 input [BitCount-1:0]in_a,in_b,
 output wire [BitCount-1:0]out);

assign out=(SEL_LINE)?in_a:in_b;
endmodule
