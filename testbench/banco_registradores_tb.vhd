library IEEE;
use IEEE.std_logic_1164.all;
use std.env.all;
use IEEE.numeric_std.all; -- Usar numeric_std no testbench conforme regras do projeto

entity testbench is
end testbench;

architecture test_1 of testbench is

    -- Declaração do componente banco_registradores
    component banco_registradores is
        Port (	i_CLK  	: in std_logic;
        		i_RSTn	: in std_logic;
                i_WRena	: in std_logic;
                i_WRaddr: in std_logic_vector(4 downto 0);
        		i_RS1 	: in std_logic_vector(4 downto 0);
                i_RS2 	: in std_logic_vector(4 downto 0);
                i_DATA 	: in std_logic_vector(31 downto 0);
                o_RS1 	: out std_logic_vector(31 downto 0);
                o_RS2 	: out std_logic_vector(31 downto 0)
             );
    end component;

    -- Sinais para conectar ao banco de registradores
    signal s_i_CLK  	: std_logic := '0';
    signal s_i_RSTn	: std_logic := '0'; -- Reset ativo-baixo no DUT
    signal s_i_WRena	: std_logic := '0';
    signal s_i_WRaddr: std_logic_vector(4 downto 0) := (others => '0');
    signal s_i_RS1 	: std_logic_vector(4 downto 0) := (others => '0');
    signal s_i_RS2 	: std_logic_vector(4 downto 0) := (others => '0');
    signal s_i_DATA 	: std_logic_vector(31 downto 0) := (others => '0');
    signal s_o_RS1 	: std_logic_vector(31 downto 0);
    signal s_o_RS2 	: std_logic_vector(31 downto 0);
    
    constant clk_period : time := 10 ns;

begin
    -- Instanciação do Device Under Test (DUT)
    DUT: banco_registradores port map(
        i_CLK    => s_i_CLK,
        i_RSTn   => s_i_RSTn,
        i_WRena  => s_i_WRena,
        i_WRaddr => s_i_WRaddr,
        i_RS1    => s_i_RS1,
        i_RS2    => s_i_RS2,
        i_DATA   => s_i_DATA,
        o_RS1    => s_o_RS1,
        o_RS2    => s_o_RS2
    );

    -- Processo Gerador de Clock
    clk_process: process
    begin
        s_i_CLK <= '0';
        wait for clk_period/2;
        s_i_CLK <= '1';
        wait for clk_period/2;
    end process;
    
    -- Processo de Estímulos
    stim_proc : process
    begin        
        -- 1. Reset (ativo-baixo)
        s_i_RSTn <= '0';
        s_i_WRena <= '0';
        s_i_WRaddr <= (others => '0');
        s_i_RS1 <= (others => '0');
        s_i_RS2 <= (others => '0');
        s_i_DATA <= (others => '0');
        wait for clk_period * 2; -- Espera alguns ciclos para o reset
        s_i_RSTn <= '1'; -- Desativa o reset
        wait for clk_period; -- Espera um ciclo apos reset

        -- 2. Escrever no Registrador 1 (r1) e ler de r1 e r0
        s_i_WRena <= '1';
        s_i_WRaddr <= "00001"; -- r1
        s_i_DATA <= x"00000001";
        s_i_RS1 <= "00001"; -- Ler r1
        s_i_RS2 <= "00000"; -- Ler r0
        wait for clk_period;
        assert (s_o_RS1 = x"00000001" and s_o_RS2 = x"00000000") report "Erro na escrita/leitura de r1 ou r0" severity error;

        -- 3. Escrever no Registrador 2 (r2) e ler de r1 e r2
        s_i_WRena <= '1';
        s_i_WRaddr <= "00010"; -- r2
        s_i_DATA <= x"00000002";
        s_i_RS1 <= "00001"; -- Ler r1
        s_i_RS2 <= "00010"; -- Ler r2
        wait for clk_period;
        assert (s_o_RS1 = x"00000001" and s_o_RS2 = x"00000002") report "Erro na escrita/leitura de r2" severity error;
        
        -- 4. Tentar escrever no Registrador 0 (r0) e ler de r0 e r2
        s_i_WRena <= '1'; -- Escrita habilitada
        s_i_WRaddr <= "00000"; -- r0
        s_i_DATA <= x"DEADBEEF"; -- Valor para tentar escrever
        s_i_RS1 <= "00000"; -- Ler r0
        s_i_RS2 <= "00010"; -- Ler r2
        wait for clk_period;
        -- r0 deve permanecer 0, r2 deve manter seu valor
        assert (s_o_RS1 = x"00000000" and s_o_RS2 = x"00000002") report "Erro: r0 foi escrito ou r2 alterado" severity error;

        -- 5. Escrever no Registrador 31 (r31) e ler de r31 e r0
        s_i_WRena <= '1';
        s_i_WRaddr <= "11111"; -- r31
        s_i_DATA <= x"FFFFFFFF";
        s_i_RS1 <= "11111"; -- Ler r31
        s_i_RS2 <= "00000"; -- Ler r0
        wait for clk_period;
        assert (s_o_RS1 = x"FFFFFFFF" and s_o_RS2 = x"00000000") report "Erro na escrita/leitura de r31 ou r0" severity error;

        -- 6. Desabilitar escrita e ler de r1 e r2
        s_i_WRena <= '0'; -- Escrita desabilitada
        s_i_RS1 <= "00001"; -- Ler r1
        s_i_RS2 <= "00010"; -- Ler r2
        wait for clk_period;
        assert (s_o_RS1 = x"00000001" and s_o_RS2 = x"00000002") report "Erro na leitura apos desabilitar escrita" severity error;
        
        -- 7. Ler de registradores nao inicializados (exceto r0)
        s_i_RS1 <= "00011"; -- Ler r3 (nao escrito)
        s_i_RS2 <= "00100"; -- Ler r4 (nao escrito)
        wait for clk_period;
        assert (s_o_RS1 = x"00000000" and s_o_RS2 = x"00000000") report "Erro na leitura de registradores nao inicializados" severity error;

        report "Simulacao do banco de registradores concluida com sucesso!" severity note;
        finish;	
    end process;
    
end test_1;
