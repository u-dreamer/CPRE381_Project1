-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- lui.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a the MIPS lui
-- instruction. Takes in two 32-bit integer and sets its output to 1
-- when input A is less B (A < B).
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity lui is
  generic(N : integer := 32);
  port(i_B         : in std_logic_vector(N-1 downto 0);
       o_F         : out std_logic_vector(N-1 downto 0));
  end lui;

architecture dataflow of lui is

--- SIGNALS ---------------------------------------------------------------
signal i_Upper   : std_logic_vector(15 downto 0);   
---------------------------------------------------------------------------

begin
i_Upper <= i_B(15 downto 0);           

o_F <= i_Upper & x"0000";

end dataflow; 
