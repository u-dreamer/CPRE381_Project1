-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_extender.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a behavioral 
-- multiplier operating on integer inputs. 
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_extender is 
  generic(gCLK_HPER   : time := 10 ns;
          N : integer := 32;
          W : integer := 16);
end tb_extender;

architecture arch of tb_extender is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- Component Declaration ---------------------------------------------------
  component extender is
    port ( i_imm   : in std_logic_vector(W-1 downto 0);
           ctrl : in std_logic;
           F_OUT   : out std_logic_vector(N-1 downto 0));
end component;

--- SIGNALS ----------------------------------------------------------------
signal CLK, reset : std_logic := '0';
signal s_imm      : std_logic_vector(W-1 downto 0) := x"0000";
signal s_ctrl     : std_logic := '0';
signal s_out      : std_logic_vector(N-1 downto 0);

begin

-- Port/Signal Mapping -----------------------------------------------------
  DUT0: extender
  port map( i_imm    =>  s_imm,
            ctrl     =>  s_ctrl,
            F_OUT    =>  s_out);

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
    --wait for gCLK_HPER*2;

    -- Test case 0: Sign extend 1
    s_imm    <=  x"0001";
    s_ctrl   <=  '1';
    wait for gCLK_HPER*2;
    -- Expect: s_out = 0x00000001

    -- Test case 1: Sign extend -1
    s_imm    <=  x"FFFF";
    s_ctrl   <=  '1';
    wait for gCLK_HPER*2;
    -- Expect: s_out = 0xFFFFFFFF

    -- Test case 2: Zero extend FFFF
    s_imm    <=  x"FFFF";
    s_ctrl   <=  '0';
    wait for gCLK_HPER*2;
    -- Expect: s_out = 0x0000FFFF
  end process;
end arch;
