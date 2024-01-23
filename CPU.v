module CPU(input wire clk,reset,
           output wire [7:0] d_addr_bus,i_addr_bus,
           output wire signal_read_I_mem,signal_read_D_mem,
           output wire signal_write_D_mem,
           output reg mem_clk,
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
//wire [2:0] FLAGS;
wire cpu_halted;
wire [2:0] m_cycle,ADDRM_;
wire [3:0] cpu_state;
wire [4:0] OPCODE;
wire signal_PC;
wire signal_PC_sel;
//wire signal_read_I_mem,signal_read_D_mem;
//wire signal_write_D_mem;
wire signal_IR;
wire signal_I_MAR,signal_D_MAR;
wire signal_ALU;
wire [2:0]signal_CPU_REG_sel_IN,signal_CPU_REG_sel_OUT,signal_CPU_REG_sel_OUT2;
wire signal_CPU_REG_W,signal_CPU_REG_R;
wire [7:0] pc_out;//output wire from the instr pointer  
wire [7:0] DMAR_bus;
wire signal_ALU_tristate,mux_switch,signal_SP_tristate;
wire signal_SP,signal_SP_dec;
wire signal_mux_switch_PC,signal_PC_tristate;
/////////////////////////////////////
 reg cycle_clk = 0;
  reg internal_clk = 0;
  reg [2:0] cnt = 'b100;
  reg halted = 0;
  always @ (posedge clk & ~halted) begin
    {cycle_clk, mem_clk, internal_clk} <= cnt;

    case (cnt)
      'b100 : cnt = 'b010;
      'b010 : cnt = 'b001;
      'b001 : cnt = 'b100;
    endcase
  end
//////////////Instruction reg
wire [15:0] instr_reg_out;
register INST_REG(.st(signal_IR),
                  .clk(internal_clk),
                  .reset(reset),
                  .in(BUS),
                  .out(instr_reg_out));
                  
///////////Control Unit
ControlUnit CU(.clk(cycle_clk),
               .instruction(instr_reg_out),
               .reset(reset),
               .CFLAG(carry_flag),
               .ZFLAG(zero_flag),
               .halted(cpu_halted),
               .mux_switch(mux_switch),
               .signal_mux_switch_PC(signal_mux_switch_PC),
               .signal_PC_tristate(signal_PC_tristate),
               .signal_SP(signal_SP),
               .signal_SP_dec(signal_SP_dec),
               .signal_SP_tristate(signal_SP_tristate),
               .signal_PC(signal_PC),
               .signal_PC_sel(signal_PC_sel),
               .signal_read_I_mem(signal_read_I_mem),
               .signal_read_D_mem(signal_read_D_mem),
               .signal_write_D_mem(signal_write_D_mem),
               .signal_IR(signal_IR),
               .signal_I_MAR(signal_I_MAR),
               .signal_D_MAR(signal_D_MAR),
               .signal_ALU(signal_ALU),
               .signal_CPU_REG_sel_IN(signal_CPU_REG_sel_IN),
               .signal_CPU_REG_sel_OUT(signal_CPU_REG_sel_OUT),
               .signal_CPU_REG_sel_OUT2(signal_CPU_REG_sel_OUT2),
               .signal_CPU_REG_W(signal_CPU_REG_W),
               .signal_CPU_REG_R(signal_CPU_REG_R),
               .signal_ALU_tristate(signal_ALU_tristate),
               .DMAR_bus(DMAR_bus),
               .cycle(m_cycle),
               .ADDRM(ADDRM_),
               .state(cpu_state),
               .opcode(OPCODE));

////////////PC MUX/////////
wire [7:0] pc_in; 
Multiplexer #(.BitCount(8)) pc_mux(.SEL_LINE(signal_mux_switch_PC),
                                   .in_a(BUS[7:0]),
                                   .in_b(DATA_BUS[7:0]),
                                   .out(pc_in));
////////////Program counter
counter PC(.SEL(signal_PC_sel),
          .clk(internal_clk&signal_PC),
          .reset(reset),
          .DEC(1'b0),
          .in(pc_in),///on jmp state i take the addr dir from inst.!!Test with inst_reg_out
          .out(pc_out));
//PC OUT TRIstate
 TristateBuffer #(.BitCount(16)) PC_tristate(.in({8'b0,pc_out}),
                                .enable(signal_PC_tristate),
                                .out(DATA_BUS));
/////////////////////Stack pointer
wire [7:0] sp_out;
counter SP(.SEL(reset),
           .clk(internal_clk&signal_SP|reset),
           .reset(1'b0),
           .DEC(signal_SP_dec),
           .in(8'hFF),
           .out(sp_out));
 TristateBuffer #(.BitCount(8)) SP_tristate(.in(sp_out),
                                .enable(signal_SP_tristate),
                                .out(DMAR_bus));
//////////INSTRUCTION MAR(memory address register)
register #(.BitCount(8)) INST_MAR(.st(signal_I_MAR),
                  .clk(internal_clk),
                  .reset(reset),
                  .in(pc_out),
                  .out(i_addr_bus));
register #(.BitCount(8)) DATA_MAR(.st(signal_D_MAR),
                  .clk(clk),
                  .reset(reset),
                  .in(DMAR_bus),
                  .out(d_addr_bus));
//////////DATA MAR^^^^
//////////////////MULTIPLEXER DATA_BUSxBUS
wire [15:0]mux_out;
Multiplexer mux(.SEL_LINE(mux_switch),
                        .in_a({5'b0,instr_reg_out[10:0]}),
                        .in_b(DATA_BUS),
                        .out(mux_out));
//////////CPU registers
//wire [15:0] regA_out;
wire [15:0] ALU_IN_BUS,REGS_OUT;
CPU_Registers_2OUT CPU_regs(.clk(internal_clk),
              .data_in(mux_out),
              .sel_in(signal_CPU_REG_sel_IN),
              .sel_out(signal_CPU_REG_sel_OUT),
              .sel_out2(signal_CPU_REG_sel_OUT2),
              .write_enable(signal_CPU_REG_W),
              .output_enable(signal_CPU_REG_R),
              .data_out(REGS_OUT),
              .data_out2(ALU_IN_BUS)
              );
              
TristateBuffer #(.BitCount(16)) REGS_tristate(.in(REGS_OUT),
                                .enable(signal_CPU_REG_R),
                                .out(DATA_BUS));
////////////////ACC
//wire [15:0] TMP_wire;
/*register #(.BitCount(16)) ACC(.st(signal_ALU),
        	 	 	                 .clk(clk),
        	 	 	                 .reset(reset),
        	 	 	                 .in(DATA_BUS),
        	 	 	                 .out(ACC_wire));
register #(.BitCount(16)) TMP(.st(signal_ALU_tristate),
                              .clk(clk),
                              .reset(reset),
                              .in(DATA_BUS),
                              .out(TMP_wire));	 	 	                 
                              */
////////////////ALU
wire [15:0] ALU_out;
ALU ALU_(.enable(signal_ALU),
         .clk(cycle_clk),
         .OPCODE(OPCODE),
         .in_a(DATA_BUS),
         .in_b(ALU_IN_BUS),
         .out(ALU_out),
         .SignFlag(sign_flag),
         .CFlag(carry_flag),
         .ZeroFlag(zero_flag));
//assign FLAGS={sign_flag,zero_flag,carry_flag};
TristateBuffer ALU_tristate(.in(ALU_out),
                           .enable(signal_ALU_tristate),
                           .out(DATA_BUS));//(DATA_BUS));
endmodule