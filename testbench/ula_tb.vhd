library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
-- Testbench não tem portas
end testbench;

architecture Behavioral of testbench is

    -- Declaração do Componente (Deve ser idêntico à Entity da ULA)
    component ULA is
        port(
            i_A         : in  std_logic_vector(31 downto 0);
            i_B         : in  std_logic_vector(31 downto 0);
            i_ALUOP     : in  std_logic_vector(2 downto 0);
            i_CODE      : IN  std_logic_vector(6 DOWNTO 0); 
            i_F3        : in  std_logic_vector(2 downto 0);
            i_INST30    : in  std_logic;
            o_ZERO      : out std_logic;
            o_ULA       : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Sinais para conectar no DUT (Device Under Test)
    signal w_A      : std_logic_vector(31 downto 0) := (others => '0');
    signal w_B      : std_logic_vector(31 downto 0) := (others => '0');
    signal w_ALUOP  : std_logic_vector(2 downto 0)  := (others => '0');
    signal w_ZERO   : std_logic;
    signal w_ULA    : std_logic_vector(31 downto 0);
    
    -- Sinais "dummy" (não usados, apenas para preencher porta)
    signal w_dummy_CODE : std_logic_vector(6 downto 0) := (others => '0');
    signal w_dummy_F3   : std_logic_vector(2 downto 0) := (others => '0');
    signal w_dummy_INST : std_logic := '0';

begin

    -- Instancia a ULA
    DUT: ULA port map (
        i_A      => w_A,
        i_B      => w_B,
        i_ALUOP  => w_ALUOP,
        i_CODE   => w_dummy_CODE,
        i_F3     => w_dummy_F3,
        i_INST30 => w_dummy_INST,
        o_ZERO   => w_ZERO,
        o_ULA    => w_ULA
    );

    -- Processo de estímulos
    stim_proc: process
    begin
        -- Aguarda inicialização
        wait for 100 ns;

        -- =========================================================
        -- TESTE 1: SOMA (ADD) - Opcode "000"
        -- =========================================================
        -- Operação: 10 + 5 = 15
        w_ALUOP <= "000"; 
        w_A     <= x"0000000A"; -- Decimal 10
        w_B     <= x"00000005"; -- Decimal 5
        wait for 10 ns;
        -- ESPERADO: o_ULA = x"0000000F" (15 decimal), o_ZERO = '0'

        -- =========================================================
        -- TESTE 2: SUBTRAÇÃO (SUB) - Opcode "001"
        -- =========================================================
        -- Operação: 10 - 5 = 5
        w_ALUOP <= "001";
        w_A     <= x"0000000A"; -- Decimal 10
        w_B     <= x"00000005"; -- Decimal 5
        wait for 10 ns;
        -- ESPERADO: o_ULA = x"00000005" (5 decimal), o_ZERO = '0'

        -- =========================================================
        -- TESTE 3: FLAG ZERO (SUB) - Opcode "001"
        -- =========================================================
        -- Operação: 10 - 10 = 0 (Verifica se o_ZERO vai para '1')
        w_ALUOP <= "001";
        w_A     <= x"0000000A"; -- Decimal 10
        w_B     <= x"0000000A"; -- Decimal 10
        wait for 10 ns;
        -- ESPERADO: o_ULA = x"00000000", o_ZERO = '1' (HIGH)

        -- =========================================================
        -- TESTE 4: AND Lógico - Opcode "010"
        -- =========================================================
        -- Operação: A(1010) AND B(1100) = 1000 (8)
        w_ALUOP <= "010";
        w_A     <= x"0000000A"; -- Binário ...1010
        w_B     <= x"0000000C"; -- Binário ...1100
        wait for 10 ns;
        -- ESPERADO: o_ULA = x"00000008" (...1000)

        -- =========================================================
        -- TESTE 5: OR Lógico - Opcode "011"
        -- =========================================================
        -- Operação: A(1010) OR B(0101) = 1111 (15)
        w_ALUOP <= "011";
        w_A     <= x"0000000A"; -- Binário ...1010
        w_B     <= x"00000005"; -- Binário ...0101
        wait for 10 ns;
        -- ESPERADO: o_ULA = x"0000000F" (...1111)

        -- =========================================================
        -- TESTE 6: XOR Lógico - Opcode "100"
        -- =========================================================
        -- Operação: A(1111) XOR B(1010) = 0101 (5)
        w_ALUOP <= "100";
        w_A     <= x"0000000F"; -- Binário ...1111
        w_B     <= x"0000000A"; -- Binário ...1010
        wait for 10 ns;
        -- ESPERADO: o_ULA = x"00000005" (...0101)

        wait; -- Para a simulação
    end process;

end Behavioral;