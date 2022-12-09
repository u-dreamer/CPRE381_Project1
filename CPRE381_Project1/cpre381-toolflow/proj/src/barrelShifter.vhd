-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- barrelShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file is the implementation of a barrel shifter
--  	        to implement MIPS instructions srl, sra, and sll.
--              
-- 10//2022
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity barrelShifter is
  generic(N : integer := 32;
	  S : integer := 5 );
  port(i_D            : in std_logic_vector(N-1 downto 0);
       shamt 	      : in std_logic_vector(S-1 downto 0);
       signKeep       : in std_logic;			    -- 0 = sll/srl, 1 = sra
       dir            : in std_logic;			    -- 0 = right, 1 = left
       o_Q            : out std_logic_vector(N-1 downto 0));
end barrelShifter;

architecture structural of barrelShifter is
  component mux2t1_N
  generic(N : integer := 32);
  port(i_S          : in std_logic;
       D0           : in std_logic_vector(N-1 downto 0);
       D1           : in std_logic_vector(N-1 downto 0);
       F_OUT        : out std_logic_vector(N-1 downto 0));
end component;

--- SIGNALS ---------------------------------------------------------------
signal srl0_out   : std_logic_vector(N-1 downto 0);
signal srl1_out   : std_logic_vector(N-1 downto 0);
signal srl2_out   : std_logic_vector(N-1 downto 0);
signal srl3_out   : std_logic_vector(N-1 downto 0);
signal srl4_out   : std_logic_vector(N-1 downto 0);

signal srl1_D1    : std_logic_vector(N-1 downto 0);
signal srl2_D1    : std_logic_vector(N-1 downto 0);
signal srl3_D1    : std_logic_vector(N-1 downto 0);
signal srl4_D1    : std_logic_vector(N-1 downto 0);


signal sll0_out   : std_logic_vector(N-1 downto 0);
signal sll1_out   : std_logic_vector(N-1 downto 0);
signal sll2_out   : std_logic_vector(N-1 downto 0);
signal sll3_out   : std_logic_vector(N-1 downto 0);
signal sll4_out   : std_logic_vector(N-1 downto 0);

signal shift_in   : std_logic;      
---------------------------------------------------------------------------
   
begin

---------------------------------------------------------------------------
-- Level 0: Shift by 0 or 1 bits
---------------------------------------------------------------------------
shift_in <= i_D(31) and signKeep;

 mux_srl0: mux2t1_N
  port MAP(i_S     => shamt(0),
           D0      => i_D,
           D1      => shift_in & i_D(31 downto 1), 
           F_OUT   => srl0_out);

 mux_sll0: mux2t1_N
  port MAP(i_S     => shamt(0),
           D0      => i_D,
           D1      => i_D(30 downto 0) & '0', 
           F_OUT   => sll0_out);

---------------------------------------------------------------------------
-- Level 1: Shift by 0 or 2 bits
---------------------------------------------------------------------------\
srl1_D1(31 downto 30) <= (others => shift_in);
srl1_D1(29 downto 0) <= srl0_out(31 downto 2);

 mux_srl1: mux2t1_N
  port MAP(i_S     => shamt(1),
           D0      => srl0_out,
	   D1 	   => srl1_D1,
           F_OUT   => srl1_out);

 mux_sll1: mux2t1_N
  port MAP(i_S     => shamt(1),
           D0      => sll0_out,
           D1      => sll0_out(29 downto 0) & "00", 
           F_OUT   => sll1_out);

---------------------------------------------------------------------------
-- Level 2: Shift by 0 or 4 bits
---------------------------------------------------------------------------
srl2_D1(31 downto 28) <= (others => shift_in);
srl2_D1(27 downto 0) <= srl1_out(31 downto 4);

 mux_srl2: mux2t1_N
  port MAP(i_S     => shamt(2),
           D0      => srl1_out,
           D1      => srl2_D1,
           F_OUT   => srl2_out);

 mux_sll2: mux2t1_N
  port MAP(i_S     => shamt(2),
           D0      => sll1_out,
           D1      => sll1_out(27 downto 0) & "0000", 
           F_OUT   => sll2_out);
 
---------------------------------------------------------------------------
-- Level 3: Shift by 0 or 8 bits
---------------------------------------------------------------------------
srl3_D1(31 downto 24) <= (others => shift_in);
srl3_D1(23 downto 0) <= srl2_out(31 downto 8);

 mux_srl3: mux2t1_N
  port MAP(i_S     => shamt(3),
           D0      => srl2_out,
           D1      => srl3_D1, 
           F_OUT   => srl3_out);

 mux_sll3: mux2t1_N
  port MAP(i_S     => shamt(3),
           D0      => sll2_out,
           D1      => sll2_out(23 downto 0) & "00000000",
           F_OUT   => sll3_out);

---------------------------------------------------------------------------
-- Level 4: Shift by 0 or 16 bits
---------------------------------------------------------------------------
srl4_D1(31 downto 16) <= (others => shift_in);
srl4_D1(15 downto 0) <= srl3_out(31 downto 16);

 mux_srl4: mux2t1_N
  port MAP(i_S     => shamt(4),
           D0      => srl3_out,
           D1      => srl4_D1,
           F_OUT   => srl4_out);

 mux_sll4: mux2t1_N
  port MAP(i_S     => shamt(4),
           D0      => sll3_out,
           D1      => sll3_out(15 downto 0) & "0000000000000000", 
           F_OUT   => sll4_out);

---------------------------------------------------------------------------
-- Level 5: Determine if we want srl/sra or sll
---------------------------------------------------------------------------
 mux_shiftDir: mux2t1_N
  port MAP(i_S     => dir,
           D0      => srl4_out,
           D1      => sll4_out,
           F_OUT   => o_Q);

end structural;