-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_decoder5to32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the 2-to-1 mux
--              
-- 09/05/2022
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_decoder5to32 is
  generic  (gCLK_HPER   : time := 10 ns; -- Generic for half of the clock cycle period
            N : integer := 32);     
end tb_decoder5to32;

architecture arch of tb_decoder5to32 is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
  component decoder5to32 is
    port(D_IN           : in std_logic_vector(4 downto 0);
         F_OUT          : out std_logic_vector(N-1 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
--Initialize inputs to 0
signal s_Din     : std_logic_vector(4 downto 0) := "00000";
signal s_Fout    : std_logic_vector(N-1 downto 0) := x"00000000";

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: decoder5to32
  port map( D_IN      => s_Din,
            F_OUT     => s_Fout);

  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    -- Test s_Din = 00010
    s_Din   <= "00010";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x00000004

    -- Test case 2:
    -- Test s_Din = 01000
    s_Din   <= "01000";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x00000100 
  
    -- Test case 3:
    -- Test s_Din = 11111
    s_Din   <= "11111";
    wait for gCLK_HPER*2;
    -- Expect: o_F = 0x80000000 
 
  end process;
end arch;