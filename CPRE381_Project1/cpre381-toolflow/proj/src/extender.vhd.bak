-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- extender.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a behavioral 
-- multiplier operating on integer inputs. 
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity extender is 
  generic(N : integer := 32;
          W : integer := 16);

  port ( i_imm   : in std_logic_vector(W-1 downto 0);
         ctrl : in std_logic;
         F_OUT   : out std_logic_vector(N-1 downto 0));

end extender;

architecture behavioral of extender is
begin

  F_OUT <= x"0000" & i_imm when (i_imm(15) = '0' and ctrl = '1') else
           x"FFFF" & i_imm when ctrl = '1' else
           x"0000" & i_imm;
end behavioral;