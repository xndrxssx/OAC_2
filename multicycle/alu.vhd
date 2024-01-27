library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity alu is
  port ( 
    e1   : in  std_logic_vector(31 downto 0);
    e2   : in  std_logic_vector (31 downto 0);
    oper   : in  std_logic_vector (2 downto 0);	 -- function
	result : out std_logic_vector (31 downto 0); -- Result  
    zero   : out std_logic     					 -- zero
  );
end alu;

architecture behavior of alu is
signal ie1, ie2, iResult : STD_LOGIC_VECTOR(32 downto 0);
signal SS                : STD_LOGIC_VECTOR(31 downto 0);
begin
  process (e1, e2, oper)
  begin
    case oper is
      when "010" => -- add
        Result <= e1 + e2;
      when "110" => -- sub
        Result<= e1 + (not(e2)) + 1;
        if ((e1 + (not(e2)) + 1) = x"00000000") then 
          Zero<='1';
        else
          Zero<='0';
        end if;
      when "000" => -- and
        Result<= ((e1) and (e2)); 
      when "001" => -- or
        Result<= ((e1) or (e2));
      when "011" => -- jr
        Result<= e1;
      when "100" => -- xor
        Result<= ((e1) xor (e2));      
      when "111" => -- slt 
        if (e1 < e2) then 
          Result <= x"00000001"; 
        else 
          Result <= x"00000000";
        end if;
      when others => -- 
        Result <= x"00000000";
    end case;
  end process;
end behavior;