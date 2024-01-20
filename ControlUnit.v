`include "InstructionSet.v"
`include "MachineStates.v"
module ControlUnit(input wire [15:0]instruction,
                   input wire clk,reset,CFLAG,ZFLAG,
                   output reg halted,
                   output wire mux_switch,
                   output wire signal_PC,signal_PC_sel,signal_read_I_mem,
                   output wire signal_read_D_mem,signal_write_D_mem,signal_IR,
                   output wire signal_I_MAR,signal_D_MAR,signal_ALU,
                   output wire[2:0]signal_CPU_REG_sel_IN,signal_CPU_REG_sel_OUT,signal_CPU_REG_sel_OUT2,
                   output wire signal_CPU_REG_W,signal_CPU_REG_R,
                   output wire signal_ALU_tristate,
                   output wire [7:0] DMAR_bus,
                   output reg [2:0]cycle,
                   output wire [2:0] ADDRM,
                   output reg [3:0] state,
                   output wire [4:0] opcode);
wire signal_halt;
wire reset_cycle;
/*wire signal_PC;
wire signal_PC_sel;
wire signal_read_I_mem,signal_read_D_mem;
wire signal_write_mem;
wire signal_IR;
wire signal_I_MAR,signal_D_MAR;
wire signal_ALU;
wire [2:0]signal_CPU_REG_sel_IN,signal_CPU_REG_sel_OUT;
wire signal_CPU_REG_W,signal_CPU_REG_R;
*/
wire jump_allow;
//reg [3:0]state;
//////////////////////////        ___________Addressing modes____________________________
localparam Immd_addr=3'b001;   //||Immediate: REG a<=NUMBER for ex: MOV A 5             ||
localparam Reg_addr=3'b010;    //||Register mode: MOV A B                               ||
localparam Dir_addr=3'b011;    //||Direct mode: LDR A 0x011111 (an adress to be precise)||
////////////////////////////////^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
initial begin
  cycle=0;///On cpu start the CPU cant be halted
  halted=0;//Nor have performed any cycle
end
assign opcode=instruction[15:11];
assign ADDRM=(opcode==`MOV)?instruction[10:8]:3'b0;//Addressing modes
always @(posedge clk&~halted) begin///obv important to not be halted ;)))
  case(cycle)///FETCH-DECODE-EXECUTE
    `T1:state<=`S_FETCH_PC;////FETCH STEP
    `T2:state<=`S_FETCH_INST;////still on FETCH
          /////////////NOW entering DECODE
    `T3:state<=(opcode==`HLT)?`S_HALT:(opcode==`LDR||opcode==`MOV)?`S_MEM_R:
        (opcode==`ADD||opcode==`SUB||opcode==`ADC||opcode==`INC||opcode==`DEC||opcode==`CMP||
        opcode==`AND||opcode==`OR||opcode==`XOR||opcode==`NOT)?`S_ALU_FETCH:(opcode==`LDI||opcode==`STR)?`S_MEM_W:
        (opcode==`JMP||opcode==`JNZ||opcode==`JZ||opcode==`JC||opcode==`JNC)?`S_JMP:`S_NEXT;
    ////////////DECODE AND SET PROPER STATES
    `T4:state<=(state==`S_MEM_R)?`S_MEM_W:
              (state==`S_ALU_FETCH)?`S_ALU_OUT:`S_NEXT;
              //(state==`S_FETCH_PC)?`S_JMP:`S_NEXT;
    ///FINAL STATES->finish writing to mem//
    `T5:state<=`S_NEXT;
    endcase
  cycle<=(cycle>5)?0:cycle+1;//The state machine has 4/5 states(retarded states to be precise)
end
///////////////////////SIGNALS///////////////////////// 
///////////////////////////////////////////////////////
  assign jump_allow=(opcode==`JMP|opcode==`JNZ&~ZFLAG|opcode==`JZ&ZFLAG|opcode==`JC&CFLAG|opcode==`JNC&~CFLAG); 
  assign signal_halt=state==`S_HALT;
  assign reset_cycle=state==`S_NEXT;
  //////////////PROGRAM COUNTER SIGNALS                                ______________________________________
  assign signal_PC=state==`S_FETCH_PC|(state==`S_JMP&jump_allow);   //| HI->FETCH PC                        |
  assign signal_PC_sel=(state==`S_JMP)&jump_allow;                  //| LO/HI->SEL MODE(NORMAL|JUMP to addr)|
  assign signal_I_MAR=state==`S_FETCH_PC|(state==`S_JMP&jump_allow);//| HI->Write ADDR to MAR               |
  //////////////INSTRUCTION FETCHING SPECIFIC SIGNALS            
  assign signal_IR=state==`S_FETCH_INST|(state==`S_JMP&jump_allow);//`S_FETCH_INST;
  assign signal_read_I_mem=state==`S_FETCH_INST|(state==`S_JMP&jump_allow);//`S_FETCH_INST
  /////////////ALU
  assign signal_ALU=state==`S_ALU_FETCH;
  assign signal_ALU_tristate=state==`S_ALU_OUT;
  ////////////CPU REGISTER I/O LINE SELECT->IN^HI(MOV&ALU)||OUT^HI(MOV_regaddr&STR)
  assign signal_CPU_REG_sel_IN=(opcode==`ADD|opcode==`SUB|opcode==`ADC|opcode==`INC|opcode==`DEC|opcode==`AND|
        opcode==`OR|opcode==`XOR|opcode==`NOT|opcode==`LDR)?instruction[10:8]:(opcode==`LDI)?3'b0:(opcode==`MOV)?instruction[7:5]:'bz;
  assign signal_CPU_REG_sel_OUT=(opcode==`MOV&&ADDRM==Reg_addr)?instruction[4:2]:(opcode==`STR|opcode==`NOT|opcode==`CMP|
        opcode==`INC|opcode==`DEC)?instruction[10:8]:(state==`S_ALU_FETCH)?instruction[7:5]:3'bz;
  assign signal_CPU_REG_sel_OUT2=(opcode==`ADD|opcode==`SUB|opcode==`ADC|opcode==`AND|
        opcode==`OR|opcode==`XOR)?instruction[4:2]:(opcode==`CMP)?instruction[7:5]:3'bz;
  assign signal_CPU_REG_R=state==`S_ALU_FETCH|((state==`S_MEM_R|state==`S_MEM_W)&(ADDRM==Reg_addr))|opcode==`STR;
  assign signal_CPU_REG_W=state==`S_ALU_OUT|signal_read_D_mem|(state==`S_MEM_W&(opcode==`MOV|opcode==`LDI|opcode==`STR))&~(opcode==`STR);
  assign mux_switch=opcode==`LDI?1'b1:1'b0; 
////////////////MEM I/O    //00001/010/001/000/00 MOV REG B<-A||
  assign signal_read_D_mem=(state==`S_MEM_R)&((opcode==`MOV&&ADDRM==Dir_addr)|opcode==`LDR);
  assign signal_write_D_mem=(state==`S_MEM_W)&(opcode==`STR);
  assign DMAR_bus[7:0]=(opcode==`MOV&&ADDRM==Dir_addr)?{3'b0,instruction[4:0]}:(opcode==`LDR||opcode==`STR)?instruction[7:0]:'bz;
  assign signal_D_MAR=state==`S_MEM_R|(state==`S_MEM_W);//&~opcode==`STR);
  
/////////////////////Reseting on reset_cycle or reset command
always @(posedge reset_cycle or posedge reset) begin//not necessarily good practice
    cycle<=0;
    if(reset)
      halted<=0;
  end

always @(posedge signal_halt) begin
    halted<=1;
    end
endmodule