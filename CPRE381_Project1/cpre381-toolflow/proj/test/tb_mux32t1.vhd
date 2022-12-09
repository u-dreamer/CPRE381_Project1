------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_mux32t1.vhd
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
entity tb_mux32t1 is
  generic (gCLK_HPER   : time := 10 ns;
	   N : integer := 32); -- Generic for half of the clock cycle period;     
end tb_mux32t1;

architecture arch of tb_mux32t1 is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- Define the component.
  component mux32t1 is
    port(i_S    : in  std_logic_vector(4 downto 0);
	 D0     : in  std_logic_vector(31 downto 0);
	 D1     : in  std_logic_vector(31 downto 0);
	 D2     : in  std_logic_vector(31 downto 0);
	 D3     : in  std_logic_vector(31 downto 0);
	 D4     : in  std_logic_vector(31 downto 0);
	 D5     : in  std_logic_vector(31 downto 0);
	 D6     : in  std_logic_vector(31 downto 0);
	 D7     : in  std_logic_vector(31 downto 0);
	 D8     : in  std_logic_vector(31 downto 0);
	 D9     : in  std_logic_vector(31 downto 0);
	 D10    : in  std_logic_vector(31 downto 0);
	 D11    : in  std_logic_vector(31 downto 0);
	 D12    : in  std_logic_vector(31 downto 0);
	 D13    : in  std_logic_vector(31 downto 0);
	 D14    : in  std_logic_vector(31 downto 0);
	 D15    : in  std_logic_vector(31 downto 0);
	 D16    : in  std_logic_vector(31 downto 0);
	 D17    : in  std_logic_vector(31 downto 0);
	 D18    : in  std_logic_vector(31 downto 0);
	 D19    : in  std_logic_vector(31 downto 0);
	 D20    : in  std_logic_vector(31 downto 0);
	 D21    : in  std_logic_vector(31 downto 0);
	 D22    : in  std_logic_vector(31 downto 0);
	 D23    : in  std_logic_vector(31 downto 0);
	 D24    : in  std_logic_vector(31 downto 0);
	 D25    : in  std_logic_vector(31 downto 0);
	 D26    : in  std_logic_vector(31 downto 0);
	 D27    : in  std_logic_vector(31 downto 0);
	 D28    : in  std_logic_vector(31 downto 0);
	 D29    : in  std_logic_vector(31 downto 0);
	 D30    : in  std_logic_vector(31 downto 0);
	 D31    : in  std_logic_vector(31 downto 0);
         F_OUT  : out std_logic_vector(N-1 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
--Initialize inputs to 0
signal s_S      : std_logic_vector(4 downto 0)   := "00000";
signal s_D0     : std_logic_vector(31 downto 0) := x"00000000";
signal s_D1     : std_logic_vector(31 downto 0) := x"00000001";
signal s_D2     : std_logic_vector(31 downto 0) := x"00000002";
signal s_D3     : std_logic_vector(31 downto 0) := x"00000003";
signal s_D4     : std_logic_vector(31 downto 0) := x"00000004";
signal s_D5     : std_logic_vector(31 downto 0) := x"00000005";
signal s_D6     : std_logic_vector(31 downto 0) := x"00000006";
signal s_D7     : std_logic_vector(31 downto 0) := x"00000007";
signal s_D8     : std_logic_vector(31 downto 0) := x"00000008";
signal s_D9     : std_logic_vector(31 downto 0) := x"00000009";
signal s_D10    : std_logic_vector(31 downto 0) := x"0000000A";
signal s_D11    : std_logic_vector(31 downto 0) := x"0000000B";
signal s_D12    : std_logic_vector(31 downto 0) := x"0000000C";
signal s_D13    : std_logic_vector(31 downto 0) := x"0000000D";
signal s_D14    : std_logic_vector(31 downto 0) := x"0000000E";
signal s_D15    : std_logic_vector(31 downto 0) := x"0000000F";
signal s_D16    : std_logic_vector(31 downto 0) := x"00000010";
signal s_D17    : std_logic_vector(31 downto 0) := x"00000020";
signal s_D18    : std_logic_vector(31 downto 0) := x"00000030";
signal s_D19    : std_logic_vector(31 downto 0) := x"00000040";
signal s_D20    : std_logic_vector(31 downto 0) := x"00000050";
signal s_D21    : std_logic_vector(31 downto 0) := x"00000060";
signal s_D22    : std_logic_vector(31 downto 0) := x"00000070";
signal s_D23    : std_logic_vector(31 downto 0) := x"00000080";
signal s_D24    : std_logic_vector(31 downto 0) := x"00000090";
signal s_D25    : std_logic_vector(31 downto 0) := x"000000A0";
signal s_D26    : std_logic_vector(31 downto 0) := x"000000B0";
signal s_D27    : std_logic_vector(31 downto 0) := x"000000C0";
signal s_D28    : std_logic_vector(31 downto 0) := x"000000D0";
signal s_D29    : std_logic_vector(31 downto 0) := x"000000E0";
signal s_D30    : std_logic_vector(31 downto 0) := x"000000F0";
signal s_D31    : std_logic_vector(31 downto 0) := x"00000100";
signal s_FOUT   : std_logic_vector(N-1 downto 0):= x"00000000";

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: mux32t1
  port map( i_S => s_S,   
	    D0  => s_D0,  
	    D1  => s_D1,
	    D2  => s_D2,
	    D3  => s_D3,
	    D4  => s_D4,
	    D5  => s_D5,
	    D6  => s_D6,
	    D7  => s_D7,
	    D8  => s_D8,
	    D9  => s_D9,
	    D10 => s_D10,
	    D11 => s_D11, 
	    D12 => s_D12,
	    D13 => s_D13, 
	    D14 => s_D14, 
	    D15 => s_D15,
	    D16 => s_D16,  
	    D17 => s_D17, 
	    D18 => s_D18,   
	    D19 => s_D19,  
	    D20 => s_D20,  
	    D21 => s_D21,  
	    D22 => s_D22, 
	    D23 => s_D23,  
	    D24 => s_D24,
	    D25 => s_D25,
	    D26 => s_D26,
	    D27 => s_D27,
	    D28 => s_D28, 
	    D29 => s_D29,  
	    D30 => s_D30,
	    D31 => s_D31,
            F_OUT => s_FOUT);

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
    -- Test s_S = 00000
    s_S   <= "00000";
    wait for gCLK_HPER*2;
    -- Expect: FOUT = D0 = x00000000

    -- Test case 2:
    -- Test s_S = 00100
    s_S   <= "00100";
    wait for gCLK_HPER*2;
    -- Expect: FOUT = D4 = x00000004
  
    -- Test case 3:
    -- Test s_S = 01111
    s_S   <= "01111";
    wait for gCLK_HPER*2;
    -- Expect: F_OUT = D15 = x0000000F  
   
    -- Test case 4:
    -- Test s_S = 11111
    s_S   <= "11111";
    wait for gCLK_HPER*2;
    -- Expect: F_OUT = D31 = x00000100  
 
  end process;
end arch;