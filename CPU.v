module CPU(input wire clk,reset,
           output wire I_MEM_W,D_MEM_W,D_MEM_OE,I_MEM_OE,
           output wire [7:0] d_addr_bus,i_addr_bus,
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
//////////CPU registers
wire [15:0] regA_out;
wire [2:0] CPU_REG_SEL_IN,CPU_REG_SEL_OUT;
CPU_Registers CPU_regs(.clk(clk),
              .data_in(DATA_BUS),
              .sel_in(CPU_REG_SEL_IN),
              .sel_out(CPU_REG_SEL_OUT),
              .write_enable(),
              .output_enable(),
              .data_out(DATA_BUS),
              .regA(regA_out));

///////////Control Unit
wire cpu_halted,reset_cycle;
wire [2:0] m_cycle,ADDRM_;
wire [3:0] cpu_state;
wire [4:0] OPCODE;
ControlUnit CU(.instruction(instr_reg_out),
               .reset_cycle(reset_cycle),
               .reset(reset),
               .halted(cpu_halted),
               .cycle(m_cycle),
               .ADDRM(ADDRM_),
               .state(cpu_state),
               .opcode(OPCODE));

////////////////ALU
wire [15:0] ALU_out;
ALU ALU_(.enable(),
         .clk(clk),
         .OPCODE(OPCODE),
         .in_a(regA_out),
         .in_b(),
         .out(ALU_out),
         .SignFlag(sign_flag),
         .CFlag(carry_flag),
         .ZeroFlag(zero_flag));
         

endmodule