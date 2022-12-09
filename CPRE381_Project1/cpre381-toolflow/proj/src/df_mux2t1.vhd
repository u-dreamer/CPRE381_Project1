-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- df_mux2t1.vhd
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

entity df_mux2t1 is
  port(i_D1           : in std_logic;
       i_D0           : in std_logic;
       i_S            : in std_logic;
       o_O            : out std_logic);

end df_mux2t1;

architecture df_2t1 of df_mux2t1 is
begin 
  o_O <= i_D1 when (i_S = '1') else
         i_D0;

end df_2t1;
