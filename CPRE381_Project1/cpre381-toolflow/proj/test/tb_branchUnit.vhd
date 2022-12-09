-------------------------------------------------------------------------
-- L8Sk8rs
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_branchUnit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the branchUnit.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.textio.all;

entity tb_branchUnit is
  generic  (gCLK_HPER   : time := 10 ns;
            N : integer := 32);
end tb_branchUnit;

architecture structural of tb_branchUnit is

constant cCLK_PER    : time := gCLK_HPER * 2;

  component branchUnit is
    port(iCLK        : in std_logic;
         i_A         : in std_logic_vector(N-1 downto 0);
         i_B         : in std_logic_vector(N-1 downto 0);
         findIsEqual : in std_logic;
         o_zero      : out std_logic);
end component;

--- SIGNALS ---------------------------------------------------------------
signal CLK, reset    : std_logic := '0';

signal s_iA          :  std_logic_vector(N-1 downto 0) := x"00000000";
signal s_iB          :  std_logic_vector(N-1 downto 0) := x"00000000";
signal s_findIsEqual :  std_logic := '0';

signal s_zero	     :  std_logic;

---------------------------------------------------------------------------

begin

--- PORT MAP --------------------------------------------------------------
  DUT0: branchUnit
  port map( iCLK        => CLK,
            i_A         => s_iA,
            i_B         => s_iB,
            findIsEqual => s_findIsEqual,
            o_zero      => s_zero);

---- CLOCK STUFF -----------------------------------------------------------
  P_CLK: process
  begin
    CLK <= '1';
    wait for gCLK_HPER;
    CLK <= '0';
    wait for gCLK_HPER;
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

---- TEST CASES -----------------------------------------------------------
  zP_TEST_CASES: process
  begin
    wait for gCLK_HPER/2;

    -- Test case 0: Everything = 0
    -- iA = 0x00000000, iB = 0x00000000, findIsEqual = 0
    s_findIsEqual <= '0';           -- 0 = bne, 1 = beq
    s_iA          <= x"00000000";
    s_iB          <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: o_zero = 0

    -- Test case 1: Testing beq, FAILS
    -- iA = 0xF0F0F0F0, iB = 0x00000000, findIsEqual = 1
    s_findIsEqual <= '1';           -- 0 = bne, 1 = beq
    s_iA          <= x"F0F0F0F0";
    s_iB          <= x"00000000";
    wait for gCLK_HPER*2;
    -- Expect: o_zero = 0

    -- Test case 2: Testing beq, PASSES
    -- iA = 0xD1D1D1D1, iB = 0xD1D1D1D1, findIsEqual = 1
    s_findIsEqual <= '1';           -- 0 = bne, 1 = beq
    s_iA          <= x"D1D1D1D1";
    s_iB          <= x"D1D1D1D1";
    wait for gCLK_HPER*2;
    -- Expect: o_zero = 1

    -- Test case 3: Testing bne, FAILS
    -- iA = 0xBABABABA, iB = 0xBABABABA, findIsEqual = 1
    s_findIsEqual <= '0';           -- 0 = bne, 1 = beq
    s_iA          <= x"BABABABA";
    s_iB          <= x"BABABABA";
    wait for gCLK_HPER*2;
    -- Expect: o_zero = 0

    -- Test case 2: Testing bne, PASSES
    -- iA = 0xFAFAFAFA, iB = 0x01234567, findIsEqual = 1
    s_findIsEqual <= '0';           -- 0 = bne, 1 = beq
    s_iA          <= x"FAFAFAFA";
    s_iB          <= x"01234567";
    wait for gCLK_HPER*2;
    -- Expect: o_zero = 1

  end process;
end structural;