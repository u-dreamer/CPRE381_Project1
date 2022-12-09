-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_barrelShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file is the testbench for a barrel shifter
--  	        to implement MIPS instructions srl, sra, and sll.
--              
-- 10//2022
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_barrelShifter is
  generic  (gCLK_HPER   : time := 10 ns; -- Generic for half of the clock cycle period
            N : integer := 32;
            S : integer := 5);     
end tb_barrelShifter;

architecture arch of tb_barrelShifter is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- Component Declaration --------------------------------------------------------------
  component barrelShifter is
    port(i_D            : in std_logic_vector(N-1 downto 0);
         shamt 	        : in std_logic_vector(S-1 downto 0);
         signKeep       : in std_logic;
         dir            : in std_logic;			    -- 0 = right, 1 = left
         o_Q            : out std_logic_vector(N-1 downto 0));
end component;

-- SIGNALS ---------------------------------------------------------------------------
signal CLK, reset : std_logic := '0';

-- Initialize inputs to 0
signal s_iD           : std_logic_vector(N-1 downto 0) := x"00000000";
signal s_shamt        : std_logic_vector(S-1 downto 0) :=  "00000";
signal s_oQ           : std_logic_vector(N-1 downto 0);
signal s_signKeep     : std_logic := '0';
signal s_dir          : std_logic := '0';


begin

-- Port/Signal Mapping ------------------------------------------------------
  DUT0: barrelShifter
  port map( i_D          => s_iD,
            shamt        => s_shamt,
	    signKeep     => s_signKeep,
	    dir          => s_dir,
	    o_Q          => s_oQ);

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
--------------------------------------------------------------------------------
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges
    wait for gCLK_HPER*2;

  -- Test case 0: Let inital value pass through
  s_iD        <= x"0000FFFF";      
  s_shamt     <= "00000";    	-- shift 0 bits 
  s_signKeep  <= '0';		-- when shift = 0, = don't care
  s_dir       <= '0';		-- when shift = 0, = don't care
  wait for gCLK_HPER*2;
  -- Expect: oQ = 0x0000FFFF

  -- Test case 1: Test sll
  s_iD     <= x"0000FFFF";      
  s_shamt  <= "00111";    	-- shift 7 bits 
  s_signKeep  <= '0';		-- 0 = don't preserve sign
  s_dir       <= '1';		-- 1 = shift left
  wait for gCLK_HPER*2;
  -- Expect: oQ = 0x0007FF80

  -- Test case 2: Test srl
  s_iD     <= x"0000FFFF";      
  s_shamt  <= "11111";    	-- shift 31 bits 
  s_signKeep  <= '0';		-- 0 = don't preserve sign
  s_dir       <= '0';		-- 1 = shift right
  wait for gCLK_HPER*2;
  -- Expect: oQ = 0x00000000

  -- Test case 3: Test sra
  s_iD     <= x"0000FFFF";      
  s_shamt  <= "00011";    	-- shift 3 bits 
  s_signKeep  <= '1';		-- 1 = preserve sign
  s_dir       <= '0';		-- 0 = shift right
  wait for gCLK_HPER*2;
  -- Expect: oQ = 0x00001FFF

  -- Test case 4: Test sra when sign bit = 1
  s_iD     <= x"8000FFFF";      
  s_shamt  <= "00011";    	-- shift 3 bits 
  s_signKeep  <= '1';		-- 1 = preserve sign
  s_dir       <= '0';		-- 0 = shift right
  wait for gCLK_HPER*2;
  -- Expect: oQ = 0xf0001fff

  -- Test case 5: Test sll (when signKeep = 1)
  s_iD     <= x"0000FFFF";      
  s_shamt  <= "00111";    	-- shift 7 bits 
  s_signKeep  <= '1';		-- 1 = preserve sign
  s_dir       <= '1';		-- 1 = shift left
  wait for gCLK_HPER*2;
  -- Expect: oQ = 0x0007FF80

  
  end process;
end arch;
