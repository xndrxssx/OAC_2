--------------------------------------------------
-- Control   								    --
--					    					    --
-- myRISC		         					    --
-- Prof. Max Santana  (2023)                    --
-- Aluna: Andressa Carvalho                     --
-- CEComp/Univasf                               --
--------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity processor is
  port(
    clk   : in std_logic;
    rst   : in std_logic
  );
  end processor;
  
  architecture behv of processor is
 
 	signal wireClk, wireRst, wireBranch, wireZero, wireRegWrite, wireBne, wireMem, wireAluSrc: std_logic;
    signal wireJumpAddr, wireBranchAddr, wirePcPlus4, wireInst, wireWriteData, wireReadData1, wireReadData2, wireImm, wireResult, 		wireMemData: std_logic_vector(31 downto 0);
    signal wireOpCode, wireFunct: std_logic_vector(5 downto 0);
    signal wireAluOp, wireJump,wireRegDst, wireMemToReg: std_logic_vector(1 downto 0);

    
    begin
	    
        process(clk,rst)
        begin
            wireClk <= clk;
            wireRst <= rst;
        end process;
        
  	FETCH : entity work.fetch port map (
   		--Entrada
        rst        => wireRst,
        branch     => wireBranch,           -- control signal (branch)
        zero       => wireZero,             -- control signal (zero)
        branchAddr => wireBranchAddr,  		-- Branch Address
        jumpAddr   => wireJumpAddr,  		-- Jump Address
        jump       => wireJump,             -- control signal (jump)
        clk        => wireClk,				-- Clock
        readData1  => wireReadData1,
        bne => wireBne,
        --Saida
       	PCplus4    => wirePcPlus4,
        inst       => wireInst
  );
  CONTROL : entity work.control port map(
  		--Entrada
        op		 => wireOpCode,
        funct    => wireFunct,
        --Saida
    	regDst	 => wireRegDst,
    	jump	 => wireJump,
    	branch	 => wireBranch,
    	bne		 => wireBne,
    	memWR	 => wireMem,       -- when 0 (write), 1 (read)
    	memToReg => wireMemToReg,
    	aluOp	 => wirealuOp, 			 -- when 10 (R-type), 
                                         --      00 (addi, lw, sw), 
                                         --      01 (beq, bne), 
                                         --      xx (j)
    	aluSrc	 => wirealuSrc,
    	regWrite     => wireRegWrite
  );
  DECODE : entity work.decode port map(
  	    --Entrada
        clk        => wireClk,
        rst        => wireRst,
        PCplus4    => wirePcPlus4,		-- next program counter (PC+4)
        inst       => wireInst,			-- instruction
        writeData  => wireWriteData,	-- write data
        regDst     => wireRegDst,       -- control signal (regdst)
        regWrite   => wireRegWrite,     -- control signal (regwrite)
        --Saida
        jumpAddr   => wireJumpAddr, 	-- Jump Address
        opcode     => wireOpCode, 		-- opcode
        readData1  => wireReadData1, 	-- Read data 1
        readData2  => wireReadData2, 	-- Read data 2
        imm        => wireImm, 			-- Imm (32 bits)
        funct      => wireFunct     	-- funct    
        
  );
    EXECUTE: entity work.execute port map(
    	--Entrada
    	pcPlus4     => wirePcPlus4,
        aluSrc 	    => wireAluSrc,
        readData1 	    => wireReadData1,
        readData2 		=> wireReadData2,
        imm 		=> wireImm,
        funct 		=> wireFunct,
        aluOp 		=> wireAluOp,
        --Saida
        result	 	=> wireResult,
        zero 		=> wireZero,
        branchAddr  => wireBranchAddr
    );
    MEMORYACCESS: entity work.memoryAccess port map (
    	--Entrada
        clk => wireClk, 
        address    => wireResult,
        memWrite   => wireMem,
        writeData  => wireReadData2,
        
        --Saida
        memoryData => wireMemData
    );
    WRITEBACK: entity work.writeback port map (
    	-- Entrada
    	memoryData => wireMemData,
    	PcPlus4    => wirePcPlus4, -- Conectando a porta PcPlus4
    	memToReg   => wireMemToReg,
    	-- Saída
    	result     => wireResult,
    	writeData  => wireWriteData
);
  
  end behv;