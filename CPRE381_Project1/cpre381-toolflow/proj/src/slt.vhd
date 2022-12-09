-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- slt.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a the MIPS slt
-- instruction. Takes in two 32-bit integer and sets its output to 1
-- when input A is less B (A < B).
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity slt is
  generic(N : integer := 32);
  port(i_A	   : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_F         : out std_logic_vector(N-1 downto 0));
  end slt;

architecture dataflow of slt is

begin


o_F <= x"00000001" when (signed(i_A) < signed(i_B))
       else x"00000000";

end dataflow; 

