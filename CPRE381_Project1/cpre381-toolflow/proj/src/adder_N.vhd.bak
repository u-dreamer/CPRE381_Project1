-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an n-bit full-adder.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity adder_N is
  generic(N : integer := 32);
  port(iCLK    : in std_logic;
       i_C     : in std_logic;
       i_A     : in std_logic_vector(N-1 downto 0);
       i_B     : in std_logic_vector(N-1 downto 0);
       o_S     : out std_logic_vector(N-1 downto 0);
       o_C     : out std_logic);
end adder_N;

architecture structural of adder_N is
  component fullAdder is
    port(iCLK   : in std_logic;
         i_A    : in std_logic;
         i_B    : in std_logic;
	 i_C    : in std_logic;
         o_S    : out std_logic;
         o_C    : out std_logic);
  end component;

  signal s_C      : std_logic_vector(N-2 downto 0);

begin

-- Instantiate first adder, adder0
  ADDER_0: fullAdder port map(
             iCLK   => iCLK,
             i_A    => i_A(0),
             i_B    => i_B(0),
             i_C    => i_C,
             o_C    => s_C(0),
             o_S    => o_S(0));

-- Instantiate N adder instances
  G_NBit_ADDER: for i in 1 to N-2 generate
    ADDER_N0: fullAdder port map(
             iCLK  => iCLK,
             i_A   => i_A(i),
             i_B   => i_B(i),
             i_C   => s_C(i-1),
             o_C   => s_C(i),
             o_S   => o_S(i));
    end generate G_NBit_ADDER;

-- Instantiate N adder instance
  ADDER_N: fullAdder port map(
             iCLK  => iCLK,
             i_A   => i_A(N-1),
             i_B   => i_B(N-1),
             i_C   => s_C(N-2),
             o_C   => o_C,
             o_S   => o_S(N-1));

end structural;
    
