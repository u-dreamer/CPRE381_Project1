-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_adder_N.vhd
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

entity tb_adder_N is
  generic  (gCLK_HPER   : time := 10 ns; -- Generic for half of the clock cycle period
            N : integer := 32);     
end tb_adder_N;

architecture arch of tb_adder_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
  component adder_N is
    port(iCLK         : in std_logic;
         i_A          : in std_logic_vector(N-1 downto 0);
         i_B          : in std_logic_vector(N-1 downto 0);
         i_C          : in std_logic;
         o_S	      : out std_logic_vector(N-1 downto 0);
         o_C          : out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
-- Initialize inputs to 0
signal s_Ci    : std_logic := '0';
signal s_A     : std_logic_vector(N-1 downto 0) := x"00000000";
signal s_B     : std_logic_vector(N-1 downto 0) := x"00000000";

signal s_S     : std_logic_vector(N-1 downto 0) := x"00000000";
signal s_Co    : std_logic := '0';

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: adder_N
  port map( iCLK    => CLK,
            i_C     => s_Ci,
            i_A     => s_A,
            i_B     => s_B,
            o_S     => s_S,
            o_C     => s_Co);
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

    -- Test case 1: Set everything to 0
    -- Test Ci = 0, A = 0x0000, B = 0x0000
    s_Ci  <= '0';
    s_A   <= x"00000000";
    s_B   <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: o_S =  = 0

    -- Test case 2: Test to see if carrying works
    -- Test Ci = 0, A = 0x0000, B = 0x0000
    s_Ci  <= '1';
    s_A   <= x"00000000";
    s_B   <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: o_O = 0x00000001

    -- Test case 3: Really simple addition
    -- Test Ci = 0, A = 0x0000, B = 0x0000
    s_Ci  <= '0';
    s_A   <= x"00000001";
    s_B   <= x"00000001";
    wait for gCLK_HPER*2;
    -- Expect: o_O = 0x00000002


    -- Test case 4: Simple addition
    -- Test Ci = 0, A = 0x00FFFFFF, B = 0x00FFFFFF
    s_Ci  <= '0';
    s_A   <= x"00000004";
    s_B   <= x"00000004";
    wait for gCLK_HPER*2;
    -- Expect: o_O =  = 0x00000008

    -- Test case 5: See if s_C is working ://
    -- Test Ci = 0, A = 0x00FFFFFF, B = 0x00FFFFFF
    s_Ci  <= '0';
    s_A   <= x"0000000F";
    s_B   <= x"0000000F";
    wait for gCLK_HPER*2;
    -- Expect: o_O =  = 0x0000001E


  end process;
end arch;