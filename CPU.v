module CPU(input wire clk,reset,
           output wire [7:0] addr_bus,
           inout wire [15:0]DATA_BUS,BUS);
/*reg [7:0]FLAGS;
initial 
  FLAGS=8'b0;
// 7 6 5 4  3 2 1 0
// S Z C AC P - - -
//S-sign flag || Z-Zero flag|| C-carry|| AC-Aux carry|| P-Parity flag
*/
wire zero_flag;
wire sign_flag;
wire carry_flag;
////////////Program counter
wire [15:0] pc_out;//output wire from the instr pointer  
counter PC(.SEL(),
          .clk(clk),
          .reset(reset),
          .DEC(1'b0),
          .in(BUS),
          .out(pc_out));
//////////////Instruction reg
wire [15:0] instr_reg_out;
register INST_REG(.st(),
                  .clk(clk),
                  .reset(reset),
                  .in(BUS),
                  .out(instr_reg_out));
////////////////ALU
wire [15:0] ALU_out;
ALU ALU_(.enable(),
         .clk(clk),
         .OPCODE(),
         .in_a(),
         .in_b(),
         .out(ALU_out),
         .SignFlag(sign_flag),
         .CFlag(carry_flag),
         .ZeroFlag(zero_flag));
endmodule