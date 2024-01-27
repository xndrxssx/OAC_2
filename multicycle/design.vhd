library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity processor is
    Port ( 
    	clk : in  STD_LOGIC;
    	rst   : in std_logic;
        stop : out std_logic
    );
end processor;

architecture behavior of processor is

------------------- DECLARAÇÃO DE SINAIS --------------------------

	signal wireInstAddr, wireInput, wireRegA, wireRegB, wireAluOut, wireDataMem, wirePC, wireInstMem, wireAluResult, wireReadData1, wireReadData2, wireWriteData, wireE2, wireE1, wireDataReg : std_logic_vector(31 downto 0);
    signal wireBranch, wirePcWrite, wireMemWrite, wireMemToReg, wireIRWrite, wireAluSrcA, wireRegWrite, wireRegDst, wireClk, wireRst, wireZero : std_logic;
    signal wirePCSource, wireALUOp, wireALUSrcB : std_logic_vector(1 downto 0);
    signal wireAddr: std_logic_vector(25 downto 0);
    signal wireRs, wireRt, wireRd, wireWriteReg : std_logic_vector (4 downto 0);
    signal wireImm : std_logic_vector (15 downto 0);
    signal wireFunct, wireOp : std_logic_vector (5 downto 0);
    signal wireAluCtrl : std_logic_vector (2 downto 0);
    --signal wireE2 : std_logic_vector (3 downto 0);



begin
	process(clk, rst)
    	begin
        	wireClk <= clk;
        	wireRst <= rst;
        end process;

PC: entity work.reg32 port map(
	clk => wireClk,
    rst => wireRst,
    load => (wireBranch and wireZero) or wirePCWrite,
    d => wirePC,
    q => wireInstAddr
);
--------------------------ALUS-------------------------------------
ALU : entity work.alu port map(
	e1 => wireE1,	
    e2 => wireE2,
    oper => wireAluCtrl,	 -- function
	result => wireAluResult, -- Result  
    zero => wireZero
);

ALUCONTROL : entity work.alucontrol port map(
	AluOP => wireALUOp,
    funct => wireFunct,
    oper => wireAluCtrl
);

-------------------------------------------------------------------
CONTROL : entity work.control port map(
	op => wireOp,
    clk	=> wireClk, 
    rst	=> wireRst,
    PcWrite => wirePcWrite,
    regDst	=> wireRegDst,
    branch	=> wireBranch,
    irWrite => wireIRWrite,
    memWrite => wireMemWrite,                
    memToReg => wireMemToReg,
    aluOp	 => wireALUOp,                                                  
    PCSource => wirePCSource,
    regWrite => wireRegWrite,			 
    aluSrcA  => wireAluSrcA,
    aluSrcB  => wireALUSrcB,
    stop	=> stop
);
  
----------------------MEMORIAS---------------------------------------
RAM: entity work.ram port map(
	datain => wireRegB,
    address => wireAluOut,
    CLK => wireClk,
    write => wireMemWrite,
    dataout => wireDataMem
);

ROM: entity work.rom port map(
	address => wireInstAddr,
    data => wireInstMem
);


------------------------REGISTRADORES--------------------------------
REGA: entity work.ff32 PORT MAP(
	clk  => wireClk,
    rst  => wireRst,
	input => wireReadData1,
	output => wireRegA
	);

REGB: entity work.ff32 PORT MAP(
	clk  => wireClk,
    rst  => wireRst,
	input => wireReadData2,
	output => wireRegB
	);
    
REGISTRADORES: entity work.registers PORT MAP(
	clock => wireClk, 
    reset => wireRst,
    rr1 => wireRs,   -- read register 1
    rr2 => wireRt,   -- read register 2
    rw  => wireRegWrite,  		     -- read or write
    wr  => wireWriteReg,   -- register for write
    wd 	=> wireWriteData,  -- write data
    rd1	=> wireReadData1, -- read data 1
	rd2	=> wireReadData2  -- read data 2
	);

MEMORYDATAREGISTER: entity work.regAB PORT MAP(
--armazena qualquer dado vindo da memoria 
	input => wireDataMem,
	output => wireDataReg
	);

IREG: entity work.ireg PORT MAP(
--armazena a instrução que vai ser executada
	clk => wireClk,
    load => wireIRWrite,
    inst => wireInstMem,
    op => wireOp,
    addr => wireAddr,
    rs   => wireRs,
    rt   => wireRt,
    rd   => wireRd,
    funct =>wireFunct,
    imm  => wireImm
	);

ALUOUT: entity work.ff32 port map (
	clk  => wireClk,
    rst  => rst,
	input => wireAluResult,
	output => wireAluOut
);

------------------------MULTIPLEXADORES--------------------------------
MUX332: entity work.mux332 PORT MAP(
	d0 => wireAluResult,
    d1 => wireAluOut,
    d2 => (wireAddr & "00") & wireInstAddr(31 downto 28),
    s => wirePCSource,
    y => wirePC
	);
 
MUX432: entity work.mux432 PORT MAP(
	a => wireRegB,
    b => x"00000004",
    c => "0000000000000000" & wireImm,
    d => "00000000000000" & wireImm & "00",
    s => wireALUSrcB,
    output => wireE2
	);

MUX25_WriteReg: entity work.mux25 PORT MAP(
	d0 => wireRt,
    d1 => wireRd,
    s  => wireRegDst,
    y  => wireWriteReg
	);

MUX232_WriteData: entity work.mux232 PORT MAP(
	a => wireAluOut,
    b => wireDataReg,
    sel => wireMemToReg,
    output => wireWriteData
	);
    
MUX232_ALU: entity work.mux232 PORT MAP(
--vai calcular se vai ser pulado de endereço ou se vai pegar a informaçao
	a => wireInstAddr,
    b => wireRegA,
    sel => wireAluSrcA,
    output =>  wireE1
	);
----------------------------------------------------------------------
end behavior;

