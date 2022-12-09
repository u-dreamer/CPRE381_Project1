-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_MIPS_Reg_AdderSub.1vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the N-bit adder-subtractor
--              
-- 09/06/2022
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_MIPS_Reg_AdderSub is
  generic  (gCLK_HPER   : time := 10 ns; -- Generic for half of the clock cycle period
            N : integer := 32;
            X : integer := 5);     
end tb_MIPS_Reg_AdderSub;

architecture arch of tb_MIPS_Reg_AdderSub is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- Component Declaration --------------------------------------------------------------
  component MIPS_Reg_AdderSub1 is
    port(i_CLK        : in std_logic;
         i_RST        : in std_logic;
         WE           : in std_logic;
         nAdd_Sub     : in std_logic;
         ALUSrc       : in std_logic;
         rd 	      : in std_logic_vector(X-1 downto 0);
	 rs 	      : in std_logic_vector(X-1 downto 0);
  	 rt           : in std_logic_vector(X-1 downto 0); 
         imm          : in std_logic_vector(N-1 downto 0);
         o_Sum	      : out std_logic_vector(N-1 downto 0);
         o_C          : out std_logic);
end component;

-- SIGNALS ---------------------------------------------------------------------------
signal CLK, reset : std_logic := '0';

-- Initialize inputs to 0
signal s_WE       :  std_logic := '0';
signal s_nAddSub  :  std_logic := '0';
signal s_ALUSrc   :  std_logic := '0';
signal s_rd       :  std_logic_vector(X-1 downto 0) := "00000";
signal s_rs       :  std_logic_vector(X-1 downto 0) := "00000";
signal s_rt       :  std_logic_vector(X-1 downto 0) := "00000";
signal s_imm      :  std_logic_vector(N-1 downto 0) := x"00000000";

signal o_Sum      : std_logic_vector(N-1 downto 0);
signal o_C        : std_logic;

begin

-- Port/Signal Mapping ------------------------------------------------------
  DUT0: MIPS_Reg_AdderSub1
  port map( i_CLK      => CLK,
            i_RST      => reset,
            WE         => s_WE,
            nAdd_Sub   => s_nAddSub,
            ALUSrc     => s_ALUSrc,
            rd         => s_rd,
            rs         => s_rs,
            rt         => s_rt,
            imm        => s_imm);
---- Clock stuff -----------------------------------------------------------
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
-------------------------------------------------------------------------------

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges
    wait for gCLK_HPER*2;

    -- Test case 1: Place "1" in $1
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "00001";      -- Destination Register = $1
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"00000001";  -- imm = 1
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000001 -> $1 = 0x00000001

    -- Test case 2: Place "2" in $2
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "00010";      -- Destination Register = $2
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"00000002";  -- imm = 2
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000002 -> $2 = 0x00000002

    -- Test case 3: Place "3" in $3
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "00011";      -- Destination Register = $3
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"00000003";  -- imm = 3
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000003 -> $3 = 0x00000003

    -- Test case 4: Place "4" in $4
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "00100";      -- Destination Register = $4
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"00000004";  -- imm = 4
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000004 -> $4 = 0x00000004

    -- Test case 5: Place "5" in $5
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "00101";      -- Destination Register = $5
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"00000005";  -- imm = 5
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000005 -> $5 = 0x00000005

    -- Test case 6: Place "6" in $6
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "00110";      -- Destination Register = $6
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"00000006";  -- imm = 6
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000006 -> $3 = 0x00000006

    -- Test case 7: Place "7" in $7
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "00111";      -- Destination Register = $7
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"00000007";  -- imm = 7
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000007 -> $7 = 0x00000007

    -- Test case 8: Place "8" in $8
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "01000";      -- Destination Register = $8
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"00000008";  -- imm = 8
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000008 -> $8 = 0x00000008

    -- Test case 9: Place "9" in $9
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "01001";      -- Destination Register = $9
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"00000009";  -- imm = 9
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000009 -> $9 = 0x00000009

    -- Test case 10: Place "10" in $10
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "01010";      -- Destination Register = $10
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"0000000A";  -- imm = 10
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x0000000A -> $10 = 0x0000000A

    -- Test case 11: $11 = $1 + $2
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "01011";      -- Destination Register = $11
    s_rs        <= "00001";      -- Source Register = $1
    s_rt        <= "00010";      -- Secondary Source Register = $2 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '0';          -- B != imm  
    s_imm       <= x"FFFFFFFF";  -- imm = X
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000003 -> $11 = 0x00000003

    -- Test case 12: $12 = $11 - $3
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "01100";      -- Destination Register = $12
    s_rs        <= "01011";      -- Source Register = $11
    s_rt        <= "00011";      -- Secondary Source Register = $3 
    s_nAddSub   <= '1';          -- A - B
    s_ALUSrc    <= '0';          -- B != imm  
    s_imm       <= x"FFFFFFFF";  -- imm = X
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000003 - 3 = 0 -> $12 = 0x00000000

    -- Test case 13: $13 = $12 + $4
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "01101";      -- Destination Register = $13
    s_rs        <= "01100";      -- Source Register = $12
    s_rt        <= "00100";      -- Secondary Source Register = $4
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '0';          -- B != imm  
    s_imm       <= x"FFFFFFFF";  -- imm = X
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000000 + 4 = 4 -> $13 = 0x00000004

    -- Test case 14: $14 = $13 - $5
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "01110";      -- Destination Register = $14
    s_rs        <= "01101";      -- Source Register = $13
    s_rt        <= "00101";      -- Secondary Source Register = $5 
    s_nAddSub   <= '1';          -- A - B
    s_ALUSrc    <= '0';          -- B != imm  
    s_imm       <= x"FFFFFFFF";  -- imm = X
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000004 - 5 = 0 -> $14 = -1 = 0xFFFFFFFF

    -- Test case 15: $15 = $14 + $6
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "01111";      -- Destination Register = $15
    s_rs        <= "01110";      -- Source Register = $14
    s_rt        <= "00110";      -- Secondary Source Register = $6
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '0';          -- B != imm  
    s_imm       <= x"FFFFFFFF";  -- imm = X
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = -1 + 6 = 4 -> $15 = 0x00000005

    -- Test case 16: $16 = $15 - 7
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "10000";      -- Destination Register = $16
    s_rs        <= "01111";      -- Source Register = $15
    s_rt        <= "00111";      -- Secondary Source Register = $7
    s_nAddSub   <= '1';          -- A - B
    s_ALUSrc    <= '0';          -- B != imm  
    s_imm       <= x"FFFFFFFF";  -- imm = X
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 5 - 7 = -2 -> $16 = 0xFFFFFFFE

    -- Test case 17: $17 = $16 + $8
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "10001";      -- Destination Register = $17
    s_rs        <= "10000";      -- Source Register = $16
    s_rt        <= "01000";      -- Secondary Source Register = $8
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '0';          -- B != imm  
    s_imm       <= x"FFFFFFFF";  -- imm = X
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = -2 + 8 = 6 -> $17 = 0x00000006

    -- Test case 18: $18 = $17 - $9
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "10010";      -- Destination Register = $18
    s_rs        <= "10001";      -- Source Register = $17
    s_rt        <= "01001";      -- Secondary Source Register = $9
    s_nAddSub   <= '1';          -- A - B
    s_ALUSrc    <= '0';          -- B != imm  
    s_imm       <= x"FFFFFFFF";  -- imm = X
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 6 - 9 = -3 -> $18 = 0xFFFFFFFD

    -- Test case 19: $19 = $18 + $10
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "10011";      -- Destination Register = $19
    s_rs        <= "10010";      -- Source Register = $18
    s_rt        <= "01010";      -- Secondary Source Register = $10
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '0';          -- B != imm  
    s_imm       <= x"FFFFFFFF";  -- imm = X
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = -3 + 10 -> $19 = 0x00000007

    -- Test case 20: $20 = $0 - 35
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "10100";      -- Destination Register = $20
    s_rs        <= "00000";      -- Source Register = $0
    s_rt        <= "11111";      -- Secondary Source Register = X 
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '1';          -- B = imm  
    s_imm       <= x"FFFFFFDD";  -- imm = -35
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = -35 => $20 = 0xFFFFFFDD = -35

    -- Test case 21: $21 = $19 + $20
    -- 
    s_WE        <= '1';          -- Enable write
    s_rd        <= "10101";      -- Destination Register = $21
    s_rs        <= "10011";      -- Source Register = $19
    s_rt        <= "10100";      -- Secondary Source Register = $20
    s_nAddSub   <= '0';          -- A + B
    s_ALUSrc    <= '0';          -- B != imm  
    s_imm       <= x"FFFFFFFF";  -- imm = X
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 7 + -35 = -28 -> $17 = 0xFFFFFFE4

  end process;
end arch;