-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- onesComp.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a ones complementor.
-- Inverts each individual bit of an n-bit input.
--
-- NOTES: N/A
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onesComp is
  generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
end onesComp;

architecture structural of onesComp is

  component invg is
    port(i_A          : in std_logic;
         o_F          : out std_logic);

  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_INVG: for i in 0 to N-1 generate
    INVG1: invg port map(
              i_A     => i_A(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_F     => o_F(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_INVG;
  
end structural;

 