-- add sub

library IEEE;
use IEEE.std_logic_1164.all;
use std.env.all;
use IEEE.std_logic_unsigned.all;

entity somador is
    port(
        i_A, i_B    : in std_logic(31 downto 0);
        i_INST30    : in bit;
        o_S         : out std_logic(31 downto 0));
end somador;

architecture arch_1 of somador is
    component mux21 is
    port(   a, b, sel   : in bit;
            s           : out bit);
    end component;

    signal B_mux : std_logic(31 downto 0):

    GEN_MUX : for i in 0 to 31 generate
        U_MUX : mux21 port map(
            a => i_B(i),
            b => not i_B(i),
            sel => i_INST30
            s => B_mux
        );
    end generate GEN_MUX;
begin
    process(i_A, B_mux, i_INST30)
    begin
        if then
            o_S <= (i_A + B_mux) + 1;
        else
            o_S <= i_A + B_mux;
        end if;
    end process;
end;