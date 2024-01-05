`include "InstructionSet.v"
`include "MachineStates.v"
module ControlUnit(input wire [15:0]instruction,
                   input wire clk,reset_cycle,reset,
                   output reg halted,
                   output reg [3:0]cycle,
                   output reg [2:0] ADDRM,
                   output reg [4:0] opcode);
wire c_halt;
reg [3:0]state;
//////////////////////////        ___________Addressing modes____________________________
localparam Immd_addr=3'b001;   //||Immediate: REG a<=NUMBER for ex: MOV A 5             ||
localparam Reg_addr=3'b010;    //||Register mode: MOV A B                               ||
localparam Dir_addr=3'b011;    //||Direct mode: LDR A 0x011111 (an adress to be precise)||
////////////////////////////////^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
initial begin
  cycle=0;///On cpu start the CPU cant be halted
  halted=0;//Nor have performed any cycle
end

always @(posedge clk&~halted) begin///obv important to not be halted ;)))
  opcode=instruction[15:11];///I dont like assigning it either each clock
  ADDRM=(opcode==`MOV)?instruction[10:8]:3'b0;//Addressing modes
  case(cycle)///FETCH-DECODE-EXECUTE
    3'b000:state=`S_FETCH_INST;////FETCH STEP
    3'b001:state=(opcode==`HLT)?`S_HALT:(opcode==`LDI||opcode==`LDR||opcode==`MOV)?`S_FETCH_DATA:
    (opcode==`ADD||opcode==`SUB||opcode==`ADC||opcode==`INC||opcode==`DEC||opcode==`AND||
    opcode==`OR||opcode==`XOR||opcode==`NOT)?`S_ALU_FETCH:`S_NEXT;
    endcase
  cycle=(cycle>6)?0:cycle+1;//The state machine has 7/8 states(retarded states to be precise)
end
/////////////////////Reseting on reset_cycle or reset command
always @(posedge reset_cycle or posedge reset) begin//not necessarily good practice
    cycle=0;
    halted=0;
  end

always @(posedge c_halt) begin
    halted=1;
    end
endmodule