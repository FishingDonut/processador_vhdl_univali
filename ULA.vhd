--ULA completo
--by Daniel Uesler de Brito.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity ULA is

	port(
    	i_A  		: in  std_logic_vector(31 downto 0); --std_logic_vector é similar a bit_vector
        i_B  		: in  std_logic_vector(31 downto 0);
        i_CODE      : IN  std_logic_vector(6 DOWNTO 0); -- 7 bits operacao
        i_F3 		: in  std_logic_vector(2 downto 0);
        i_INST30	: in std_logic;
        i_ALUOP     : in  std_logic_vector(2 downto 0); -- 3 bits operacao
        o_ZERO		: in std_logic;
        o_ULA  		: out std_logic_vector(31 downto 0)
    );

end ULA;


architecture a1 of ULA is

begin
	process(i_A, i_B,i_ALUOP)
    begin
    	if (i_ALUOP = "000") then
            o_ULA <= i_A + i_B; -- ADD
        elsif (i_ALUOP = "001") then
            o_ULA <= i_A - i_B; -- SUB
        elsif (i_ALUOP = "010") then
            o_ULA <= i_A and i_B; -- AND
        elsif (i_ALUOP = "011") then
            o_ULA <= i_A or i_B; -- OR
        elsif (i_ALUOP = "100") then
            o_ULA <= i_A xor i_B; -- XOR
        else
            o_ULA <= i_A + i_B; -- padrao ADD
        end if;
    end process;
end a1;