library verilog;
use verilog.vl_types.all;
entity ControlUnit is
    port(
        instruction     : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        reset_cycle     : in     vl_logic;
        state           : out    vl_logic;
        cycle           : out    vl_logic_vector(3 downto 0);
        ADDRM           : out    vl_logic_vector(2 downto 0);
        opcode          : out    vl_logic_vector(4 downto 0)
    );
end ControlUnit;
