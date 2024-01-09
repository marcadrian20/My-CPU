module TristateBuffer
#(parameter BitCount=16)
(input [BitCount-1:0]in,
input enable,
output [15:0]out);

    assign out=(enable)?in:'bz;
endmodule
