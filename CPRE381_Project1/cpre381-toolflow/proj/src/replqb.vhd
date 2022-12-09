-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- andg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N-bit and gate.
-- Ands each individual bit of an n-bit input A with B.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity replqb is
  generic(N : integer := 32;
	  B : integer := 8);
   port(i_B	  : in std_logic_vector(N-1 downto 0);
        o_F	  : out std_logic_vector(N-1 downto 0));
  end replqb;

architecture dataflow of replqb is

--- SIGNALS ---------------------------------------------------------------
signal i_Byte   : std_logic_vector(B-1 downto 0);   
---------------------------------------------------------------------------

begin

i_Byte <= i_B(B-1 downto 0);

o_F <= i_Byte & i_Byte & i_Byte & i_Byte;

end dataflow;