library verilog;
use verilog.vl_types.all;
entity RAM is
    generic(
        BitCount        : integer := 16
    );
    port(
        st              : in     vl_logic;
        clk             : in     vl_logic;
        oe              : in     vl_logic;
        addr            : in     vl_logic_vector;
        data            : inout  vl_logic_vector
    );
end RAM;
