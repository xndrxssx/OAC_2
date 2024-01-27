--------------------------------------------------
-- 32 bits adder							    --
--					    					    --
-- myRISC		         					    --
-- Prof. Max Santana  (2023)                    --
-- Aluna: Andressa Carvalho                     --
-- CEComp/Univasf                               --
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.ALL;

entity adder32 is
  port(
    a     : in std_logic_vector(31 downto 0);
    b     : in std_logic_vector(31 downto 0);
    s     : out std_logic_vector(31 downto 0)
  );
end adder32;

architecture behavior of adder32 is
begin
  s <= a + b;
end behavior;