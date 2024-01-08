library verilog;
use verilog.vl_types.all;
entity TristateBuffer is
    port(
        \in\            : in     vl_logic_vector(15 downto 0);
        enable          : in     vl_logic;
        \out\           : out    vl_logic_vector(15 downto 0)
    );
end TristateBuffer;
