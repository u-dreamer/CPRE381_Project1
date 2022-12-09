-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- fullAdder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a full-adder.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is

  port(iCLK         : in std_logic;
       i_A          : in std_logic;
       i_B          : in std_logic;
       i_C          : in std_logic;
       o_S	    : out std_logic;
       o_C          : out std_logic);

  end fullAdder;

architecture structure of fullAdder is

  component xorg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);

  end component;

  component andg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);

  end component;

  component org2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);

  end component;

  -- Signal to carry o_F to XOR1
  signal s_XOR0       : std_logic;

  -- Signal to carry o_F to AND1
  signal s_AND0       : std_logic;

  -- Signal to carry o_F to OR0
  signal s_AND1       : std_logic;

begin

  ---------------------------------------------------------------------------
  -- Level 0: XOR_0 and AND_0 Gates
  ---------------------------------------------------------------------------
  xor_0: xorg2
    port MAP(i_A              => i_A,
             i_B              => i_B,
             o_F              => s_XOR0);

  and_0: andg2
    port MAP(i_A              => i_A,
             i_B              => i_B,
             o_F              => s_AND0);

  ---------------------------------------------------------------------------
  -- Level 1: AND Gate
  ---------------------------------------------------------------------------
  and_1: andg2
    port MAP(i_A              => s_XOR0,
             i_B              => i_C,
             o_F              => s_AND1);
   
  ---------------------------------------------------------------------------
  -- Level 2: OR and XOR Gates
  ---------------------------------------------------------------------------
  xor_1: xorg2
    port MAP(i_A              => s_XOR0,
             i_B              => i_C,
             o_F              => o_S);

  or_0: org2
    port MAP(i_A             => s_AND0,
             i_B             => s_AND1,
             o_F             => o_C);

end structure;