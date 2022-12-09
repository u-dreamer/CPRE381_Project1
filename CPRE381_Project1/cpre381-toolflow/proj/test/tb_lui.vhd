-------------------------------------------------------------------------
-- L8 Sk8rs
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_lui.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the lui MIPS instr.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_lui is
  generic  (gCLK_HPER   : time := 10 ns; -- Generic for half of the clock cycle period
            N : integer := 32);     
end tb_lui;

architecture arch of tb_lui is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- Component Declaration --------------------------------------------------------------
  component lui is
    port(i_B          : in std_logic_vector(N-1 downto 0);
         o_F          : out std_logic_vector(N-1 downto 0));
end component;

-- SIGNALS ---------------------------------------------------------------------------
signal CLK, reset : std_logic := '0';

--Initialize inputs to 0
signal i_B    : std_logic_vector(N-1 downto 0) := x"00000000";
signal o_F    : std_logic_vector(N-1 downto 0) := x"00000000";

begin

-- Port/Signal Mapping ------------------------------------------------------
  DUT0: lui
  port map( i_B     => i_B,
            o_F     => o_F);

-- Clock stuff -----------------------------------------------------------
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
  
-- Test Cases --------------------------------------------------------------
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 0: Upper 8 bits have data
    i_B   <= x"0000FFFF";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0xFFFF0000

    -- Test case 1: Entire word has data
    i_B   <= x"12341111";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x12340000

    -- Test case 2: Entire word has data
    i_B   <= x"00000011";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x00110000

    -- Test case 3: Entire word has data
    i_B   <= x"00001001";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x10010000
  
  end process;
end arch;