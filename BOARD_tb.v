module BOARD_tb;
reg reset=0;

reg clk;
initial begin clk = 1'b0;
forever #50  clk = !clk;
end
machine machine_test(.clk(clk),
                     .reset(reset));
always @ (posedge machine_test.CPU_.cpu_halted) begin
    $display("============================================");
    $display("CPU halted normally.");
    $display(
      "REGISTERS: A: %h, B: %h, C: %h, D: %h, E: %h, F: %h, G: %h, Temp: %h",
      machine_test.CPU_.CPU_regs.regA,
      machine_test.CPU_.CPU_regs.regB,
      machine_test.CPU_.CPU_regs.regC,
      machine_test.CPU_.CPU_regs.regD,
      machine_test.CPU_.CPU_regs.regE,
      machine_test.CPU_.CPU_regs.regF,
      machine_test.CPU_.CPU_regs.regH,
      machine_test.CPU_.CPU_regs.regG
    );
    $stop;
  end
endmodule