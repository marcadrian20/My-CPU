module RAM
#(parameter BitCount=16)
  (input wire st,clk,oe,
   input wire[BitCount-1:0] addr,
   inout wire[BitCount-1:0] data);
//oe->output enable
//st->store
//addr is the adress we are trying to access
//data is bidirectional ->inout makes sense
//for ease and readability im using regs
    reg [16:0] Buffer;
    reg [16:0] Memory[0:255];
//basically a 2d arr of adresses cus im lazy
    always @(posedge clk) begin
      if(st)
        Memory[addr]<= data;
      else Buffer<=Memory[addr];
    end 
//basically i use a buffer to prepare for the next store operation
    assign data=(oe&&~st)?Buffer:('bz);
//ideally we read when we dont write 
//and write when we dont read
//if those conditions are not met the output goes high imp
endmodule