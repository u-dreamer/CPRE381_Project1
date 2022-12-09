-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_dmem.1vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the N-bit adder-subtractor
--              
-- 09/06/2022
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_dmem is
  generic  (gCLK_HPER   : time := 10 ns; -- Generic for half of the clock cycle period
            DATA_WIDTH  : integer := 32;
            ADDR_WIDTH  : integer := 10);     
end tb_dmem;

architecture arch of tb_dmem is
-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
  component mem is
	port 
	(
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end component;



-- SIGNALS ------------------------------------------------------------------
signal CLK, reset : std_logic := '0';
signal s_addr	        : std_logic_vector((ADDR_WIDTH-1) downto 0)   := "0000000000";
signal s_data	        : std_logic_vector((DATA_WIDTH-1) downto 0)   := x"00000000";  
signal s_we		: std_logic := '0';
signal s_q		: std_logic_vector((DATA_WIDTH -1) downto 0) := x"00000000";    


begin
-- Port/Signal Mapping ------------------------------------------------------
  DUT0: mem
  port map( clk    => CLK,
            addr   => s_addr,
            data   => s_data,
            we     => s_we,
            q      => s_q);
---- Clock Processes ----------------------------------------------------------
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;


  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
-------------------------------------------------------------------------------

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges
    --wait for gCLK_HPER*2;


------- Read First 10 Values from mem -----------------------------------------
    -- Test case 0: Read first val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0000000000";      -- Address to read/write = 0x0
    s_data       <= x"11111111";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: s_q = 0xFFFFFFFF = -1   

    -- Test case 1: Read 2nd val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0000000001";      -- Address to read/write = 0x0
    s_data       <= x"11111111";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = 0x2 = 2

   -- Test case 2: Read 3rd val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0000000010";      -- Address to read/write = 0x0
    s_data       <= x"11111111";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = -3

   -- Test case 2: Read 3rd val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0000000011";      -- Address to read/write = 0x0
    s_data       <= x"11111111";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = -3


   -- Test case 4: Read 4th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0000000100";      -- Address to read/write = 0x0
    s_data       <= x"11111111";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = 0x4 = 4

   -- Test case 5: Read 5th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0000000101";      -- Address to read/write = 0x0
    s_data       <= x"11111111";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = 6


   -- Test case 6: Read 6th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0000000110";      -- Address to read/write = 0x0
    s_data       <= x"11111111";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = -7

   -- Test case 7: Read 7th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0000000111";      -- Address to read/write = 0x0
    s_data       <= x"11111111";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = -8


   -- Test case 8: Read 8th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0000001000";      -- Address to read/write = 0x0
    s_data       <= x"11111111";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = 9

   -- Test case 9: Read 10th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0000001001";      -- Address to read/write = 0x0
    s_data       <= x"11111111";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = -10

------- Write 10 vals to other location ---------------------------------------

    -- Test case 0: Write first val
    s_we         <= '1';               -- Disable write
    s_addr	 <= "0100000000";      -- Address to read/write = 0x0
    s_data       <= x"ffffffff";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: s_q = 0xFFFFFFFF = -1   

    -- Test case 1: Write 2nd val
    s_we         <= '1';               -- Disable write
    s_addr	 <= "0100000001";      -- Address to read/write = 0x0
    s_data       <= x"00000002";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = 0x2 = 2

   -- Test case 2: Write 3rd val
    s_we         <= '1';               -- Disable write
    s_addr	 <= "0100000010";      -- Address to read/write = 0x0
    s_data       <= x"fffffffd";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = -3

   -- Test case 2: Write 3rd val
    s_we         <= '1';               -- Disable write
    s_addr	 <= "0100000011";      -- Address to read/write = 0x0
    s_data       <= x"00000004";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = -3


   -- Test case 4: Write 4th val
    s_we         <= '1';               -- Disable write
    s_addr	 <= "0100000100";      -- Address to read/write = 0x0
    s_data       <= x"00000005";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = 0x4 = 4

   -- Test case 5: Write 5th val
    s_we         <= '1';               -- Disable write
    s_addr	 <= "0100000101";      -- Address to read/write = 0x0
    s_data       <= x"00000006";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = 6


   -- Test case 6: Write 6th val
    s_we         <= '1';               -- Disable write
    s_addr	 <= "0100000110";      -- Address to read/write = 0x0
    s_data       <= x"fffffff9";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = -7

   -- Test case 7: Write 7th val
    s_we         <= '1';               -- Disable write
    s_addr	 <= "0100000111";      -- Address to read/write = 0x0
    s_data       <= x"fffffff8";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = -8


   -- Test case 8: Write 8th val
    s_we         <= '1';               -- Disable write
    s_addr	 <= "0100001000";      -- Address to read/write = 0x0
    s_data       <= x"00000009";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = 9

   -- Test case 9: Write 10th val
    s_we         <= '1';               -- Disable write
    s_addr	 <= "0100001001";      -- Address to read/write = 0x0
    s_data       <= x"fffffff6";       -- Data to write = X
    wait for gCLK_HPER*2;
    -- Expect: q = -10

------- Read 10 vals from other location ---------------------------------------

    -- Test case 0: Write first val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0100000000";      -- Address to read/write = 0x0
    wait for gCLK_HPER*2;
    -- Expect: s_q = 0xFFFFFFFF = -1   

    -- Test case 1: Write 2nd val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0100000001";      -- Address to read/write = 0x0
    wait for gCLK_HPER*2;
    -- Expect: q = 0x2 = 2

   -- Test case 2: Write 3rd val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0100000010";      -- Address to read/write = 0x0
    wait for gCLK_HPER*2;
    -- Expect: q = -3

   -- Test case 2: Write 3rd val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0100000011";      -- Address to read/write = 0x0
    wait for gCLK_HPER*2;
    -- Expect: q = -3


   -- Test case 4: Write 4th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0100000100";      -- Address to read/write = 0x0
    wait for gCLK_HPER*2;
    -- Expect: q = 0x4 = 4

   -- Test case 5: Write 5th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0100000101";      -- Address to read/write = 0x0
    wait for gCLK_HPER*2;
    -- Expect: q = 6


   -- Test case 6: Write 6th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0100000110";      -- Address to read/write = 0x0
    wait for gCLK_HPER*2;
    -- Expect: q = -7

   -- Test case 7: Write 7th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0100000111";      -- Address to read/write = 0x0
    wait for gCLK_HPER*2;
    -- Expect: q = -8


   -- Test case 8: Write 8th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0100001000";      -- Address to read/write = 0x0
    wait for gCLK_HPER*2;
    -- Expect: q = 9

   -- Test case 9: Write 10th val
    s_we         <= '0';               -- Disable write
    s_addr	 <= "0100001001";      -- Address to read/write = 0x0
    wait for gCLK_HPER*2;
    -- Expect: q = -10
  end process;
end arch;














