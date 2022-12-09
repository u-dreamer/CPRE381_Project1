-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_controlUnit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the fetch unit.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_controlUnit is
  generic  (N : integer := 32;
            C : integer := 22;
	    F : integer := 6;
            gCLK_HPER   : time := 10 ns); -- Generic for half of the clock cycle period  
end tb_controlUnit;

architecture arch of tb_controlUnit is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- Component Declaration --------------------------------------------------------------
  component controlUnit is
    port(instr        : in std_logic_vector(N-1 downto 0);
         controlOut   : out std_logic_vector(C-1 downto 0));
end component;

-- SIGNALS ---------------------------------------------------------------------------
signal CLK, reset : std_logic := '0';

-- Initialize inputs to 0
signal s_instr           : std_logic_vector(N-1 downto 0) := x"00000000";
signal s_controlOut      : std_logic_vector(C-1 downto 0);

begin

-- Port/Signal Mapping ------------------------------------------------------
  DUT0: controlUnit
  port map( instr          => s_instr,
            controlOut     => s_controlOut);

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

    -- Test case 0: addi $t5, $zero, 1195
    s_instr         <= x"200D04AB"; -- addi
    wait for gCLK_HPER*2;
    -- Expect: controlOut = 0110001000010000000010

    -- Test case 1: sra $t5, $t5, 1
    s_instr         <= x"000D6843"; -- sra
    wait for gCLK_HPER*2;
    -- Expect: controlOut = 0010011000000000101010

    -- Test case 2: sw $t5, 4($t9)
    s_instr         <= x"AE2D0004"; -- sw
    wait for gCLK_HPER*2;
    -- Expect: controlOut = 0110000000110000000000

  end process;
end arch;