--multiplexador 2:32bits

library ieee ;
use ieee.std_logic_1164.all;

entity mux232 is
    Port ( a 		: in  STD_LOGIC_VECTOR (31 downto 0);
           b 		: in  STD_LOGIC_VECTOR (31 downto 0);
           sel  	: in  STD_LOGIC;
           output   : out  STD_LOGIC_VECTOR (31 downto 0));
end mux232;

architecture behavior of mux232 is

	begin

		process(a,b,sel)
		begin

          if sel = '0' then
          output <= a;
          elsif sel = '1' then
          output <= b;
          end if;
          end process;

end behavior;