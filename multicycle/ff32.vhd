library IEEE;
use IEEE.std_logic_1164.all;

entity ff32 is
	port(
    	clk, rst : in std_logic;
        input		 : in std_logic_vector(31 downto 0);
        output       : out std_logic_vector(31 downto 0)
	);
end ff32;

architecture behavior of ff32 is
	begin
    	
        process(clk, rst)
        	begin
            	if (falling_edge(rst)) then
                	output <= (output'range => '0');
                elsif (falling_edge(clk)) then
                	output <= input;
                end if;
        end process;
end behavior;