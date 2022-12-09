-------------------------------------------------------------------------
-- L8Sk8rs
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- branchUnit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the implementation of the MIPS beq and
-- bne instructions. Takes in two 32-bit integer and returns a value
-- indicating whether or not it should branch based on the current
-- instruction.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity branchUnit is
  generic(N : integer := 32);
  port(iCLK           : in std_logic;
       i_A            : in std_logic_vector(N-1 downto 0);
       i_B            : in std_logic_vector(N-1 downto 0);
       findIsEqual    : in std_logic;
       o_zero	      : out std_logic);
  end branchUnit; 

architecture structure of branchUnit is
  component beq
    port(i_A	     : in std_logic_vector(N-1 downto 0);
         i_B         : in std_logic_vector(N-1 downto 0);
         o_Z         : out std_logic);
  end component;
  
  component bne
    port(i_A	     : in std_logic_vector(N-1 downto 0);
         i_B         : in std_logic_vector(N-1 downto 0);
         o_Z         : out std_logic);
  end component;

  component mux2t1
    port(i_S          : in std_logic;
         i_D0         : in std_logic;
         i_D1         : in std_logic;
         o_O          : out std_logic);
  end component;

--- SIGNALS ---------------------------------------------------------------
signal s_beq         : std_logic;
signal s_bne         : std_logic;
---------------------------------------------------------------------------

begin

---------------------------------------------------------------------------
-- Level 0: perform beq & bne
---------------------------------------------------------------------------
  beq_block: beq
    port MAP(i_A   =>  i_A,
	     i_B   =>  i_B,
             o_Z   =>  s_beq);

  bne_block: bne
    port MAP(i_A   =>  i_A,
	     i_B   =>  i_B,
             o_Z   =>  s_bne);

---------------------------------------------------------------------------
-- Level 1: N-bit 2:1 MUX (choose btw beq & bne)
---------------------------------------------------------------------------    
  mux_zero: mux2t1
    port MAP(i_S   =>  findIsEqual,
             i_D0  =>  s_bne,
             i_D1  =>  s_beq,            
             o_O   =>  o_zero);

end structure;