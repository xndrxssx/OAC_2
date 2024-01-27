library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regAB is
    Port ( 
    input : in  STD_LOGIC_VECTOR (31 downto 0);
    output : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end regAB;

architecture behavior of regAB is

begin

process(input)

begin

output<=input;

end process;

end behavior;