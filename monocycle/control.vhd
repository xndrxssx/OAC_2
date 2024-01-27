--------------------------------------------------
-- Control   								    --
--					    					    --
-- myRISC		         					    --
-- Prof. Max Santana  (2023)                    --
-- Aluna: Andressa Carvalho                     --
-- CEComp/Univasf                               --
--------------------------------------------------

-- unidade de controle

library ieee;
use ieee.std_logic_1164.all;

entity control is
  port(
    op		 : in std_logic_vector(5 downto 0);
    funct    : in std_logic_vector(5 downto 0);
    regDst	 : out std_logic_vector(1 downto 0);
    jump     : out std_logic_vector(1 downto 0);
    branch	 : out std_logic;
    bne		 : out std_logic;
    memWR	 : out std_logic;                    -- when 0 (write), 1 (read)
    memToReg : out std_logic_vector(1 downto 0);
    aluOp	 : out std_logic_vector(1 downto 0); 	 -- when 10 (R-type), 
                                                     --      00 (addi, lw, sw), 
                                                     --      01 (beq, bne), 
                                                     --      xx (j)
    aluSrc	 : out std_logic;
    regWrite     : out std_logic		-- when 1 write, else non-write
  );
end control;

architecture behavior of control is
begin
  process(op, funct)
  begin
    case (op) is
      when "000000" => -- R type
      	if (funct = "001000") then -- JR
        	regDst   <= "XX";
            jump     <= "10";  
            branch   <= 'X';
            memWR    <= 'X';
            memToReg <= "XX";
            aluOp	 <= "XX";
            aluSrc	 <= 'X';
            regWrite <= '0';
            bne      <= '0';
        else
        	regDst   <= "01";
            jump     <= "00";
            branch   <= '0';
            memWR    <= 'X';
            memToReg <= "00";
            aluOp	 <= "10";
            aluSrc	 <= '0';
            regWrite <= '1';
            bne      <= '0';
        end if;
      when "100011" => -- lw
      	regDst   <= "00";
		jump     <= "00";
        branch   <= '0';
        memWR    <= '0';
        memToReg <= "01";
        aluOp	 <= "00";
        aluSrc	 <= '1';
        regWrite <= '1';
        bne <= '0';
      when "101011" => -- sw
      	regDst   <= "XX";
		jump     <= "00";
        branch   <= '0';
        memWR    <= '1';
        memToReg <= "XX";
        aluOp	 <= "00";
        aluSrc	 <= '1';
        regWrite <= '0';
        bne      <= '0';
      when "000100" => -- beq
      	regDst   <= "XX";
		jump     <= "00";
        branch   <= '1';
        memWR    <= 'X';
        memToReg <= "XX";
        aluOp	 <= "01";
        aluSrc	 <= '0';
        regWrite <= '0';
        bne      <= '0';
      when "000101" => -- bne
      	regDst   <= "00";
		jump     <= "00";
        branch   <= '0';
        memWR    <= 'X';
        memToReg <= "XX";
        aluOp	 <= "01";
        aluSrc	 <= '0';
        regWrite <= '0';
        bne      <= '1';
      when "001000" => -- addi
        regDst	 <= "00";
		jump	 <= "00";
        branch	 <= '0';        
        memWR	 <= 'X';
        memToReg <= "00";
        aluOp	 <= "00";
        aluSrc	 <= '1'; 
        regWrite <= '1';
        bne      <= '0';
      when "000010" => -- j
        regDst	 <= "XX";
        jump	 <= "01";
        branch	 <= 'X';        
        memWR	 <= 'X';
        memToReg <= "XX";
        aluOp	 <= "XX";
        aluSrc	 <= 'X';
        regWrite <= 'X';
        bne <= 'X';
      when "000011" => -- jal
      	regDst   <= "10";
		jump     <= "01";
        branch   <= 'X';
        memWR    <= 'X';
        memToReg <= "10";
        aluOp	 <= "XX";
        aluSrc	 <= 'X';
        regWrite <= '1';
        bne      <= 'X';
      when others =>
        regDst	 <= "XX";
		jump	 <= "XX";
        branch	 <= 'X';
        memWR	 <= 'X';
        memToReg <= "XX";
        aluOp	 <= "XX";
        aluSrc	 <= 'X';
        regWrite <= '0';	
        bne      <= 'X';
    end case;
  end process;
end behavior;