library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity write_back is
    Port (	
            i_ULA  	: in std_logic_vector(31 downto 0);
            i_MEMDATA  	: in std_logic_vector(31 downto 0);
            i_MEM2REG   : in std_logic;
            o_write_back_out    : out std_logic_vector(31 downto 0)
         );
end write_back;

architecture arch_write_back of write_back is
begin

    process (i_ULA, i_MEMDATA, i_MEM2REG)
    begin
        if i_MEM2REG = '0' then
            o_write_back_out <= i_ULA;
        else
            o_write_back_out <= i_MEMDATA;
        end if;
    end process;

end architecture arch_write_back;