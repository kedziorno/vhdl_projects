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
use WORK.p_memory_content.ALL;

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
i_enable : in std_logic;
i_write : in std_logic;
i_read : in std_logic;
o_busy : out std_logic;
i_MemAdr : in MemoryAddress;
i_MemDB : in MemoryDataByte;
o_MemDB : out MemoryDataByte;
o_MemOE : out std_logic;
o_MemWR : out std_logic;
o_RamAdv : out std_logic;
o_RamCS : out std_logic;
o_RamCRE : out std_logic;
o_RamLB : out std_logic;
o_RamUB : out std_logic;
--i_RamWait : in std_logic;
o_RamClk : out std_logic;
o_MemAdr : out MemoryAddress;
io_MemDB : inout MemoryDataByte
);
end memorymodule;

architecture Behavioral of memorymodule is

	type state is (
	idle,
	start,
	write_setup,
	read_setup,
	write_enable,
	wait1,
	write_disable,
	stop,
	read1,
	wait2
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
	signal MemAdr : MemoryAddress;

begin

	o_MemOE <= MemOE;
	o_MemWR <= MemWR;
	o_RamAdv <= RamAdv;
	o_RamCS <= RamCS;
	o_RamCRE <= RamCRE;
	o_RamLB <= RamLB;
	o_RamUB <= RamUB;
	o_RamClk <= RamClk;
	o_MemAdr <= MemAdr;

	RamLB <= '0';
	RamUB <= '0';
	RamCRE <= '0';
	RamAdv <= '0';
	RamClk <= '0';

	MemAdr <= i_MemAdr when (RamCS = '0' and (MemWR = '0' or MemOE = '0')) else (others => 'Z');
	o_MemDB <= io_MemDB;
	io_MemDB <= i_MemDB when (RamCS = '0' and MemWR = '0') else (others => 'Z');

	p0 : process (i_clock) is
		constant cw : integer := 3; -- XXX 3 is lowlest for properly mm working
		variable w : integer range 0 to cw - 1 := 0;
		variable t : std_logic_vector(G_MemoryData-1 downto 0);
	begin
		if (rising_edge(i_clock)) then
			if (w > 0) then
				w := w - 1;
			end if;
			case cstate is
				when idle =>
					if (i_enable = '1') then
						cstate <= start; -- XXX check CSb
					else
						cstate <= idle;
					end if;
				when start =>
					if (i_write = '1') then
						cstate <= write_setup;
					elsif (i_read = '1') then
						cstate <= read_setup;
					else
						cstate <= start;
					end if;
					RamCS <= '1';
					MemWR <= '1';
					MemOE <= '1';
				when write_setup =>
					if (w = 0) then
						cstate <= write_enable;
						o_busy <= '1';
						MemOE <= '1';
					else
						cstate <= write_setup;
					end if;
				when write_enable =>
					cstate <= wait1;
					MemWR <= '0';
					RamCS <= '0';
					w := cw - 1;
				when wait1 =>
					if (w = 0) then
						cstate <= write_disable;
					else
						cstate <= wait1;
					end if;
				when write_disable =>
					cstate <= stop;
					RamCS <= '1';
					MemWR <= '1';
				when read_setup =>
					if (w = 0) then
						cstate <= read1;
						RamCS <= '0';
						MemOE <= '0';
						o_busy <= '1';
					else
						cstate <= read_setup;
					end if;
				when read1 =>
					cstate <= wait2;
					w := cw - 1;
				when wait2 =>
					if (w = 0) then
						cstate <= stop;
					else
						cstate <= wait2;
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
