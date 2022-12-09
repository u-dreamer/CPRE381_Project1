-------------------------------------------------------------------------
-- L8Sk8rs
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- PC.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the implementation of the PC.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;
       i_RST        : in std_logic;
       i_WE         : in std_logic;
       i_D          : in  std_logic_vector(N-1 downto 0);
       o_Q   	    : out std_logic_vector(N-1 downto 0));
end PC;

architecture structural of PC is
  component dffg is
    port(i_CLK        : in std_logic;
         i_RST        : in std_logic;
         i_WE         : in std_logic;
         i_D          : in std_logic;
         o_Q          : out std_logic);
  end component;

begin

-- Instantiate N dffg instances
 G_NBit_DFFG: for i in 0 to N-1 generate
   DFFG_N0: dffg port map(
	    i_CLK => i_CLK,
 	    i_RST => i_RST,
 	    i_WE  => i_WE,
 	    i_D   => i_D(i), 
            o_Q   => o_Q(i));
  end generate G_NBit_DFFG;

end structural;
