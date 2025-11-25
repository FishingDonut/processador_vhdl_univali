-- clk_tb.vhd
library IEEE;
use IEEE.std_logic_1164.all;

entity clk_tb is
port(
    clk, reset: in std_logic;
    s : out std_logic);
end clk_tb;

architecture rlt of clk_tb is
begin
	process (clk, reset) is
	begin
    	s <= clk and reset;
	end process;
end rlt;
-- end clk_tb.vhd