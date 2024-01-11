`include "InstructionSet.v"
module ALU(input wire enable,clk,
           input wire [4:0]OPCODE,
           input wire [15:0]in_a,in_b,
           output wire [15:0]out,
           output reg SignFlag,CFlag,
           output wire ZeroFlag);
  reg [15:0] Buffer;
  initial begin
    SignFlag=1'b0;
    CFlag=1'b0;
    //ZeroFlag=1'b0;
  end
  always @(posedge clk) begin
    if(enable) begin
    case(OPCODE)
      `ADD:{CFlag,Buffer}<=in_a+in_b;
      `ADC:{CFlag,Buffer}<=in_a+in_b+CFlag;
      `SUB:{CFlag,Buffer}<=in_a-in_b;
      `INC:{CFlag,Buffer}<=in_a+1;
      `DEC:{CFlag,Buffer}<=in_a-1;
      `AND:Buffer<=in_a&in_b;
      `OR:Buffer<=in_a|in_b;
      `XOR:Buffer<=in_a^in_b;
      `NOT:Buffer<=~in_a;
      endcase
    
    //ZeroFlag=(Buffer==0)?1'b1:1'b0;
    SignFlag=(Buffer<0)?1'b1:1'b0;
    end
  end
  assign ZeroFlag = ~(|Buffer);
    assign out=Buffer;
endmodule