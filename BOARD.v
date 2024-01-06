module machine(input wire clk,
               input wire reset);

wire [15:0] d_addr_bus,i_addr_bus,DATA_BUS,BUS;
CPU CPU_(.clk(clk),
         .reset(reset),
         .d_addr_bus(d_addr_bus),
         .i_addr_bus(i_addr_bus),
         .DATA_BUS(DATA_BUS),
         .BUS(BUS));
wire I_MEM_W,I_MEM_OE;
RAM I_MEM(.st(I_MEM_W),
          .clk(clk),
          .oe(I_MEM_OE),
          .reset(reset),
          .addr(i_addr_bus),
          .data(BUS));
wire D_MEM_W,D_MEM_OE;
RAM D_MEM(.st(D_MEM_W),
          .clk(clk),
          .oe(D_MEM_OE),
          .reset(reset),
          .addr(d_addr_bus),
          .data(DATA_BUS));
endmodule
