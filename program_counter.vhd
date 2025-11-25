library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity program_counter is
    Port (
        clk      : in  STD_LOGIC;                     
        rst      : in  STD_LOGIC;                     
        pc_write : in  STD_LOGIC;                     
        pc_in    : in  STD_LOGIC_VECTOR (31 downto 0);
        pc_out   : out STD_LOGIC_VECTOR (31 downto 0)
    );
end program_counter;

architecture Behavioral of program_counter is
    signal pc_current : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin

    process(clk, rst)
    begin
        if rst = '1' then
            pc_current <= (others => '0'); 
            
        elsif rising_edge(clk) then
            if pc_write = '1' then
                pc_current <= pc_in;
            end if;
        end if;
    end process;

    pc_out <= pc_current;

end Behavioral;