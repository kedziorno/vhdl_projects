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
i_clock : in std_logic;
io_MemOE : inout std_logic;
io_MemWR : inout std_logic;
io_RamAdv : inout std_logic;
io_RamCS : inout std_logic;
io_RamClk : inout std_logic;
io_RamCRE : inout std_logic;
io_RamLB : inout std_logic;
io_RamUB : inout std_logic;
io_RamWait : inout std_logic;
io_MemAdr : inout std_logic_vector(23 downto 0);
io_MemDB : inout std_logic_vector(15 downto 0);
i_sw : in std_logic_vector(7 downto 0);
i_btn : in std_logic_vector(3 downto 0);
o_seg : out std_logic_vector(6 downto 0);
o_dp : out std_logic;
o_an : out std_logic_vector(3 downto 0);
o_Led : out std_logic_vector(7 downto 0)
);
end top;

architecture Behavioral of top is
	constant BOARD_CLOCK : integer := 50_000_000;
	constant DIVIDER1 : integer := 1_000_000;

	component clock_divider is
	Generic(
		g_board_clock : integer;
		g_divider : integer
	);
	Port(
		i_clock : in STD_LOGIC;
		o_clock : out STD_LOGIC
	);
	end component clock_divider;
	for all : clock_divider use entity work.clock_divider(Behavioral);
 
	signal clock_divider_1 : std_logic;
	
begin
	c_clock_divider_1 : clock_divider
	Generic Map (
		g_board_clock => BOARD_CLOCK,
		g_divider => DIVIDER1
	)
	Port Map (
		i_clock => i_clock,
		o_clock => clock_divider_1
	);

	o_Led <= i_sw;
	o_an <= i_btn;
	o_seg <= i_sw(6 downto 0);
	o_dp <= '1';
	io_MemOE <= 'Z';
	io_MemWR <= 'Z';
	io_RamAdv <= 'Z';
	io_RamCS <= 'Z';
	io_RamClk <= 'Z';
	io_RamCRE <= 'Z';
	io_RamLB <= 'Z';
	io_RamUB <= 'Z';
	io_RamWait <= 'Z';
	io_MemDB <= (others => 'Z');
	io_MemAdr <= (others => 'Z');
end Behavioral;

