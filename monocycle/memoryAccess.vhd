--------------------------------------------------
-- Memory Access							    --
--					    					    --
-- myRISC		         					    --
-- Prof. Max Santana  (2023)                    --
-- Aluna: Andressa Carvalho                     --
-- CEComp/Univasf                               --
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity memoryAccess is
  port(
  	clk        : in std_logic; -- Adicionando o sinal de clock
  	address    : in std_logic_vector(31 downto 0);
    memWrite   : in std_logic;
    writeData  : in std_logic_vector(31 downto 0);
    memoryData : out std_logic_vector(31 downto 0)
  );
end memoryAccess;

architecture behavior of memoryAccess is
  signal wireRegB   	: std_logic_vector(31 downto 0);
  signal wireOper   	: std_logic_vector(2 downto 0);

begin
  DATAMEMORY: entity work.ram port map (
  	clk => clk,
    datain  => writeData,
    address => address,   
    write   => memWrite, -- write when 1, read when 0
    dataout => memoryData
  );
  
  
end behavior;