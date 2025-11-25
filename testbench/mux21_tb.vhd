-- testbench
library IEEE;
use IEEE.std_logic_1164.all;
use std.env.all;
use IEEE.numeric_std.all;

entity testbench is
end testbench;

architecture test_1 of testbench is

component somador is
	port(
    	i_A  		: in  std_logic_vector(31 downto 0);
        i_B  		: in  std_logic_vector(31 downto 0);
        o_S  		: out std_logic_vector(31 downto 0));
end component;

    	signal A_in		: std_logic_vector(31 downto 0);
        signal B_in  	: std_logic_vector(31 downto 0);
        signal S_out  	: std_logic_vector(31 downto 0);
    
begin
    DUT: somador port map(A_in, B_in, S_out);

    process
    begin        
        A_in <= "00000000000000000000000000000000";
        B_in <= "00000000000000000000000000000000";
    	wait for 1 ns;

        A_in <= "00000000000000000000000000000001";
        B_in <= "00000000000000000000000000000001";
    	wait for 1 ns;
        

        A_in <= "00000000000000000000000000000110";
        B_in <= "00000000000000000000000000000010";
    	wait for 1 ns;
        
        A_in <= "00000000000000000000000000000010";
        B_in <= "11111111111111111111111111111100";
        wait for 1 ns;
        
        finish;	
    end process;
end test_1;