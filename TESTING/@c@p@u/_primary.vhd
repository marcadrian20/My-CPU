library verilog;
use verilog.vl_types.all;
entity CPU is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        addr_bus        : out    vl_logic_vector(7 downto 0);
        DATA_BUS        : inout  vl_logic_vector(15 downto 0);
        \BUS\           : inout  vl_logic_vector(15 downto 0)
    );
end CPU;