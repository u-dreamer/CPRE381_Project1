-------------------------------------------------------------------------
-- L8 Sk8rs
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_upgradedALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the upgradeALU in
-- 		Project 1.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_upgradedALU is
  generic  (gCLK_HPER   : time := 10 ns; -- Generic for half of the clock cycle period
            N : integer := 32;
            S : integer := 10);     
end tb_upgradedALU;

architecture arch of tb_upgradedALU is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- Component Declaration -----------------------------------------------------------------
  component upgradedALU is
  port(CLK	  : in std_logic;
       ALUCtrl	  : in std_logic_vector(S-1 downto 0);
       i_A	  : in std_logic_vector(N-1 downto 0);
       i_B 	  : in std_logic_vector(N-1 downto 0);
       o_Result	  : out std_logic_vector(N-1 downto 0);
       o_Carry    : out std_logic;
       o_Overflow : out std_logic;
       o_Zero     : out std_logic);
  end component;

-- SIGNALS -------------------------------------------------------------------------------
signal CLK, reset : std_logic := '0';

--Initialize inputs to 0
signal ALUCtrl    : std_logic_vector(S-1 downto 0) := "0000000000";
signal i_A        : std_logic_vector(N-1 downto 0) := x"00000000";
signal i_B        : std_logic_vector(N-1 downto 0) := x"00000000";
signal o_Result   : std_logic_vector(N-1 downto 0) := x"00000000";
signal o_Carry    : std_logic;
signal o_Overflow : std_logic;
signal o_Zero     : std_logic;

begin

-- Port/Signal Mapping ------------------------------------------------------
  DUT0: upgradedALU
  port map( CLK		=> CLK,
	    ALUCtrl     => ALUCtrl,
            i_A         => i_A,
	    i_B         => i_B,
            o_Result    => o_Result,
	    o_Carry     => o_Carry,
            o_Overflow  => o_Overflow,
            o_Zero 	=> o_Zero);

-- Clock Stuff -----------------------------------------------------------
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
-- Test Cases ---------------------------------------------------------------

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

-- Add/Sub Tests ------------------------------------------------------------
-- ALUCtrl: 9 8 7 6 5 |     4      3   |   2    1     0    
--	    [shamt]    [Pick Output: 00]   X   oV  nAdd_Sub
--------------------------------------------------------------------------------
-- Unsigned Cases  
    -- Test case 0: Sum <= A + B (no overflow, unsigned)
    -- addu
    ALUCtrl    <= "0000000000"; -- nAdd_Sub = 0, oV = 0
			       -- Perform unsigned add
    i_A       <= x"00000001";
    i_B       <= x"00000001";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000002

    -- Test case 1: Sum <= A - B = 2 - 1 (no overflow, unsigned)
    -- subu
    ALUCtrl    <= "0000000001"; -- nAdd_Sub = 1, oV = 0
			       -- Perform unsigned sub
    i_A       <= x"00000002";
    i_B       <= x"00000001";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000001
    --         o_Ov  = 0

-- Signed Test Cases 
    -- Test case 3: -13 + 10 (no overflow, signed)
    -- add
    ALUCtrl    <= "0000000010"; -- nAdd_Sub = 0, oV = 0
			       -- Perform unsigned add
    i_A       <= x"FFFFFFF3";
    i_B       <= x"0000000A";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0xFFFFFFFD
    --         o_Ov  = 0

    -- Test case 4: 9+7 (no overflow, signed)
    -- add
    ALUCtrl    <= "0000000010"; -- nAdd_Sub = 0, oV = 0
			       -- Perform unsigned add
    i_A       <= x"00000009";
    i_B       <= x"00000007";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0b10000 = 0x00000010
    --         o_Ov  = 0

    -- Test case 5: -2 - (-5) (no overflow, signed, 32-bit)
    -- sub
    ALUCtrl    <= "0000000011"; -- nAdd_Sub = 0, oV = 0
			       -- Perform unsigned add
    i_A       <= x"FFFFFFFE";
    i_B       <= x"FFFFFFFB";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000003
    --         o_Ov  = 0

    -- Test case 6: -1 + -1 (overflow, signed, 32-bit)
    -- add
    ALUCtrl    <= "0000000010"; -- nAdd_Sub = 0, oV = 0
			       -- Perform unsigned add
    i_A       <= x"FFFFFFFF";
    i_B       <= x"FFFFFFFF";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0xFFFFFFFE (-2)
    --         o_Ov  = 1

-- Barrel Shifter Tests ------------------------------------------------------------
-- ALUCtrl: 9 8 7 6 5 |     4    3     | 2      1     0    
--	    [shamt]    [Pick Output: 01] X     dir   signKeep
------------------------------------------------------------------------------------
  
-- Test case 7: Let inital value pass through
   ALUCtrl    <= "0000001000";  -- shamt = 0, val passes through
   -- 01 = pick BS output; 
   -- dir = X (1 = left, 0 = R; signKeep = X (0 = no, 1 = yes)
    i_A       <= x"0000FFFF";  -- Data to shift
    i_B       <= x"FFFFFFFF";  -- Don't Care! 
    wait for gCLK_HPER*2;
    -- Expect: oQ = 0x0000FFFF
  
    -- Test case 8: Test sll
   ALUCtrl    <= "0011101010";  -- shamt = 7, shift by 7 bits
   -- 01 = pick BS output; 
   -- dir = 1 = left; signKeep = X (0 = no, 1 = yes)
    i_A       <= x"0000FFFF";  -- Data to shift
    i_B       <= x"FFFFFFFF";  -- Don't Care! 
    wait for gCLK_HPER*2;
    -- Expect: oQ = 0x0007FF80

    -- Test case 9: Test srl
    ALUCtrl    <= "1111101000";  -- shamt = 31, shift by 31 bits
    -- 01 = pick BS output; 
    -- dir = 0 = right; signKeep = 0 (0 = no, 1 = yes)
    i_A      <= x"0000FFFF";      
    wait for gCLK_HPER*2;
    -- Expect: oQ = 0x00000000

    -- Test case 10: Test sra
   ALUCtrl    <= "0011101001";  -- shamt = 7, shift by 7 bits
   -- 01 = pick BS output; 
   -- dir = 0 = right; signKeep = 1 (0 = no, 1 = yes)
   i_A     <= x"0000FFFF";      
   wait for gCLK_HPER*2;
   -- Expect: oQ = 0x000001FF

   -- Test case 11: Test sra when sign bit = 1
   ALUCtrl    <= "0001101001";  -- shamt = 7, shift by 7 bits
   -- 01 = pick BS output; 
   -- dir = 0 = right; signKeep = 1 (0 = no, 1 = yes)
   i_A     <= x"8000FFFF";      
    wait for gCLK_HPER*2;
    -- Expect: oQ = 0xf0001fff

   -- Test case 12: Test sll (when signKeep = 1)
   ALUCtrl    <= "0011101011";  -- shamt = 7, shift by 7 bits
   -- 01 = pick BS output; 
   -- dir = 1 = left; signKeep = X (0 = no, 1 = yes)
    i_A       <= x"0000FFFF";      
    wait for gCLK_HPER*2;
    -- Expect: oQ = 0x0007FF80

-- Logical Ops Unit Tests ------------------------------------------------------------
-- ALUCtrl: 9 8 7 6 5 |    4       3     |  2      1     0    
--	    [shamt]    [Pick Output: 10]  [Control Unit Output]
------------------------------------------------------------------------------------

-- NOT Tests -----------------------------------------------------------------
    -- Test case 13: NOT Gate 
    ALUCtrl    <= "0000010000"; -- Select NOT Output
    i_A        <= x"00000000"; -- Should be inverted
    i_B        <= x"FFFF0000"; -- Should be ignored (for NOT)
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0xFFFFFFFF

    -- Test case 1:4 NOT Gate 
    ALUCtrl    <= "0000010000"; -- Select NOT Output
    i_A   <= x"F0F01111"; -- Should be inverted
    i_B   <= x"FFFFFFFF"; -- Should be ignored (for NOT)
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x0F0FEEEE

-- XOR Tests -----------------------------------------------------------------
    -- Test case 15: XOR Gate 
    ALUCtrl    <= "0000010001"; -- Select XOR Output
    i_A   <= x"00000000";       -- Should be XOR'd with i_B
    i_B   <= x"FFFF0000"; 
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0xFFFF0000

    -- Test case 16: XOR Gate 
    ALUCtrl    <= "0000010001"; -- Select XOR Output
    i_A   <= x"10101010"; -- Should be XOR'd with i_B
    i_B   <= x"33333333"; 
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x23232323

-- OR Tests -----------------------------------------------------------------
    -- Test case 17: OR Gate 
    ALUCtrl    <= "0000010010"; -- Select OR Output
    i_A   <= x"00000000"; 	-- Should be OR'd with i_B
    i_B   <= x"FFFF0000"; 
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0xFFFF0000

    -- Test case 18: OR Gate 
    ALUCtrl    <= "0000010010"; -- Select OR Output
    i_A   <= x"10101010"; 	-- Should be OR'd with i_B
    i_B   <= x"33333333"; 
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x33333333

-- NOR Tests -----------------------------------------------------------------
    -- Test case 19: NOR Gate 
    ALUCtrl    <= "0000010011"; -- Select NOR Output
    i_A   <= x"00000000"; 	-- Should be NOR'd with i_B
    i_B   <= x"FFFF0000"; 
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x0000ffff

    -- Test case 20: NOR Gate 
    ALUCtrl    <= "0000010011"; -- Select NOR Output
    i_A   <= x"10101010"; 	-- Should be NOR'd with i_B
    i_B   <= x"33333333"; 
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0xCCCCCCCC

-- AND Tests -----------------------------------------------------------------
    -- Test case 21: AND Gate 
    ALUCtrl    <= "0000010100"; -- Select AND Output
    i_A   <= x"FF000000"; 	-- Should be AND'd with i_B
    i_B   <= x"FFFF0000"; 
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0xFF000000

    -- Test case 22: AND Gate 
    ALUCtrl    <= "0000010100"; -- Select AND Output
    i_A   <= x"10101010"; 	-- Should be AND'd with i_B
    i_B   <= x"33333333"; 
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x10101010

-- SLT Tests -----------------------------------------------------------------
    -- Test case 23: SLT
    ALUCtrl    <= "0000010101"; -- Select SLT Output
    i_A   <= x"00000000"; -- If 0 < -65536, o_F = 1
    i_B   <= x"FFFF0000"; 
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x00000000

    -- Test case 24: SLT
    ALUCtrl    <= "0000010101"; -- Select SLT Output
    i_A   <= x"FFFFFF01"; -- If -255 < 0, o_F = 1
    i_B   <= x"00000000"; 
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x00000001

-- Repl.qb Tests -------------------------------------------------------------
    -- Test case 25: repl.qb
    ALUCtrl    <= "0000010110"; -- Select repl.qb Output
    i_B   <= x"000022F1";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0xF1F1F1F1

    -- Test case 26: repl.qb
    ALUCtrl    <= "0000010110"; -- Select repl.qb Output
    i_B   <= x"00000321";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x21212121

    -- Test case 27: Entire word has data
    ALUCtrl    <= "0000010110"; -- Select repl.qb Output
    i_B   <= x"12341111";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x11111111

    -- Test case 28: Entire word has data
    ALUCtrl    <= "0000010110"; -- Select repl.qb Output
    i_B   <= x"00110000";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x00000000


-- Lui Tests -------------------------------------------------------------
    -- Test case 29: Entire word has data
    ALUCtrl    <= "0000010111"; -- Select repl.qb Output
    i_B   <= x"12341111";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x12340000

    -- Test case 30: Entire word has data
    ALUCtrl    <= "0000010111"; -- Select repl.qb Output
    i_B   <= x"00000011";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x00110000


-- Branch Unit Tests ------------------------------------------------------------
-- ALUCtrl: 9 8 7 6 5 |    4       3     |  2      1     0    
--	    [shamt]    [Pick Output: XX]  [XXX] (Always writes to o_Zero)
------------------------------------------------------------------------------------
    -- Test case 31: Everything = 0
    -- iA = 0x00000000, iB = 0x00000000, findIsEqual = 1
    ALUCtrl       <= "0000000001"; -- 0 = bne, 1 = beq
    i_A          <= x"00000000";
    i_B          <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: o_zero = 0

    -- Test case 32: Testing beq, FAILS
    -- iA = 0xF0F0F0F0, iB = 0x00000000, findIsEqual = 1
    ALUCtrl       <= "0000000001"; -- 0 = bne, 1 = beq
    i_A          <= x"F0F0F0F0";
    i_B          <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: o_zero = 0

    -- Test case 33: Testing beq, PASSES
    -- iA = 0xD1D1D1D1, iB = 0xD1D1D1D1, findIsEqual = 1
    ALUCtrl       <= "0000000001"; -- 0 = bne, 1 = beq
    i_A          <= x"D1D1D1D1";
    i_B          <= x"D1D1D1D1";
    wait for gCLK_HPER*2;
    -- Expect: o_zero = 1

    -- Test case 34: Testing bne, FAILS
    -- iA = 0xBABABABA, iB = 0xBABABABA, findIsEqual = 0
    ALUCtrl       <= "0000000000"; -- 0 = bne, 1 = beq
    i_A          <= x"BABABABA";
    i_B          <= x"BABABABA";
    wait for gCLK_HPER*2;
    -- Expect: o_zero = 0

    -- Test case 35: Testing bne, PASSES
    -- iA = 0xFAFAFAFA, iB = 0x01234567, findIsEqual = 0
    ALUCtrl       <= "0000000000"; -- 0 = bne, 1 = beq
    i_A          <= x"FAFAFAFA";
    i_B          <= x"01234567";
    wait for gCLK_HPER*2;
    -- Expect: o_zero = 1



  end process;
end arch;