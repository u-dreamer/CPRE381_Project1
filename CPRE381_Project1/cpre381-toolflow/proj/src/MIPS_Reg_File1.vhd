-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- MIPS_Reg_File.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the structural implementation for a 
-- 		MIPS 32-bit register file with 2 read ports, and 1 
--		write port.
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

--library work;
--use work.pak_reg.all;

entity MIPS_Reg_File1 is
  generic(N : integer := 32;
          X : integer := 5);
  port (i_CLK	  : in std_logic;
	i_RST     : in std_logic;
	WE        : in std_logic;
	i_D       : in std_logic_vector(N-1 downto 0);
        WriteReg  : in std_logic_vector(X-1 downto 0);
	rs 	  : in std_logic_vector(X-1 downto 0);
  	rt        : in std_logic_vector(X-1 downto 0);
	rs_val    : out std_logic_vector(N-1 downto 0);
	rt_val    : out std_logic_vector(N-1 downto 0));	
end MIPS_Reg_File1;

architecture structure of MIPS_Reg_File1 is

-- Component entity descriptions as given in their designated files:
-- 5to32decoder.vhd, dffg_N.vhd, and 32t1mux.vhd.

component decoder5to32 is
  port ( D_IN  : in  std_logic_vector(X-1 downto 0);
         F_OUT : out std_logic_vector(N-1 downto 0));
end component;

component mux2t1_N is
  port ( i_S    : in  std_logic;
	 D0     : in  std_logic_vector(31 downto 0);
	 D1     : in  std_logic_vector(31 downto 0);
         F_OUT  : out std_logic_vector(31 downto 0));
end component;

component dffg_N is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in  std_logic_vector(N-1 downto 0);   -- Data value input
       o_Q   	    : out std_logic_vector(N-1 downto 0));  -- Data value output
end component;

component norg_N is
  generic(N : integer := 5);
  port(i_A 	  : in std_logic_vector(N-1 downto 0);
       i_B	  : in std_logic_vector(N-1 downto 0);
       o_F	  : out std_logic_vector(N-1 downto 0));
end component;

component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component mux32t1 is
  port ( i_S    : in  std_logic_vector(4 downto 0);
	 D0     : in  std_logic_vector(31 downto 0);
	 D1     : in  std_logic_vector(31 downto 0);
	 D2     : in  std_logic_vector(31 downto 0);
	 D3     : in  std_logic_vector(31 downto 0);
	 D4     : in  std_logic_vector(31 downto 0);
	 D5     : in  std_logic_vector(31 downto 0);
	 D6     : in  std_logic_vector(31 downto 0);
	 D7     : in  std_logic_vector(31 downto 0);
	 D8     : in  std_logic_vector(31 downto 0);
	 D9     : in  std_logic_vector(31 downto 0);
	 D10    : in  std_logic_vector(31 downto 0);
	 D11    : in  std_logic_vector(31 downto 0);
	 D12    : in  std_logic_vector(31 downto 0);
	 D13    : in  std_logic_vector(31 downto 0);
	 D14    : in  std_logic_vector(31 downto 0);
	 D15    : in  std_logic_vector(31 downto 0);
	 D16    : in  std_logic_vector(31 downto 0);
	 D17    : in  std_logic_vector(31 downto 0);
	 D18    : in  std_logic_vector(31 downto 0);
	 D19    : in  std_logic_vector(31 downto 0);
	 D20    : in  std_logic_vector(31 downto 0);
	 D21    : in  std_logic_vector(31 downto 0);
	 D22    : in  std_logic_vector(31 downto 0);
	 D23    : in  std_logic_vector(31 downto 0);
	 D24    : in  std_logic_vector(31 downto 0);
	 D25    : in  std_logic_vector(31 downto 0);
	 D26    : in  std_logic_vector(31 downto 0);
	 D27    : in  std_logic_vector(31 downto 0);
	 D28    : in  std_logic_vector(31 downto 0);
	 D29    : in  std_logic_vector(31 downto 0);
	 D30    : in  std_logic_vector(31 downto 0);
	 D31    : in  std_logic_vector(31 downto 0);
         F_OUT  : out std_logic_vector(31 downto 0));
end component;

---- Create array for storing reg vals -------------------------------------
type r_data is array (0 to 31) of std_logic_vector(N-1 downto 0);
signal s_Q : r_data :=  (x"00000000", --$zero
		         x"00000001", --$1
			 x"00000002",
		 	 x"00000003",
			 x"00000004",
			 x"00000005",
			 x"00000006",
			 x"00000007",
			 x"00000008",
			 x"00000009",
			 x"0000000A",
			 x"0000000B",
			 x"0000000C",
			 x"0000000D",
			 x"0000000E",
			 x"0000000F",
			 x"00000010",
			 x"00000020",
			 x"00000030",
			 x"00000040",
			 x"00000050",
			 x"00000060",
			 x"00000070",
			 x"00000080",
			 x"00000090",
			 x"000000A0",
 			 x"000000B0",
			 x"000000C0",
			 x"000000D0",
			 x"000000E0",
			 x"000000F0",
			 x"00000100");
-- Define signals ---------------------------------------------------------
signal dec_out     : std_logic_vector(N-1 downto 0); 
signal mux0_out    : std_logic_vector(N-1 downto 0);
---------------------------------------------------------------------------
begin
---------------------------------------------------------------------------
-- Level 0: Load 5 bits of rd into 5to32decoder & See if WriteReg = 0
---------------------------------------------------------------------------
-- Need to be able to write to rd AND rt
g_5to32decoder: decoder5to32
  port MAP( D_IN  => WriteReg,
 	    F_OUT => dec_out);

---------------------------------------------------------------------------
-- Level 1: Get HOT bit (rd) to 2t1mux --> Decide if/where to write??
---------------------------------------------------------------------------
g_Mux0: mux2t1_N
  port MAP( i_S   => WE,
            D0    => x"00000000",
	    D1    => dec_out,
            F_OUT => mux0_out);

---------------------------------------------------------------------------
-- Level 2: Get WE bit from mux0_out to designated reg...
---------------------------------------------------------------------------
G_NBit_DFFG: for i in 0 to N-1 generate
  g_dffg_0: dffg_N
    port MAP(i_CLK => i_CLK,
	     i_RST => i_RST,
	     i_WE  => mux0_out(i),
             i_D   => i_D,
             o_Q   => s_Q(i));
end generate G_NBit_DFFG;

--------------------------------------------------------------------------
-- Level 3: Use 2 32-bit muxes to select read register data
---------------------------------------------------------------------------
g_Mux1: mux32t1
  port MAP( i_S => rs,
            D0  => x"00000000",
	    D1  => s_Q(1),
	    D2  => s_Q(2),
	    D3  => s_Q(3),
	    D4  => s_Q(4),
	    D5  => s_Q(5),
	    D6  => s_Q(6),
	    D7  => s_Q(7),
	    D8  => s_Q(8),
	    D9  => s_Q(9),
	    D10 => s_Q(10),
	    D11 => s_Q(11),
	    D12 => s_Q(12),
	    D13 => s_Q(13),
	    D14 => s_Q(14),
	    D15 => s_Q(15),
	    D16 => s_Q(16),
	    D17 => s_Q(17),
	    D18 => s_Q(18),
	    D19 => s_Q(19),
	    D20 => s_Q(20),
	    D21 => s_Q(21),
	    D22 => s_Q(22),
	    D23 => s_Q(23),
	    D24 => s_Q(24),
	    D25 => s_Q(25),
	    D26 => s_Q(26),
	    D27 => s_Q(27),
	    D28 => s_Q(28),
	    D29 => s_Q(29),
	    D30 => s_Q(30),
	    D31 => s_Q(31),
            F_OUT => rs_val);

g_Mux2: mux32t1
  port MAP( i_S => rt,
            D0  => x"00000000",
	    D1  => s_Q(1),
	    D2  => s_Q(2),
	    D3  => s_Q(3),
	    D4  => s_Q(4),
	    D5  => s_Q(5),
	    D6  => s_Q(6),
	    D7  => s_Q(7),
	    D8  => s_Q(8),
	    D9  => s_Q(9),
	    D10 => s_Q(10),
	    D11 => s_Q(11),
	    D12 => s_Q(12),
	    D13 => s_Q(13),
	    D14 => s_Q(14),
	    D15 => s_Q(15),
	    D16 => s_Q(16),
	    D17 => s_Q(17),
	    D18 => s_Q(18),
	    D19 => s_Q(19),
	    D20 => s_Q(20),
	    D21 => s_Q(21),
	    D22 => s_Q(22),
	    D23 => s_Q(23),
	    D24 => s_Q(24),
	    D25 => s_Q(25),
	    D26 => s_Q(26),
	    D27 => s_Q(27),
	    D28 => s_Q(28),
	    D29 => s_Q(29),
	    D30 => s_Q(30),
	    D31 => s_Q(31),
            F_OUT => rt_val);

end structure;

