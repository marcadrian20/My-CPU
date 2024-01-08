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
wire [2:0] FLAGS;
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
                  
///////////Control Unit
wire cpu_halted,reset_cycle;
wire [2:0] m_cycle,ADDRM_;
wire [3:0] cpu_state;
wire [4:0] OPCODE;
wire signal_PC;
wire signal_PC_sel;
wire signal_read_I_mem,signal_read_D_mem;
wire signal_write_mem;
wire signal_IR;
wire signal_I_MAR,signal_D_MAR;
wire signal_ALU;
wire [2:0]signal_CPU_REG_sel_IN,signal_CPU_REG_sel_OUT;
wire signal_CPU_REG_W,signal_CPU_REG_R;
ControlUnit CU(.instruction(instr_reg_out),
               .reset_cycle(reset_cycle),
               .reset(reset),
               .CFLAG(carry_flag),
               .ZFLAG(zero_flag),
               .halted(cpu_halted),
               .signal_PC(signal_PC),
               .signal_PC_sel(signal_PC_sel),
               .signal_read_I_mem(signal_read_I_mem),
               .signal_read_D_mem(signal_read_D_mem),
               .signal_write_mem(signal_write_mem),
               .signal_IR(signal_IR),
               .signal_I_MAR(signal_I_MAR),
               .signal_D_MAR(signal_D_MAR),
               .signal_ALU(signal_ALU),
               .signal_CPU_REG_sel_IN(signal_CPU_REG_sel_IN),
               .signal_CPU_REG_sel_OUT(signal_CPU_REG_sel_OUT),
               .signal_CPU_REG_W(signal_CPU_REG_W),
               .signal_CPU_REG_R(signal_CPU_REG_R),
               .cycle(m_cycle),
               .ADDRM(ADDRM_),
               .state(cpu_state),
               .opcode(OPCODE));

//////////INSTRUCTION MAR(memory address register)
register INST_MAR(.st(),
                  .clk(clk),
                  .reset(reset),
                  .in(BUS),
                  .out(i_addr_bus));
register DATA_MAR(.st(),
                  .clk(clk),
                  .reset(reset),
                  .in(BUS),
                  .out(d_addr_bus));
//////////DATA MAR
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
//assign FLAGS={sign_flag,zero_flag,carry_flag};

endmodule