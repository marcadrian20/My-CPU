module CPU_Registers(input wire clk,
                     input [15:0]data_in,
                     input wire [2:0]sel_in,
                     input wire [2:0]sel_out,
                     input wire write_enable,output_enable,
                     output wire [15:0]data_out,
                     inout wire [15:0]regA,regB);
reg[15:0] registers[0:7];
//////only 8 cpu registers ,each 16bit long
  always @(posedge clk) begin
      if(write_enable)
        registers[sel_in]=data_in;
  end
  assign data_out=(output_enable)?registers[sel_out]:'bz;
  wire [7:0] regC,regD,regE,regF,regG,regH;
  assign regA=registers[0];
  assign regB=registers[1];
  assign regC=registers[2];
  assign regD=registers[3];
  assign regE=registers[4];
  assign regF=registers[5];
  assign regG=registers[6];
  assign regH=registers[7];
endmodule