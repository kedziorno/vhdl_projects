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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Generic (
L_MemoryAddress : integer := 24;
L_MemoryData : integer := 16;
L_Switch : integer := 8;
L_Button : integer := 4;
L_LCDSegment : integer := 7;
L_LCDAnode : integer := 4;
L_Led : integer := 8
);
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
io_MemAdr : inout std_logic_vector(L_MemoryAddress-1 downto 0);
io_MemDB : inout std_logic_vector(L_MemoryData-1 downto 0);
i_sw : in std_logic_vector(L_Switch-1 downto 0);
i_btn : in std_logic_vector(L_Button-1 downto 0);
o_seg : out std_logic_vector(L_LCDSegment-1 downto 0);
o_dp : out std_logic;
o_an : out std_logic_vector(L_LCDAnode-1 downto 0);
o_Led : out std_logic_vector(L_Led-1 downto 0)
);
end top;

architecture Behavioral of top is

	constant BOARD_CLOCK : integer := 50_000_000;
	constant DIVIDER1 : integer := 200; -- clock divider for LCD

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

	type Hex is array(L_LCDAnode-1 downto 0) of std_logic_vector(3 downto 0);
	signal LCDChar : Hex := (x"d",x"e",x"f",x"0");

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

	p0 : process (clock_divider_1) is
		variable count : integer range 0 to L_LCDAnode-1 := 0;
	begin
		if (rising_edge(clock_divider_1)) then
			case count is
				when 0 =>
					o_an(L_LCDAnode-1 downto 0) <= "0111";
				when 1 =>
					o_an(L_LCDAnode-1 downto 0) <= "1011";
				when 2 =>
					o_an(L_LCDAnode-1 downto 0) <= "1101";
				when 3 =>
					o_an(L_LCDAnode-1 downto 0) <= "1110";
				when others =>
					o_an(L_LCDAnode-1 downto 0) <= "1111";
			end case;
			if (count < L_LCDAnode) then
				count := count + 1;
			else
				count := 0;
			end if;
		end if;
	end process p0;

	p1 : process (clock_divider_1) is
		variable count : integer range 0 to L_LCDAnode-1 := 0;
	begin
		if (rising_edge(clock_divider_1)) then
			case to_integer(unsigned(LCDChar(count))) is
				when 0 => o_seg <= "1000000"; -- 0
				when 1 => o_seg <= "1111001"; -- 1
				when 2 => o_seg <= "0100100"; -- 2
				when 3 => o_seg <= "0110000"; -- 3
				when 4 => o_seg <= "0011001"; -- 4
				when 5 => o_seg <= "0010010"; -- 5
				when 6 => o_seg <= "0000010"; -- 6
				when 7 => o_seg <= "1111000"; -- 7
				when 8 => o_seg <= "0000000"; -- 8
				when 9 => o_seg <= "0010000"; -- 9
				when 10 => o_seg <= "0001000"; -- a
				when 11 => o_seg <= "0000011"; -- b
				when 12 => o_seg <= "1000110"; -- c
				when 13 => o_seg <= "0100001"; -- d
				when 14 => o_seg <= "0000110"; -- e
				when 15 => o_seg <= "0001110"; -- f
				when others => null;
			end case;
			if (count < L_LCDAnode) then
				count := count + 1;
			else
				count := 0;
			end if;
		end if;
	end process p1;

	o_Led <= i_sw;
	o_dp <= '1'; -- off all dot points
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

