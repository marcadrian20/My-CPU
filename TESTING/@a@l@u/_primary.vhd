library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        enable          : in     vl_logic;
        clk             : in     vl_logic;
        OPCODE          : in     vl_logic_vector(4 downto 0);
        in_a            : in     vl_logic_vector(15 downto 0);
        in_b            : in     vl_logic_vector(15 downto 0);
        \out\           : out    vl_logic_vector(15 downto 0);
        CFlag           : out    vl_logic;
        SignFlag        : out    vl_logic;
        ZeroFlag        : out    vl_logic
    );
end ALU;
