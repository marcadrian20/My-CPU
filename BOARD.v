module machine(input wire clk,
               input wire reset);

wire [15:0] d_addr_bus,i_addr_bus,DATA_BUS,BUS;
CPU CPU_(.clk(clk),
         .reset(reset),
         .d_addr_bus(d_addr_bus),
         .i_addr_bus(i_addr_bus),
         .DATA_BUS(DATA_BUS),
         .BUS(BUS));
RAM I_MEM(.st(),
          .clk(clk),
          .oe(),
          .reset(reset),
          .addr(i_addr_bus),
          .data(BUS));
RAM D_MEM(.st(),
          .clk(clk),
          .oe(),
          .reset(reset),
          .addr(d_addr_bus),
          .data(DATA_BUS));
endmodule
