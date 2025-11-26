library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
-- Testbench não tem portas
end testbench;

architecture Behavioral of testbench is
    component ULA is
        port(
            i_A         : in  std_logic_vector(31 downto 0);
            i_B         : in  std_logic_vector(31 downto 0);
            i_CODE      : in  std_logic_vector(6 downto 0);
            i_F3        : in  std_logic_vector(2 downto 0);
            i_INST30    : in  std_logic;
            i_ALUOP     : in  std_logic_vector(1 downto 0);
            o_ZERO      : out std_logic;
            o_ULA       : out std_logic_vector(31 downto 0)
        );
    end component;

    signal w_A      : std_logic_vector(31 downto 0) := (others => '0');
    signal w_B      : std_logic_vector(31 downto 0) := (others => '0');
    signal w_CODE   : std_logic_vector(6 downto 0)  := (others => '0');
    signal w_F3     : std_logic_vector(2 downto 0)  := (others => '0');
    signal w_INST30 : std_logic := '0';
    signal w_ALUOP  : std_logic_vector(1 downto 0)  := (others => '0');
    
    signal w_ZERO   : std_logic;
    signal w_ULA    : std_logic_vector(31 downto 0);

begin
    DUT: ULA port map (
        i_A      => w_A,
        i_B      => w_B,
        i_CODE   => w_CODE,
        i_F3     => w_F3,
        i_INST30 => w_INST30,
        i_ALUOP  => w_ALUOP,
        o_ZERO   => w_ZERO,
        o_ULA    => w_ULA
    );
     
    stim_proc: process
    begin
        -- Espera inicial
        wait for 100 ns;

        -- ==========================================
        -- CASO 1: LOAD/STORE (ALUOP = "00")
        -- ==========================================
        -- Deve somar A + B, ignorando F3/INST30
        w_ALUOP <= "00";
        w_A     <= x"0000000A"; -- 10
        w_B     <= x"00000005"; -- 5
        w_F3    <= "000";       -- (Irrelevante neste caso)
        wait for 10 ns;
        -- Esperado: w_ULA = 15 (0F)

        -- ==========================================
        -- CASO 2: BRANCH BEQ (ALUOP = "01")
        -- ==========================================
        -- Deve subtrair A - B para testar Zero
        w_ALUOP <= "01";
        w_A     <= x"0000000A"; -- 10
        w_B     <= x"0000000A"; -- 10
        wait for 10 ns;
        -- Esperado: w_ULA = 0, w_ZERO = '1'

        -- ==========================================
        -- CASO 3: TIPO R (ALUOP = "10")
        -- Agora F3 e INST30 controlam a operação
        -- ==========================================
        w_ALUOP <= "10";

        -- 3.1 TESTE ADD (F3=000, INST30=0)
        w_F3     <= "000";
        w_INST30 <= '0';
        w_A      <= x"0000000A"; -- 10
        w_B      <= x"00000002"; -- 2
        wait for 10 ns;
        -- Esperado: 12 (0C)

        -- 3.2 TESTE SUB (F3=000, INST30=1)
        w_F3     <= "000";
        w_INST30 <= '1';
        wait for 10 ns;
        -- Esperado: 8 (08)

        -- 3.3 TESTE AND (F3=111)
        w_F3     <= "111";
        w_INST30 <= '0';
        w_A      <= x"0000000F"; -- 1111
        w_B      <= x"00000003"; -- 0011
        wait for 10 ns;
        -- Esperado: 3 (0011)

        -- 3.4 TESTE OR (F3=110)
        w_F3     <= "110";
        w_A      <= x"0000000C"; -- 1100
        w_B      <= x"00000003"; -- 0011
        wait for 10 ns;
        -- Esperado: 15 (1111)

        -- 3.5 TESTE XOR (F3=100)
        w_F3     <= "100";
        w_A      <= x"0000000F"; -- 1111
        w_B      <= x"0000000F"; -- 1111
        wait for 10 ns;
        -- Esperado: 0 (0000) e Zero='1'

        wait; -- Fim da simulação
    end process;

end Behavioral;