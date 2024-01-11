library verilog;
use verilog.vl_types.all;
entity CPU_Registers_2OUT is
    port(
        clk             : in     vl_logic;
        data_in         : in     vl_logic_vector(15 downto 0);
        sel_in          : in     vl_logic_vector(2 downto 0);
        sel_out         : in     vl_logic_vector(2 downto 0);
        sel_out2        : in     vl_logic_vector(2 downto 0);
        write_enable    : in     vl_logic;
        output_enable   : in     vl_logic;
        data_out        : out    vl_logic_vector(15 downto 0);
        data_out2       : out    vl_logic_vector(15 downto 0)
    );
end CPU_Registers_2OUT;
