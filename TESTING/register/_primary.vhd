library verilog;
use verilog.vl_types.all;
entity \register\ is
    generic(
        BitCount        : integer := 16
    );
    port(
        st              : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        \in\            : in     vl_logic_vector;
        \out\           : out    vl_logic_vector
    );
end \register\;
