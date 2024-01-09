module machine(input wire clk,
               input wire reset);

wire [7:0] d_addr_bus,i_addr_bus;
wire [15:0]DATA_BUS,BUS;
wire signal_read_I_mem,signal_read_D_mem,signal_write_D_mem;
wire mem_clk_;
CPU CPU_(.clk(clk),
         .reset(reset),
         .d_addr_bus(d_addr_bus),
         .i_addr_bus(i_addr_bus),
         .signal_read_I_mem(signal_read_I_mem),
         .signal_read_D_mem(signal_read_D_mem),
         .signal_write_D_mem(signal_write_D_mem),
         .mem_clk(mem_clk_),
         .DATA_BUS(DATA_BUS),
         .BUS(BUS));
//wire I_MEM_W,I_MEM_OE;
RAM I_MEM(.st(1'b0),
          .oe(signal_read_I_mem),
          .clk(mem_clk_),
          .reset(reset),
          .addr(i_addr_bus),
          .data(BUS));
RAM D_MEM(.st(signal_write_D_mem),
          .clk(mem_clk_),
          .oe(signal_read_D_mem),
          .reset(reset),
          .addr(d_addr_bus),
          .data(DATA_BUS));
endmodule
