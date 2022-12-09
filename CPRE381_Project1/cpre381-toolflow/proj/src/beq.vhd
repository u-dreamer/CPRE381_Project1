-------------------------------------------------------------------------
-- L8Sk8rs
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- beq.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a the MIPS beq
-- instruction. Takes in two 32-bit integer and sets output (o_Z) to 1
-- when input A is equal to B (A = B).
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity beq is
  generic(N : integer := 32);
  port(i_A	   : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_Z         : out std_logic);
  end beq;

architecture dataflow of beq is

begin

o_Z <= '1' when (i_A = i_B)
       else '0';

end dataflow;