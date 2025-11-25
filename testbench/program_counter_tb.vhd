
library IEEE;
use IEEE.std_logic_1164.all;
use std.env.all;
use IEEE.numeric_std.all;

entity testbench is
end testbench;

architecture test_1 of testbench is

    -- Declaração do componente deve ser idêntica à entity
    component program_counter is
      Port (
          clk      : in  STD_LOGIC;                     
          rst      : in  STD_LOGIC;                     
          pc_write : in  STD_LOGIC;                     
          pc_in    : in  STD_LOGIC_VECTOR (31 downto 0);
          pc_out   : out STD_LOGIC_VECTOR (31 downto 0)
      );
    end component;

    signal I_clk      : STD_LOGIC := '0';
    signal I_rst      : STD_LOGIC := '0';
    signal I_pc_write : STD_LOGIC := '0';
    
    -- CORREÇÃO PRINCIPAL AQUI: Adicionado (31 downto 0)
    signal I_pc_in    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal O_pc_out   : STD_LOGIC_VECTOR(31 downto 0);
    
    constant clk_period : time := 10 ns;

begin
    -- Instanciação (Recomendo Map Explicitado "=>" para evitar erros de ordem, mas deixei posicional como você fez)
    DUT: program_counter port map(I_clk, I_rst, I_pc_write, I_pc_in, O_pc_out);

    -- Processo de Clock
    clk_process: process
    begin
        I_clk <= '0';
        wait for clk_period/2;
        I_clk <= '1';
        wait for clk_period/2;
    end process;
    
    -- Processo de Estímulos
    stim_proc : process
    begin        
        -- 1. Reset
        I_rst <= '1';
        wait for 20 ns;
        I_rst <= '0';
        wait for clk_period;
        
        -- 2. Escrita Normal
        I_pc_write <= '1';
        I_pc_in    <= x"00000004";
        wait for clk_period;
        
        -- 3. Mudança de entrada
        I_pc_in    <= x"00000010";
        wait for clk_period;
        
        -- 4. Teste de Stall (Write = 0)
        I_pc_write <= '0';
        I_pc_in    <= x"00000014";
        wait for clk_period * 2;
        
        -- 5. Volta a escrever
        I_pc_write <= '1';
        wait for clk_period;
        
		-- 6. Reset
        I_rst <= '1';
        wait for 20 ns;
        I_rst <= '0';
        wait for clk_period;
        
        finish;    
    end process;
    
end test_1;