module TristateBuffer(input [15:0]in,
                      input enable,
                      output [15:0]out);

    assign out=(enable)?in:'bz;
endmodule
