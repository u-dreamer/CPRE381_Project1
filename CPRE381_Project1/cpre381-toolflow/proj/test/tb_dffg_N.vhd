-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_dffg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the N-bit full adder
--              
-- 09/06/2022
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_dffg_N is
  generic  (gCLK_HPER   : time := 10 ns; -- Generic for half of the clock cycle period
            N : integer := 32);     
end tb_dffg_N;

architecture arch of tb_dffg_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
  component dffg_N is
    port(i_CLK        : in std_logic;  -- Clock input
         i_RST        : in std_logic;   -- Reset input
         i_WE         : in std_logic;   -- Write enable input
         i_D          : in std_logic_vector(N-1 downto 0);   -- Data value input
         o_Q	      : out std_logic_vector(N-1 downto 0));  -- Data value output
end component;


-- Initialize inputs to 0
signal s_CLK   : std_logic  := '0';
signal s_RST   : std_logic  := '0';

signal s_WE    : std_logic  := '0';
signal s_D     : std_logic_vector(N-1 downto 0) := x"00000000";

-- Initialize outputs to 0
signal s_Q     : std_logic_vector(N-1 downto 0) := x"00000000";

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: dffg_N
  port map( i_CLK   => s_CLK,
            i_RST   => s_RST,
            i_WE    => s_WE,
            i_D     => s_D,
            o_Q     => s_Q);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html
  --This first process is to setup the clock for the test bench

  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

 -- Test case 1: Test write enable as off but D = 1
    -- Test WE = 0, RST = 0, D = 0x00000001
    s_WE  <= '0';
    s_RST   <= '0';
    s_D   <= x"00000001";
    wait for gCLK_HPER*2;
    -- Expect: o_Q = 0x00000001

    -- Test case 2: Set everything to 0
    -- Test WE = 0, RST = 0, D = 0x00000000
    s_WE  <= '1';
    s_RST   <= '0';
    s_D   <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: o_Q = 0x00000000

    -- Test case 3: Test with non-zero
    -- Test WE = 0, RST = 0, D = 0x00000000
    s_WE  <= '1';
    s_RST   <= '0';
    s_D   <= x"00000003";
    wait for gCLK_HPER*2;
    -- Expect: o_Q = 0x00000000

    -- Test case 4: Test with non-zero but WE = 0
    -- Test WE = 0, RST = 0, D = 0x00000000
    s_WE  <= '0';
    s_RST   <= '0';
    s_D   <= x"00000003";
    wait for gCLK_HPER*2;
    -- Expect: o_Q = 0x00000000

    -- Test case 5: Test reset with WE = 0
    -- Test WE = 0, RST = 0, D = 0x00000000
    s_WE  <= '0';
    s_RST   <= '1';
    s_D   <= x"00000005";
    wait for gCLK_HPER*2;
    -- Expect: o_Q = 0x00000000

    -- Test case 6: Test reset with WE = 1
    -- Test WE = 0, RST = 0, D = 0x00000000
    s_WE  <= '1';
    s_RST   <= '1';
    s_D   <= x"00000005";
    wait for gCLK_HPER*2;
    -- Expect: o_Q = 0x00000000

  end process;
end arch;