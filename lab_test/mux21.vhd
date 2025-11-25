-- mux 2 bit 1 test

entity mux21 is
    port(   a, b, sel   : in bit;
            s           : out bit);
end mux21

architecture arch_mux21 is
begin
    s <= (a and not sel) or (b and sel);
end