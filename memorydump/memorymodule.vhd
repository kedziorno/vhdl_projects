----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:11:00 11/28/2020
-- Design Name: 
-- Module Name:    /home/user/workspace/vhdl_projects/memorymodule/memorymodule.vhd
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
use WORK.p_constants.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memorymodule is
Port (
i_clock : in std_logic;
i_reset : in std_logic;
i_enable : in std_logic;
i_read : in std_logic;
o_busy : out std_logic;
i_MemAdr : in MemoryAddressALL;
i_MemDB : in MemoryDataByte;
o_MemDB : out MemoryDataByte;
io_MemOE : out std_logic;
io_MemWR : out std_logic;
io_RamAdv : out std_logic;
io_RamCS : out std_logic;
io_RamLB : out std_logic;
io_RamCRE : out std_logic;
io_RamUB : out std_logic;
io_RamClk : out std_logic;
io_MemAdr : out MemoryAddressALL;
io_MemDB : inout MemoryDataByte
);
end memorymodule;

architecture Behavioral of memorymodule is

	type state is (
	idle,
	start,
	read_setup,
	read_current,
	read_wait,
	stop
	);
	signal cstate : state;

	signal MemOE : std_logic;
	signal MemWR : std_logic;
	signal RamAdv : std_logic;
	signal RamCS : std_logic;
	signal RamLB : std_logic;
	signal RamCRE : std_logic;
	signal RamUB : std_logic;
	signal RamClk : std_logic;
	signal MemAdr : MemoryAddressALL;

begin

	io_MemOE <= MemOE;
	io_MemWR <= MemWR;
	io_RamAdv <= RamAdv;
	io_RamCS <= RamCS;
	io_RamLB <= RamLB;
	io_RamCRE <= RamCRE;
	io_RamUB <= RamUB;
	io_RamClk <= RamClk;
	io_MemAdr <= MemAdr;

	RamLB <= '0';
	RamUB <= '0';
	RamCRE <= '0';
	RamAdv <= '0';
	RamClk <= '0';

	MemAdr <= i_MemAdr when (RamCS = '0' and (MemWR = '0' or MemOE = '0')) else (others => 'Z');
	o_MemDB <= io_MemDB when (cstate = idle) else (others => 'Z');
	io_MemDB <= i_MemDB when (RamCS = '0' and MemWR = '0') else (others => 'Z');

	p0 : process (i_clock,i_reset) is
		constant cw : integer := (G_BOARD_CLOCK/G_BAUD_RATE);
		variable w : integer range 0 to cw-1;
		variable t : std_logic_vector(G_MemoryData-1 downto 0);
		variable tz : std_logic_vector(G_MemoryData-1 downto 0);
	begin
		if (i_reset = '1') then
			w := 0;
			t := (others => '0');
			tz := (others => 'Z');
			RamCS <= '1';
			MemWR <= '1';
			MemOE <= '1';
		elsif (rising_edge(i_clock)) then
			if (w = cw-1) then
				w := 0;
			else
				w := w + 1;
			end if;
			case cstate is
				when idle =>
					if (i_enable = '1') then
						cstate <= start; -- XXX check CSb
					else
						cstate <= idle;
					end if;
				when start =>
					if (i_read = '1') then
						cstate <= read_setup;
					else
						cstate <= start;
					end if;
					RamCS <= '1';
					MemWR <= '1';
					MemOE <= '1';
				when read_setup =>
					if (w = cw-1) then
						cstate <= read_current;
						RamCS <= '0';
						MemOE <= '1';
						o_busy <= '1';
					else
						cstate <= read_setup;
					end if;
				when read_current =>
					cstate <= read_wait;
					MemOE <= '0';
					w := 0;
				when read_wait =>
					if (w = cw-1) then
						cstate <= stop;
					else
						cstate <= read_wait;
					end if;
				when stop =>
					cstate <= idle;
					o_busy <= '0';
					RamCS <= '1';
					MemOE <= '1';
				when others => null;
			end case;
		end if;
	end process p0;

end Behavioral;
