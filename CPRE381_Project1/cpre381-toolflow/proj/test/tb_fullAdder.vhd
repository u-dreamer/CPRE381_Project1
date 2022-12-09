-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_fullAdder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the fullAdder.vhd
--              
-- 09/06/2022
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_fullAdder is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_fullAdder;

architecture mixed of tb_fullAdder is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component fullAdder is
  port(iCLK         : in std_logic;
       i_A          : in std_logic;
       i_B          : in std_logic;
       i_C          : in std_logic;
       o_S	    : out std_logic;
       o_C          : out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
--Initialize inputs to 0
signal s_iA   : std_logic := '0';
signal s_iB   : std_logic := '0';
signal s_iC   : std_logic := '0';
signal s_oS   : std_logic := '0';
signal s_oC   : std_logic := '0';

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: fullAdder
  port map( iCLK    => CLK,
	    i_A     => s_iA,
            i_B     => s_iB,
            i_C     => s_iC,
            o_S     => s_oS,
            o_C     => s_oC);
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
    -- Test iA = 0, iB = 0, iC = 1
    s_iA    <= '0';
    s_iB    <= '0';
    s_iC    <= '1'; 
    wait for gCLK_HPER*2;
    -- Expect: oS = 1; oC = 0

    -- Test case 2:
    -- Test iA = 0, iB = 1, iC = 0
    s_iA    <= '0';
    s_iB    <= '0';
    s_iC    <= '0'; 
    wait for gCLK_HPER*2;
    -- Expect: oS = 1; oC = 0

    -- Test case 3:
    -- Test iA = 0, iB = 1, iC = 1
    --s_iA    <= '0';
    --s_iB    <= '1';
    --s_iC    <= '1'; 
    --wait for gCLK_HPER*2;
    -- Expect: oS = 0; oC = 1



  end process;

end mixed;