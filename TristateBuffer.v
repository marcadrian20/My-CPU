module TristateBuffer
#(parameter BitCount=16)
(input [BitCount-1:0]in,
input enable,
output [BitCount-1:0]out);

    assign out=(enable)?in:'bz;
endmodule
