-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a behavioral 
-- multiplier operating on integer inputs. 
--
--
-- NOTES: Integer data type is not typically useful when doing hardware
-- design. We use it here for simplicity, but in future labs it will be
-- important to switch to std_logic_vector types and associated math
-- libraries (e.g. signed, unsigned). 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is

  port(i_S          : in std_logic;
       i_D0         : in std_logic;
       i_D1         : in std_logic;
       o_O          : out std_logic);

  end mux2t1;

architecture structure of mux2t1 is

  component invg
    port(i_A          : in std_logic;
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

  -- Signal to carry i_S from NOT gate into and_0
  signal s_A         : std_logic;

  -- Signal to carry o_F from and_0
  signal s_AxB       : std_logic;

  -- Signal to carry o_F from and_1
  signal s_CxD       : std_logic;

begin

  --------------------------------------------------------------------------
  -- Level 0: NOT Gate
  ---------------------------------------------------------------------------
 
  not_S: invg
    port MAP(i_A              => i_S,
             o_F              => s_A);

  ---------------------------------------------------------------------------
  -- Level 1: AND Gates
  ---------------------------------------------------------------------------
  and_0: andg2
    port MAP(i_A              => s_A,
             i_B              => i_D0,
             o_F              => s_AxB);
  
  and_1: andg2
    port MAP(i_A              => i_S,
             i_B              => i_D1,
             o_F              => s_CxD);
    
  ---------------------------------------------------------------------------
  -- Level 2: OR Gate
  ---------------------------------------------------------------------------
  or_0: org2
    port MAP(i_A             => s_AxB,
             i_B             => s_CxD,
             o_F             => o_O);

end structure;    
