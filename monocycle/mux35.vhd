--------------------------------------------------
-- mux35										--
--					    					    --
-- myRISC		         					    --
-- Prof. Max Santana  (2023)                    --
-- Aluna: Andressa Carvalho                     --
-- CEComp/Univasf                               --
--------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all;

entity mux35 is
  port(
    d0, d1, d2 : in std_logic_vector(4 downto 0); -- Cabem 32bits
    s          : in std_logic_vector(1 downto 0);
    y           : out std_logic_vector(4 downto 0)
  );
end mux35;

architecture behavior of mux35 is
begin
  y <= d0 when s = "00" else
              d1 when s = "01" else
            d2 when s = "10";
end behavior;