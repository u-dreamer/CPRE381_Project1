-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_MIPS_Reg_File1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the testbench for a 
-- 		MIPS 32-bit register file with 2 read ports, and 1 
--		write port
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_MIPS_Reg_File1 is
  generic(gCLK_HPER   : time := 10 ns;   -- Generic for half of the clock cycle period
	  N : integer := 32;
          X : integer := 5); 
end tb_MIPS_Reg_File1;

architecture mixed of tb_MIPS_Reg_File1 is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

component MIPS_Reg_File1 is
  generic(N : integer := 32);
  port (i_CLK	  : in std_logic;
	i_RST     : in std_logic;
	WE        : in std_logic;
	i_D       : in std_logic_vector(N-1 downto 0);
        rd 	  : in std_logic_vector(X-1 downto 0);
	rs 	  : in std_logic_vector(X-1 downto 0);
  	rt        : in std_logic_vector(X-1 downto 0);
	rs_val    : out std_logic_vector(N-1 downto 0);
	rt_val    : out std_logic_vector(N-1 downto 0));	
end component;

-- Clock Signal stuff! ------------------------------------------------
signal CLK, reset : std_logic := '0';
-- Initialize I/O signals to 0 ----------------------------------------
signal s_WE      : std_logic := '0';
signal s_rd      : std_logic_vector(X-1 downto 0) := "00000";
signal s_rs      : std_logic_vector(X-1 downto 0) := "00000";
signal s_rt      : std_logic_vector(X-1 downto 0) := "00000";
signal s_D       : std_logic_vector(N-1 downto 0) := x"00000000";
signal s_rs_val  : std_logic_vector(N-1 downto 0);
signal s_rt_val  : std_logic_vector(N-1 downto 0);	
-----------------------------------------------------------------------

begin 

  DUT0: MIPS_Reg_File1
  port map(
            i_CLK    => CLK,
	    i_RST    => reset,
            WE       => s_WE,
            i_D      => s_D,
            rd       => s_rd,
            rs       => s_rs,
            rt       => s_rt,
            rs_val   => s_rs_val,
            rt_val   => s_rt_val);

--------------------------------------------------------------------

-- Setup the clock for the test bench
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

-- TEST CASES ------------------------------------------------------

 -- Assign inputs for each test case.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1: Write to Register 0 / See if decoder enables write??
    s_WE  <= '1'; -- Tell it to select position 0 for output
    s_D   <= x"FFFFFFFF";
    s_rd  <= "00000";
    s_rs  <= "00000";
    s_rt  <= "00000";
    wait for gCLK_HPER*2;
    wait for gCLK_HPER*2;
    -- Expect: rs_val = 0xFFFFFFFF, rt_val = 0xFFFFFFFF

    -- Test case 2: Write to Register 1 / Read from $0 and $1
    s_WE  <= '1'; -- Tell it to select position 0 for output
    s_D   <= x"ABCDEFAB";
    s_rd  <= "00001";
    s_rs  <= "00000";
    s_rt  <= "00001";
    wait for gCLK_HPER*2;
    -- Expect: rs_val = 0xFFFFFFFF, rt_val = 0xABCDEFAB

    -- Test case 3: Write 0 into $0
    s_WE  <= '1'; -- Tell it to select position 0 for output
    s_D   <= x"00000000";
    s_rd  <= "00000";
    s_rs  <= "00000";
    s_rt  <= "00001";
    wait for gCLK_HPER*2;
    -- Expect: rs_val = 0x00000000, rt_val = 0xABCDEFAB

    -- Test case 4: Write into $32
    s_WE  <= '1'; -- Tell it to select position 0 for output
    s_D   <= x"00000000";
    s_rd  <= "11111";
    s_rs  <= "00000";
    s_rt  <= "00001";
    wait for gCLK_HPER*2;
    -- Expect: rs_val = 0x00000000, rt_val = 0xABCDEFAB

  end process;
end mixed;


