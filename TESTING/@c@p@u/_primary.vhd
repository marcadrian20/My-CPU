library verilog;
use verilog.vl_types.all;
entity CPU is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        I_MEM_W         : out    vl_logic;
        D_MEM_W         : out    vl_logic;
        D_MEM_OE        : out    vl_logic;
        I_MEM_OE        : out    vl_logic;
        d_addr_bus      : out    vl_logic_vector(7 downto 0);
        i_addr_bus      : out    vl_logic_vector(7 downto 0);
        DATA_BUS        : inout  vl_logic_vector(15 downto 0);
        \BUS\           : inout  vl_logic_vector(15 downto 0)
    );
end CPU;
