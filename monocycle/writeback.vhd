--------------------------------------------------
-- WriteBack							  	    --
--					    					    --
-- myRISC		         					    --
-- Prof. Max Santana  (2023)                    --
-- Aluna: Andressa Carvalho                     --
-- CEComp/Univasf                               --
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity writeback is
  port(
    memoryData : in std_logic_vector(31 downto 0);
    PcPlus4    : in std_logic_vector(31 downto 0); -- Adicionando a porta PcPlus4
    result     : in std_logic_vector(31 downto 0);
    memToReg   : in std_logic_vector(1 downto 0);
    writeData  : out std_logic_vector(31 downto 0)
  );
end writeback;

architecture behavior of writeback is
  signal wireRegB    : std_logic_vector(31 downto 0);
  signal wireOper    : std_logic_vector(2 downto 0);
begin
  MUXWD: entity work.mux332 port map (
    d0 => result,
    d1 => memoryData,
    d2 => PcPlus4,  -- Conectando a porta PcPlus4 ao MUX332
    s  => memToReg,
    y  => writeData
  );
end behavior;