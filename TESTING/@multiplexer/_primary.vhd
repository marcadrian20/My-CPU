library verilog;
use verilog.vl_types.all;
entity Multiplexer is
    generic(
        BitCount        : integer := 16
    );
    port(
        SEL_LINE        : in     vl_logic;
        in_a            : in     vl_logic_vector;
        in_b            : in     vl_logic_vector;
        \out\           : out    vl_logic_vector
    );
end Multiplexer;
