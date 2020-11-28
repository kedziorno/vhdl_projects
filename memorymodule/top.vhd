----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:21:00 11/28/2020
-- Design Name: 
-- Module Name:    /home/user/workspace/vhdl_projects/memorymodule/top.vhd
-- Project Name:   memorymodule
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port (
clk : in std_logic;
MemOE : inout std_logic;
MemWR : inout std_logic;
RamAdv : inout std_logic;
RamCS : inout std_logic;
RamClk : inout std_logic;
RamCRE : inout std_logic;
RamLB : inout std_logic;
RamUB : inout std_logic;
RamWait : inout std_logic;
MemAdr : inout std_logic_vector(23 downto 0);
MemDB : inout std_logic_vector(15 downto 0);
seg : out std_logic_vector(6 downto 0);
dp : out std_logic;
an : out std_logic_vector(3 downto 0);
Led : out std_logic_vector(7 downto 0);
sw : in std_logic_vector(7 downto 0);
btn : in std_logic_vector(3 downto 0)
);
end top;

architecture Behavioral of top is

begin
	Led <= sw;
	an <= btn;
	seg <= sw(6 downto 0);
	dp <= '1';
	MemOE <= 'Z';
	MemWR <= 'Z';
	RamAdv <= 'Z';
	RamCS <= 'Z';
	RamClk <= 'Z';
	RamCRE <= 'Z';
	RamLB <= 'Z';
	RamUB <= 'Z';
	RamWait <= 'Z';
	MemDB <= (others => 'Z');
	MemAdr <= (others => 'Z');
end Behavioral;

