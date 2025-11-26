library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.all;

entity testbench is
-- Testbench não tem portas
end testbench;

architecture Behavioral of testbench is

    -- 1. Componente (Cópia exata da entity memoria_dados)
    component memoria_dados is
      Port (
        i_CLK       : in std_logic;
        i_MEM_WRITE : in std_logic;
        i_MEM_READ  : in std_logic;
        i_ADDR      : in std_logic_vector(31 downto 0);
        i_DATA      : in std_logic_vector(31 downto 0);
        o_DATA      : out std_logic_vector(31 downto 0)
      );
    end component;

    -- 2. Sinais internos
    signal w_CLK       : std_logic := '0';
    signal w_MEM_WRITE : std_logic := '0';
    signal w_MEM_READ  : std_logic := '0';
    signal w_ADDR      : std_logic_vector(31 downto 0) := (others => '0');
    signal w_DATA_IN   : std_logic_vector(31 downto 0) := (others => '0');
    signal w_DATA_OUT  : std_logic_vector(31 downto 0);

    -- Constante de Clock
    constant k_CLK_PERIOD : time := 10 ns;

begin

    -- 3. Instanciação (DUT)
    u_MEM: memoria_dados port map (
        i_CLK       => w_CLK,
        i_MEM_WRITE => w_MEM_WRITE,
        i_MEM_READ  => w_MEM_READ,
        i_ADDR      => w_ADDR,
        i_DATA      => w_DATA_IN,
        o_DATA      => w_DATA_OUT
    );

    -- Processo de Clock
    p_CLK: process
    begin
        w_CLK <= '0';
        wait for k_CLK_PERIOD/2;
        w_CLK <= '1';
        wait for k_CLK_PERIOD/2;
    end process;

    -- 4. Processo de Estímulos
    stim_proc: process
    begin
        wait for 100 ns; -- Tempo de reset global

        -- =========================================================
        -- TESTE 1: ESCRITA (Store Word - SW)
        -- =========================================================
        -- Vamos escrever o valor 0xAABBCCDD no endereço 0
        w_ADDR      <= x"00000000";
        w_DATA_IN   <= x"AABBCCDD"; 
        w_MEM_WRITE <= '1'; -- Habilita escrita
        w_MEM_READ  <= '0';
        wait for k_CLK_PERIOD; -- Espera o clock gravar
        
        -- Desabilita escrita para não corromper
        w_MEM_WRITE <= '0';
        wait for k_CLK_PERIOD;

        -- =========================================================
        -- TESTE 2: LEITURA (Load Word - LW)
        -- =========================================================
        -- Vamos ler do mesmo endereço 0
        w_ADDR      <= x"00000000";
        w_MEM_READ  <= '1'; -- Habilita leitura
        wait for k_CLK_PERIOD;
        -- ESPERADO: w_DATA_OUT = AABBCCDD

        -- =========================================================
        -- TESTE 3: ESCRITA EM OUTRO ENDEREÇO
        -- =========================================================
        -- Escrever 0x11223344 no endereço 4 (próxima palavra)
        w_ADDR      <= x"00000004";
        w_DATA_IN   <= x"11223344";
        w_MEM_WRITE <= '1';
        w_MEM_READ  <= '0';
        wait for k_CLK_PERIOD;
        
        w_MEM_WRITE <= '0';
        wait for k_CLK_PERIOD;

        -- =========================================================
        -- TESTE 4: LEITURA CRUZADA
        -- =========================================================
        -- Ler endereço 0 de novo para garantir que não sobrescreveu
        w_ADDR      <= x"00000000";
        w_MEM_READ  <= '1';
        wait for k_CLK_PERIOD;
        -- ESPERADO: w_DATA_OUT = AABBCCDD
        
        -- Ler endereço 4
        w_ADDR      <= x"00000004";
        wait for k_CLK_PERIOD;
        -- ESPERADO: w_DATA_OUT = 11223344

        -- =========================================================
        -- TESTE 5: LEITURA DESABILITADA
        -- =========================================================
        w_MEM_READ <= '0';
        wait for k_CLK_PERIOD;
        -- ESPERADO: w_DATA_OUT = 00000000 (Pois seu código zera a saída no 'others')

        report "Simulacao Memoria de dados [DONE]!" severity note;
        finish;	    end process;

end Behavioral;