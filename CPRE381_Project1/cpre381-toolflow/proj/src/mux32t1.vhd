-------------------------------------------------------------------------
-- Anna Huggins
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- mux32t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a *behavioral* 
-- 32-bit 32 to 1 mux.
--
--
-- NOTES: Integer data type is not typically useful when doing hardware
-- design. We use it here for simplicity, but in future labs it will be
-- important to switch to std_logic_vector types and associated math
-- libraries (e.g. signed, unsigned). 
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1 is
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
end mux32t1;

architecture dataflow of mux32t1 is
begin
  with i_S select F_OUT <=
    D0   when "00000",
    D1   when "00001",
    D2   when "00010",
    D3   when "00011",
    D4   when "00100",
    D5   when "00101",
    D6   when "00110",
    D7   when "00111",
    D8   when "01000",
    D9   when "01001",
    D10  when "01010",
    D11  when "01011",
    D12  when "01100",
    D13  when "01101",
    D14  when "01110",
    D15  when "01111",
    D16  when "10000",
    D17  when "10001",
    D18  when "10010",
    D19  when "10011",
    D20  when "10100",
    D21  when "10101",
    D22  when "10110",
    D23  when "10111",
    D24  when "11000",
    D25  when "11001",
    D26  when "11010",
    D27  when "11011",
    D28  when "11100",
    D29  when "11101",
    D30  when "11110",
    D31  when "11111",
    D0   when others;
end dataflow;
