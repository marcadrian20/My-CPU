library verilog;
use verilog.vl_types.all;
entity ControlUnit is
    port(
        instruction     : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        CFLAG           : in     vl_logic;
        ZFLAG           : in     vl_logic;
        halted          : out    vl_logic;
        mux_switch      : out    vl_logic;
        signal_PC       : out    vl_logic;
        signal_PC_sel   : out    vl_logic;
        signal_read_I_mem: out    vl_logic;
        signal_read_D_mem: out    vl_logic;
        signal_write_D_mem: out    vl_logic;
        signal_IR       : out    vl_logic;
        signal_I_MAR    : out    vl_logic;
        signal_D_MAR    : out    vl_logic;
        signal_ALU      : out    vl_logic;
        signal_CPU_REG_sel_IN: out    vl_logic_vector(2 downto 0);
        signal_CPU_REG_sel_OUT: out    vl_logic_vector(2 downto 0);
        signal_CPU_REG_W: out    vl_logic;
        signal_CPU_REG_R: out    vl_logic;
        signal_ALU_tristate: out    vl_logic;
        DMAR_bus        : out    vl_logic_vector(7 downto 0);
        cycle           : out    vl_logic_vector(2 downto 0);
        ADDRM           : out    vl_logic_vector(2 downto 0);
        state           : out    vl_logic_vector(3 downto 0);
        opcode          : out    vl_logic_vector(4 downto 0)
    );
end ControlUnit;
