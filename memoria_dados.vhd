library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria_dados is
  Port (
    i_CLK       : in std_logic;
    i_MEM_WRITE : in std_logic;
    i_MEM_READ  : in std_logic;
    i_ADDR      : in std_logic_vector(31 downto 0);
    i_DATA      : in std_logic_vector(31 downto 0);
    o_DATA      : out std_logic_vector(31 downto 0)
  );
end memoria_dados;

architecture arch_memoria_dados of memoria_dados is

  type t_MEMORIA is array(0 to 255) of std_logic_vector(7 downto 0);
  signal memoria : t_MEMORIA := (others => (others => '0'));

begin

  process(i_CLK, i_MEM_WRITE, i_ADDR, i_MEM_READ, memoria)
    variable addr_int : integer;
  begin

    if rising_edge(i_CLK) then
      case i_MEM_WRITE is
        when '1' =>
          addr_int := to_integer(unsigned(i_ADDR));

          case addr_int is
            when 0 to 251 =>   -- 252 posições possíveis
              memoria(addr_int)     <= i_DATA(7 downto 0);  
              memoria(addr_int + 1) <= i_DATA(15 downto 8);
              memoria(addr_int + 2) <= i_DATA(23 downto 16);
              memoria(addr_int + 3) <= i_DATA(31 downto 24);
            when others =>
              null;
          end case;

        when others =>
          null;
      end case;
    end if;

    case i_MEM_READ is
      when '1' =>
        addr_int := to_integer(unsigned(i_ADDR));

        case addr_int is
          when 0 to 251 =>
            o_DATA <= memoria(addr_int + 3) &
                      memoria(addr_int + 2) &
                      memoria(addr_int + 1) &
                      memoria(addr_int);
          when others =>
            o_DATA <= (others => '0');
        end case;

      when others =>
        o_DATA <= (others => '0');
    end case;

  end process;

end architecture arch_memoria_dados;
