-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_MySecondMIPSDataPath.vhd
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

entity tb_MySecondMIPSDataPath is
  generic  (gCLK_HPER   : time := 10 ns; -- Generic for half of the clock cycle period
            N : integer := 32;
            X : integer := 5;
            W : integer := 16);     
end tb_MySecondMIPSDataPath;

architecture arch of tb_MySecondMIPSDataPath is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- Component Declaration --------------------------------------------------------------
  component MySecondMIPSDataPath is
    port(i_CLK        : in std_logic;
         i_RST        : in std_logic;
         WE           : in std_logic;
         nAdd_Sub     : in std_logic;
         ALUSrc       : in std_logic;
         ctrl         : in std_logic;
         WE_mem       : in std_logic;
         LE           : in std_logic;
         rd 	      : in std_logic_vector(X-1 downto 0);
	 rs 	      : in std_logic_vector(X-1 downto 0);
  	 rt           : in std_logic_vector(X-1 downto 0); 
         imm          : in std_logic_vector(W-1 downto 0);
         o_Sum	      : out std_logic_vector(N-1 downto 0);
         o_C          : out std_logic);
end component;

-- SIGNALS ---------------------------------------------------------------------------
signal CLK, reset : std_logic := '0';

-- Initialize inputs to 0
signal s_WE       :  std_logic := '0';
signal s_nAddSub  :  std_logic := '0';
signal s_ALUSrc   :  std_logic := '0';
signal s_ctrl     :  std_logic := '0';
signal s_WEmem    :  std_logic := '0';
signal s_LE       :  std_logic := '0';
signal s_rd       :  std_logic_vector(X-1 downto 0) := "00000";
signal s_rs       :  std_logic_vector(X-1 downto 0) := "00000";
signal s_rt       :  std_logic_vector(X-1 downto 0) := "00000";
signal s_imm      :  std_logic_vector(W-1 downto 0) := x"0000";

signal s_Sum      : std_logic_vector(N-1 downto 0);
signal s_C        : std_logic;

begin

-- Port/Signal Mapping ------------------------------------------------------
  DUT0: MySecondMIPSDataPath
  port map( i_CLK      => CLK,
            i_RST      => reset,
            WE         => s_WE,
            ctrl       => s_ctrl,
            WE_mem     => s_WEmem,
            LE         => s_LE,
            nAdd_Sub   => s_nAddSub,
            ALUSrc     => s_ALUSrc,
            rd         => s_rd,
            rs         => s_rs,
            rt         => s_rt,
            imm        => s_imm,
            o_Sum      => s_Sum,
            o_C        => s_C);
---- Clock Stuff -----------------------------------------------------------
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

-- Test Cases -----------------------------------------------------------------

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges
    wait for gCLK_HPER*2;

    -- Test case 0: addi $0, $0, $0
    s_WE        <= '0';
    s_nAddSub   <= '0';
    s_ALUSrc    <= '0';
    s_ctrl      <= '0';
    s_WEmem     <= '0';
    s_LE        <= '0';
    s_rd        <= "00000";
    s_rs        <= "00000";
    s_rt        <= "00000";
    s_imm       <= x"0000";
    wait for gCLK_HPER*2;
    -- Expect: $0 = 0

    -- Test case 1: addi $25, $0, 0
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '0';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "11001";          -- Dest. Register   # = $25
    s_rs        <= "00000";          -- Source Register  # = $0
    s_rt        <= "00000";          -- 2nd Src Register # = X
    s_imm       <= x"0000";          -- Immediate Value = 0x0000
    wait for gCLK_HPER*2;
    -- Expect: $25 = 0x00000000

    -- Test case 2: addi $26, $0, 256
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '0';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "11010";          -- Dest. Register   # = $26
    s_rs        <= "00000";          -- Source Register  # = $0
    s_rt        <= "00000";          -- 2nd Src Register # = X
    s_imm       <= x"0100";          -- Immediate Value = 256
    wait for gCLK_HPER*2;
    -- Expect: $26 = 0x00000100

    -- Test case 3: lw $1, 0($25)
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '1';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = $1
    s_rs        <= "11001";          -- Source Register  # = $25
    s_rt        <= "00000";          -- 2nd Src Register # = X
    s_imm       <= x"0000";          -- Immediate Value = 0000
    wait for gCLK_HPER*2;
    -- Expect: $1 = A[0] = 0xFFFFFFFF --> Because that's what we have in the file :) 

    -- Test case 4: lw $2, 4($25)
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '1';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00010";          -- Dest. Register   # = $1
    s_rs        <= "11001";          -- Source Register  # = $25
    s_rt        <= "00000";          -- 2nd Src Register # = X
    s_imm       <= x"0004";          -- Immediate Value = 0x0004
    wait for gCLK_HPER*2;
    -- Expect: $2 = A[1] = 0x00000002 --> Because that's what we have in the file :) 


    -- Test case 5: add $1, $1, $2
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '0';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = $1
    s_rs        <= "00001";          -- Source Register  # = $1
    s_rt        <= "00010";          -- 2nd Src Register # = $2
    s_imm       <= x"0000";          -- Immediate Value = X
    wait for gCLK_HPER*2;
    -- Expect: $1 = $1 + $2 = -1 + 2 = 1

    -- Test case 6: sw $1, 0($26)
    s_WE        <= '0';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '0';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '1';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = X
    s_rs        <= "11010";          -- Source Register  # = $26
    s_rt        <= "00001";          -- 2nd Src Register # = $1
    s_imm       <= x"0000";          -- Immediate Value = 0
    wait for gCLK_HPER*2;
    -- Expect: $1 => 0($26) = 0x00000001 @ 64 in mem

    -- Test case 7: lw $2, 8($25)
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '1';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00010";          -- Dest. Register   # = $2
    s_rs        <= "11001";          -- Source Register  # = $25
    s_rt        <= "00001";          -- 2nd Src Register # = X
    s_imm       <= x"0008";          -- Immediate Value = 8
    wait for gCLK_HPER*2;
    -- Expect: $2 <= 8($25) = fffffffd

    -- Test case 8: add $1, $1, $2
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '0';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = $1
    s_rs        <= "00001";          -- Source Register  # = $1
    s_rt        <= "00010";          -- 2nd Src Register # = $2
    s_imm       <= x"0000";          -- Immediate Value = X
    wait for gCLK_HPER*2;
    -- Expect: $1 = $1 + $2 = 0xFFFFFFFE = -2


    -- Test case 9: sw $1, 4($26)
    s_WE        <= '0';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '1';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = X
    s_rs        <= "11010";          -- Source Register  # = $26
    s_rt        <= "00001";          -- 2nd Src Register # = $1
    s_imm       <= x"0004";          -- Immediate Value = 4
    wait for gCLK_HPER*2;
    -- Expect: $1 => 4($26) = FFFF FFFE @ 65 in mem

    -- Test case 10: lw $2, 12($25)
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '1';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00010";          -- Dest. Register   # = $2
    s_rs        <= "11001";          -- Source Register  # = $25
    s_rt        <= "00001";          -- 2nd Src Register # = X
    s_imm       <= x"000C";          -- Immediate Value = 12
    wait for gCLK_HPER*2;
    -- Expect: $2 <= 12($25) = 0x00000004

    -- Test case 11: add $1, $1, $2
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '0';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = $1
    s_rs        <= "00001";          -- Source Register  # = $1
    s_rt        <= "00010";          -- 2nd Src Register # = $2
    s_imm       <= x"0000";          -- Immediate Value = X
    wait for gCLK_HPER*2;
    -- Expect: $1 = $1 + $2 = -2 + 4 = 2

    -- Test case 12: sw $1, 8($26)
    s_WE        <= '0';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '1';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = X
    s_rs        <= "11010";          -- Source Register  # = $26
    s_rt        <= "00001";          -- 2nd Src Register # = $1
    s_imm       <= x"0008";          -- Immediate Value = 4
    wait for gCLK_HPER*2;
    -- Expect: $1 => 8($26) = 2 @ 66 in mem

    -- Test case 13: lw $2, 16($25)
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '1';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00010";          -- Dest. Register   # = $2
    s_rs        <= "11001";          -- Source Register  # = $25
    s_rt        <= "00001";          -- 2nd Src Register # = X
    s_imm       <= x"0010";          -- Immediate Value = 16
    wait for gCLK_HPER*2;
    -- Expect: $2 <= 16($25) = 0x00000005 

    -- Test case 14: add $1, $1, $2
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '0';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = $1
    s_rs        <= "00001";          -- Source Register  # = $1
    s_rt        <= "00010";          -- 2nd Src Register # = $2
    s_imm       <= x"0000";          -- Immediate Value = X
    wait for gCLK_HPER*2;
    -- Expect: $1 = $1 + $2 = 2 + 5 = 7

    -- Test case 15: sw $1, 12($26)
    s_WE        <= '0';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '1';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = X
    s_rs        <= "11010";          -- Source Register  # = $26
    s_rt        <= "00001";          -- 2nd Src Register # = $1
    s_imm       <= x"000C";          -- Immediate Value = 4
    wait for gCLK_HPER*2;
    -- Expect: $1 => 8($26) = 2 @ 66 in mem

    -- Test case 16: lw $2, 20($25)
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '1';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00010";          -- Dest. Register   # = $2
    s_rs        <= "11001";          -- Source Register  # = $25
    s_rt        <= "00001";          -- 2nd Src Register # = X
    s_imm       <= x"0014";          -- Immediate Value = 16
    wait for gCLK_HPER*2;
    -- Expect: $2 <= 20($25) = 0x00000006 

    -- Test case 17: add $1, $1, $2
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '0';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = $1
    s_rs        <= "00001";          -- Source Register  # = $1
    s_rt        <= "00010";          -- 2nd Src Register # = $2
    s_imm       <= x"0000";          -- Immediate Value = X
    wait for gCLK_HPER*2;
    -- Expect: $1 = $1 + $2 = 7 + 6 = 13

    -- Test case 18: sw $1, 16($26)
    s_WE        <= '0';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '1';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = X
    s_rs        <= "11010";          -- Source Register  # = $26
    s_rt        <= "00001";          -- 2nd Src Register # = $1
    s_imm       <= x"000F";          -- Immediate Value = 4
    wait for gCLK_HPER*2;
    -- Expect: $1 => 16($26) = 13 @ 260 in mem

    -- Test case 19: lw $2, 24($25)
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '1';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00010";          -- Dest. Register   # = $2
    s_rs        <= "11001";          -- Source Register  # = $25
    s_rt        <= "00001";          -- 2nd Src Register # = X
    s_imm       <= x"0018";          -- Immediate Value = 16
    wait for gCLK_HPER*2;
    -- Expect: $2 <= 24($25) = fffffff9 

    -- Test case 20: add $1, $1, $2
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '0';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = $1
    s_rs        <= "00001";          -- Source Register  # = $1
    s_rt        <= "00010";          -- 2nd Src Register # = $2
    s_imm       <= x"0000";          -- Immediate Value = X
    wait for gCLK_HPER*2;
    -- Expect: $1 = $1 + $2 = 13 + -7 = 6

   -- Test case 21: addi $27, $0, 512
    s_WE        <= '1';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '0';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '0';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "11011";          -- Dest. Register   # = $27
    s_rs        <= "00000";          -- Source Register  # = $0
    s_rt        <= "00000";          -- 2nd Src Register # = X
    s_imm       <= x"0200";          -- Immediate Value = 0x0000
    wait for gCLK_HPER*2;
    -- Expect: $27 = 0x00000200 = 512

    -- Test case 18: sw $1, -4($27)
    s_WE        <= '0';              -- Write Enable to Reg File: Disable(0)/Enable(1)
    s_nAddSub   <= '0';              -- Add(0)/Subtract(1)
    s_ALUSrc    <= '1';              -- iB Control: rt(0)/imm(1)
    s_ctrl      <= '1';              -- Extension Control: Zero(0)/Sign(1)
    s_WEmem     <= '1';              -- Write Memory Control: Disable(0)/Enable(1)
    s_LE        <= '0';              -- Load Enable: o_Sum(0)/q_val(1)
    s_rd        <= "00001";          -- Dest. Register   # = X
    s_rs        <= "11011";          -- Source Register  # = $27
    s_rt        <= "00001";          -- 2nd Src Register # = $1
    s_imm       <= x"FFFC";          -- Immediate Value = 4
    wait for gCLK_HPER*2;
    -- Expect: $1 => -4($27) == 508 => 6 @ 255 in mem

  end process;
end arch;