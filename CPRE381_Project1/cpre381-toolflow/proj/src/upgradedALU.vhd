-------------------------------------------------------------------------
-- L8 Sk8ters
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- upgradedALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a ones complementor.
-- Inverts each individual bit of an n-bit input.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity upgradedALU is
  generic(N : integer := 32;
  	  S : integer := 10);
  port(CLK	  : in std_logic;
       ALUCtrl	  : in std_logic_vector(S-1 downto 0);
       i_A	  : in std_logic_vector(N-1 downto 0);
       i_B 	  : in std_logic_vector(N-1 downto 0);
       o_Result	  : out std_logic_vector(N-1 downto 0);
       o_Carry    : out std_logic;
       o_Overflow : out std_logic;
       o_Zero     : out std_logic);
  end upgradedALU;

architecture mixed of upgradedALU is

-- Component Declaration ------------------------------------------------
-- adderSub
component adderSub_N is
  generic(N : integer := 32);
  port(iCLK           : in std_logic;
       iA             : in std_logic_vector(N-1 downto 0);
       iB             : in std_logic_vector(N-1 downto 0);
       nAdd_Sub       : in std_logic;
       Ov             : in std_logic;
       o_Sum          : out std_logic_vector(N-1 downto 0);
       o_C            : out std_logic;
       o_Ov	      : out std_logic);
  end component;

-- barrelShifter
component barrelShifter is
  generic(N : integer := 32;
	  S : integer := 5 );
  port(i_D            : in std_logic_vector(N-1 downto 0);
       shamt 	      : in std_logic_vector(S-1 downto 0);
       signKeep       : in std_logic;			    -- 0 = sll/srl, 1 = sra
       dir            : in std_logic;			    -- 0 = right, 1 = left
       o_Q            : out std_logic_vector(N-1 downto 0));
  end component;

-- logicalOpsUnit
component logicalOpsUnit is
  generic(N : integer := 32;
  	  S : integer := 3);
  port(outputSel  : in std_logic_vector(S-1 downto 0);
       i_A	  : in std_logic_vector(N-1 downto 0);
       i_B 	  : in std_logic_vector(N-1 downto 0);
       o_F	  : out std_logic_vector(N-1 downto 0));
  end component;

-- branchUnit
component branchUnit is
  generic(N : integer := 32);
  port(iCLK           : in std_logic;
       i_A            : in std_logic_vector(N-1 downto 0);
       i_B            : in std_logic_vector(N-1 downto 0);
       findIsEqual    : in std_logic;
       o_zero	      : out std_logic);
  end component;

-- NOR Gate to determine if we need Ov from AdderSub
component norg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

-- 2t1 mux to pick where we get Ov from
component mux2t1 is
  port(i_S          : in std_logic;
       i_D0         : in std_logic;
       i_D1         : in std_logic;
       o_O          : out std_logic);
end component;

--- SIGNALS ---------------------------------------------------------------
signal s_Sum            : std_logic_vector(N-1 downto 0);   
signal s_barrelOut	: std_logic_vector(N-1 downto 0);
signal s_logicOut	: std_logic_vector(N-1 downto 0);
signal s_NeedOverflow	: std_logic;
signal s_Overflow       : std_logic;
--------------------------------------------------------------------------

begin

---------------------------------------------------------------------------
-- Level 0: Perform Logical Operations
---------------------------------------------------------------------------
-- Adder Subtractor (00)
adderSub1: adderSub_N
  port MAP(iCLK         => CLK,
           iA           => i_A,
           iB           => i_B,
           nAdd_Sub     => ALUCtrl(0),
           Ov           => ALUCtrl(1),
           o_Sum        => s_Sum,
           o_C          => o_Carry,
           o_Ov	        => s_Overflow);

-- DETERMINE WHERE WE GET OVERFLOW FROM
g_norg: norg2
  port MAP(i_A          => ALUCtrl(4),
           i_B          => ALUCtrl(3),
           o_F          => s_NeedOverFlow);

-- 2t1 mux to pick where we get Ov from
g_mux2t1: mux2t1
  port MAP(i_S              => s_NeedOverflow,
           i_D0             => '0',
           i_D1             => s_Overflow,
           o_O              => o_Overflow);



-- Barrel Shifter (01)
barrelShifter1: barrelShifter
  port MAP(i_D          => i_B,
           shamt 	=> ALUCtrl(9 downto 5),
           signKeep     => ALUCtrl(0),		
           dir          => ALUCtrl(1),
           o_Q          => s_barrelOut);

-- Logical Ops Unit (10)
logicalOpsUnit1: logicalOpsUnit
  port MAP(outputSel    => ALUCtrl(2 downto 0),
           i_A	        => i_A,
           i_B 	        => i_B,
           o_F          => s_logicOut);

-- Branch Unit
branchUnit1: branchUnit
  port MAP(iCLK 	=> CLK,
	   i_A		=> i_A,
	   i_B		=> i_B,
	   findisEqual  => ALUCtrl(0),
	   o_zero	=> o_Zero);

---------------------------------------------------------------------------
-- Level 1: Select Logical Operation to be Output
---------------------------------------------------------------------------

 with ALUCtrl(4 downto 3) select o_Result <= 
   s_Sum              when "00", 
   s_barrelOut        when "01",
   s_logicOut         when "10",
   x"12345678"	      when others;

end mixed;



  