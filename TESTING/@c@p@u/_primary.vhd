library verilog;
use verilog.vl_types.all;
entity CPU is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        d_addr_bus      : out    vl_logic_vector(7 downto 0);
        i_addr_bus      : out    vl_logic_vector(7 downto 0);
        signal_read_I_mem: out    vl_logic;
        signal_read_D_mem: out    vl_logic;
        signal_write_D_mem: out    vl_logic;
        mem_clk         : out    vl_logic;
        DATA_BUS        : inout  vl_logic_vector(15 downto 0);
        \BUS\           : inout  vl_logic_vector(15 downto 0)
    );
end CPU;
