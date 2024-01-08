library verilog;
use verilog.vl_types.all;
entity clock is
    port(
        enable          : in     vl_logic;
        clk             : out    vl_logic
    );
end clock;
