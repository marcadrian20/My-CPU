module BOARD_tb;
wire clk;
reg enable_clk=0;
reg reset=0;
clock CLOCK(.enable(enable_clk),
            .clk(clk));
/*reg clk;
initial begin clk = 1'b0;
forever #50  clk = !clk;
end
*/
initial begin 
  reset=1;
  #10 reset=0;
  #10;
  $readmemh("INSTRUCTION_RAM.txt",machine_test.I_MEM.Memory);
  $readmemh("DATA_RAM.txt",machine_test.D_MEM.Memory);
  #10 enable_clk=1;
  //$stop;//#100 enable_clk=0;
  //#200 $stop;
end
machine machine_test(.clk(clk),
                     .reset(reset));
always @ (posedge machine_test.CPU_.cpu_halted) begin
    $display("============================================");
    $display("CPU halted normally.");
    $display(
      "REGISTERS: A: %d, B: %d, C: %d, D: %d, E: %d, F: %d, G: %d, H: %d",
      machine_test.CPU_.CPU_regs.regA,
      machine_test.CPU_.CPU_regs.regB,
      machine_test.CPU_.CPU_regs.regC,
      machine_test.CPU_.CPU_regs.regD,
      machine_test.CPU_.CPU_regs.regE,
      machine_test.CPU_.CPU_regs.regF,
      machine_test.CPU_.CPU_regs.regG,
      machine_test.CPU_.CPU_regs.regH
    );
    //$finish;
    $stop;
  end
endmodule