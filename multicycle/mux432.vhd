--multiplexador 4:32bits

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux432 is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           b : in  STD_LOGIC_VECTOR (31 downto 0);
           c : in  STD_LOGIC_VECTOR (31 downto 0);
           d : in  STD_LOGIC_VECTOR (31 downto 0);
           s : in  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0)
           );
end mux432;

architecture behavior of mux432 is

begin

    process(a, b, c, d, s)
    begin
        case s is
            when "00" =>
                output <= a;
            when "01" =>
                output <= b;
            when "10" =>
                output <= c;
            when "11" =>
                output <= d;
            when others =>
              output <= (others => '0'); 
        end case;
    end process;

end behavior;