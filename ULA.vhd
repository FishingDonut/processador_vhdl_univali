library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ULA is
    port(
        i_A         : in  std_logic_vector(31 downto 0);
        i_B         : in  std_logic_vector(31 downto 0);
        i_CODE      : in  std_logic_vector(6 downto 0);
        i_F3        : in  std_logic_vector(2 downto 0);
        i_INST30    : in  std_logic;
        i_ALUOP     : in  std_logic_vector(1 downto 0); -- CORRIGIDO PARA 2 BITS
        o_ZERO      : out std_logic;
        o_ULA       : out std_logic_vector(31 downto 0)
    );
end ULA;

architecture a1 of ULA is

    -- CORREÇÃO: Signal declarado na Arquitetura (correto), não variável
    signal w_ULA : std_logic_vector(31 downto 0);

begin

    process(i_A, i_B, i_ALUOP, i_F3, i_INST30)
    begin
        -- 1. Decodifica a Operação
        if (i_ALUOP = "00") then      -- Load/Store -> SOMA
            w_ULA <= i_A + i_B;

        elsif (i_ALUOP = "01") then   -- BEQ -> SUBTRAI (Para comparar)
            w_ULA <= i_A - i_B;

        elsif (i_ALUOP = "10") then   -- Tipo R -> Olha F3 e INST30
            
            if (i_F3 = "000") then      -- ADD ou SUB
                if (i_INST30 = '1') then
                    w_ULA <= i_A - i_B; -- SUB
                else
                    w_ULA <= i_A + i_B; -- ADD
                end if;
                
            elsif (i_F3 = "111") then   -- AND
                w_ULA <= i_A and i_B;
                
            elsif (i_F3 = "110") then   -- OR
                w_ULA <= i_A or i_B;
                
            elsif (i_F3 = "100") then   -- XOR
                w_ULA <= i_A xor i_B;
                
            else
                w_ULA <= i_A + i_B;     -- Default seguro
            end if;
            
        else
            w_ULA <= i_A + i_B;       -- Default geral
        end if;
    end process;

    -- Lógica do Zero
    -- Garante leitura do valor atualizado
    o_ZERO <= '1' when (w_ULA = x"00000000") else '0';

    -- Saída Final
    o_ULA <= w_ULA;
end a1;