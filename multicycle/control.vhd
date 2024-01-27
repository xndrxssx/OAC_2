library ieee;
use ieee.std_logic_1164.all;

entity control is
  port(
    op		 : in std_logic_vector(5 downto 0);
    clk		 : in std_logic; 
    rst		 : in std_logic; 
    PcWrite  : out std_logic;
    regDst	 : out std_logic;
    branch	 : out std_logic;
    irWrite  : out std_logic;
    memWrite : out std_logic;                    
    memToReg : out std_logic;
    aluOp	 : out std_logic_vector(1 downto 0); 	 
    -- when 10 (R-type),00 (addi, lw, sw),01 (beq, bne), 01 (beq, bne), xx (j)
    PCSource : out std_logic_vector(1 downto 0);
    regWrite : out std_logic;
    -- when 1 write, else non-write
    state 	 : out std_logic_vector(3 downto 0);
    aluSrcA  : out std_logic;
    aluSrcB  : out std_logic_vector(1 downto 0);
    --cause    : out std_logic;
    stop	: out std_logic;
       
  );
end control;

architecture behavior of control is

	type FSM is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
    signal current_state, next_state: FSM;

begin
  process(clk, rst) -- 
    begin
      if(falling_edge(rst)) then
          current_state <= s0;
          state <= "0000";
      elsif (falling_edge(clk)) then
          --debug
      case(next_state) is
          when s0  => state <= "0000";
          when s1  => state <= "0001";
          when s2  => state <= "0010";
          when s3  => state <= "0011";
          when s4  => state <= "0100";
          when s5  => state <= "0101";
          when s6  => state <= "0110";
          when s7  => state <= "0111";
          when s8  => state <= "1000";
          when s9  => state <= "1001";
          when s10 => state <= "1010";
          when s11 => state <= "1011";
          when s12 => state <= "1100";
      end case;
    --
   	current_state <= next_state; --linha bugada que ele mudou
  	end if;
  	end process;
  
  process(current_state)
  begin
  	case(current_state) is
--------------------instruction fetch ------------------
        when s0 => 				
        Branch <= 'X'; --
        PCWrite <= '1';
        MemWrite <= 'X'; --
        IRWrite <= '1';
        MemtoReg <='X'; --
        PCSource <="00";
        ALUOp <="00";
        ALUSrcB <= "01";
        ALUSrcA <='0'; --
        RegWrite <='X';--
        RegDst <= 'X'; --
        next_state <= s1;

-------------------decode/register fetch---------------------------
-- X e 0 n faz diferença (?)
        when s1 =>		
        PCWrite <= 'X'; --
        IRWrite <= 'X'; --
        ALUOp <="00"; --
        ALUSrcB <= "11"; --
        ALUSrcA <='0'; --
        
            case (op) is 	      	-- fazer o next_state baseado nas entradas
            	when "000000" => next_state <= s6;
                when "100011" | "101011" => next_state <= s2;
                when "000100" => next_state <= s8;
                when "001000" => next_state <= s9;
                when "000010" => next_state <= s11;
                when others =>   next_state <= s12;
            end case;
            
-------------------------lw/sw execute---------------------------
       when s2 =>	
        ALUOp <="00"; --
        ALUSrcB <= "10"; --
        ALUSrcA <='1';--
            if(op = "100011") then 
            	next_state <= s3;
            elsif (op = "101011") then
            	next_state <= s5;
            end if;
       
----------------------------lw memory access--------------------------
--a unica vez que da load é no s0, basicamente tudo é zero aqui

       when s3 => 
       next_state <= s4;
-----------------------------lw write back----------------------------
       when s4 =>
       MemtoReg <='1'; --
       RegWrite <='1'; --
       RegDst <= '0'; --
       	next_state <= s0;

-----------------------------sw write back------------------------
       when s5 =>
        MemWrite <= '1'; --
        next_state <= s0;
                
------------------R-type execution----------------
       when s6 =>
       ALUOp <="10"; --
       ALUSrcB <= "00"; --
       ALUSrcA <='1'; --
       next_state <= s7;
                
-------------------R-type completion--------------
        when s7 =>
       	MemtoReg <='0'; --
        RegWrite <='1'; --
        RegDst <= '1'; --
       	next_state <= s0;
                
-----------------------BEQ Completion ----------------
--branch é diferente do pulo do j!!
        when s8 => 
		Branch <= '1'; --
          PCSource <="01"; --
          ALUOp <="01"; --
          ALUSrcB <= "00"; --
          ALUSrcA <='1'; --
           next_state <= s0;
           
       	when s9 =>
			ALUOp <="00"; --
          ALUSrcB <= "10"; --
          ALUSrcA <='1'; --
       		next_state <= s10;
                
--------------------------addi execute----------------
       when s10 =>
       	MemtoReg <='0'; --
        RegWrite <='1'; --
        RegDst <= '0'; --
       	next_state <= s0;
                
--------------------addi write back----------------
        when s11 =>
        	PCWrite <= '1'; --
          PCSource <="10"; --
          next_state <= s0;
       
------------------------parada--------------------- 
       when s12 =>
       		stop <= '1';
    end case;
  end process;
end behavior;