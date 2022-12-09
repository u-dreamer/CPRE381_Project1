-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_adderSub_N.vhd
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

entity tb_addSub_N is
  generic  (gCLK_HPER   : time := 10 ns; -- Generic for half of the clock cycle period
            N : integer := 32);     
end tb_addSub_N;

architecture arch of tb_addSub_N is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
  component adderSub_N is
    port(iCLK         : in std_logic;
         iA           : in std_logic_vector(N-1 downto 0);
         iB           : in std_logic_vector(N-1 downto 0);
         imm          : in std_logic_vector(N-1 downto 0);
         ALUSrc       : in std_logic;
         nAdd_Sub     : in std_logic;
         o_Sum	      : out std_logic_vector(N-1 downto 0);
         o_C          : out std_logic);
end component;

-- SIGNALS--
-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- Initialize inputs and outputs to 0
signal s_iA       :  std_logic_vector(N-1 downto 0);
signal s_iB       :  std_logic_vector(N-1 downto 0);
signal s_nAddSub  :  std_logic;
signal s_imm      :  std_logic_vector(N-1 downto 0);
signal s_ALUSrc   :  std_logic;

signal s_So       :  std_logic_vector(N-1 downto 0);
signal s_Co       :  std_logic;

begin

---------------------------------------------------------------------------
  DUT0: adderSub_N
  port map( iCLK       => CLK,
            nAdd_Sub   => s_nAddSub,
            iA         => s_iA,
            iB         => s_iB,
            imm        => s_imm,
            ALUSrc     => s_ALUSrc,
            o_Sum      => s_So,
            o_C        => s_Co);
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

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 0: Set everything to 0
    -- Test nAdd_Sub = 0, ALUSrc = 0, iA = 0, iB = 0, imm = 0x00000000
    s_nAddSub  <= '0';
    s_ALUSrc   <= '0';
    s_iA       <= x"00000000";
    s_iB       <= x"00000000";
    s_imm      <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000000

    -- Test case 1: Sum <= A + B
    -- Test nAdd_Sub = 0, ALUSrc = 1, iA = 1, iB = 1, imm = 0
    s_nAddSub  <= '0';
    s_ALUSrc   <= '0';
    s_iA       <= x"00000001";
    s_iB       <= x"00000001";
    s_imm      <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000002

    -- Test case 2: Sum <= A + imm
    -- Test nAdd_Sub = 0, ALUSrc = 1, iA = 1, iB = 1, imm = 5
    s_nAddSub  <= '0';
    s_ALUSrc   <= '1';
    s_iA       <= x"00000001";
    s_iB       <= x"00000002";
    s_imm      <= x"00000005";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000006

    -- Test case 3: Sum = A - B
    -- Test nAdd_Sub = 0, ALUSrc = 1, iA = 1, iB = 3, imm = 0
    s_nAddSub  <= '1';
    s_ALUSrc   <= '0';
    s_iA       <= x"00000003";
    s_iB       <= x"00000001";
    s_imm      <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000002

    -- Test case 4: Sum = A - imm
    -- Test nAdd_Sub = 0, ALUSrc = 1, iA = 4, iB = 2, imm = 1
    s_nAddSub  <= '1';
    s_ALUSrc   <= '1';
    s_iA       <= x"00000004";
    s_iB       <= x"00000002";
    s_imm      <= x"00000001";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0x00000003

----Test Performance when working with signed nums ----------------------------

    -- Test case 4: Sum = A + B
    -- Test nAdd_Sub = 0, ALUSrc = 1, iA = -15, iB = 2, imm = 1
    s_nAddSub  <= '0';
    s_ALUSrc   <= '0';
    s_iA       <= x"FFFFFFF1"; -- -15
    s_iB       <= x"00000002"; -- + 2
    s_imm      <= x"00000001";
    wait for gCLK_HPER*2;
    -- Expect: o_Sum = 0xFFFFFFF3 = -13


  end process;
end arch;
