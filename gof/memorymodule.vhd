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
-- use IEEE.NUMERIC_STD.ALL;

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
i_MemAdr : in std_logic_vector(G_MemoryAddress-1 downto 0);
i_MemDB : in std_logic_vector(G_MemoryData-1 downto 0);
o_MemDB : out std_logic_vector(G_MemoryData-1 downto 0);
io_MemOE : out std_logic;
io_MemWR : out std_logic;
io_RamAdv : out std_logic;
io_RamCS : out std_logic;
io_RamLB : out std_logic;
io_RamUB : out std_logic;
io_MemAdr : out std_logic_vector(G_MemoryAddress-1 downto 0);
io_MemDB : inout std_logic_vector(G_MemoryData-1 downto 0)
);
end memorymodule;

architecture Behavioral of memorymodule is

	type state is (
	idle,
	start,
	write_setup,
	read_setup,
	csw_disable,
	write_enable,
	wait1,
	write_disable,
	csw_enable,
	stop,
	read1,
	wait2
	);
	signal cstate : state;

begin

	p0 : process (i_clock) is
		constant cw : integer := 3;
		variable w : integer range 0 to cw := 0;
		variable t : std_logic_vector(G_MemoryData-1 downto 0);
		variable tz : std_logic_vector(G_MemoryData-1 downto 0) := (others => 'Z');
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
					io_RamCS <= 'Z';
					io_RamLB <= 'Z';
					io_RamUB <= 'Z';
					io_MemOE <= 'Z';
					io_MemWR <= 'Z';
					io_RamAdv <= 'Z';
					io_MemAdr <= (others => 'Z');
					io_MemDB <= (others => 'Z');
					o_MemDB <= (others => 'Z');
				when start =>
					if (i_write = '1') then
						cstate <= write_setup;
						o_busy <= '1';
					elsif (i_read = '1') then
						cstate <= read_setup;
					else
						cstate <= start;
					end if;
					io_RamCS <= '1';
					io_RamLB <= '1';
					io_RamUB <= '1';
					io_MemOE <= '1';
					io_MemWR <= '1';
					io_RamAdv <= '1';
					w := cw;
				when write_setup =>
					if (w = 0) then
						cstate <= csw_disable;
						io_RamAdv <= '0';
						io_RamLB <= '0';
						io_RamUB <= '0';
						io_MemAdr <= i_MemAdr;
						io_MemDB <= i_MemDB;
					else
						cstate <= write_setup;
					end if;
				when csw_disable =>
					cstate <= write_enable;
					io_RamCS <= '0';
					io_MemOE <= '1';
					io_MemWR <= '1';
				when write_enable =>
					cstate <= wait1;
					io_MemWR <= '0';
					w := cw;
				when wait1 =>
					if (w = 0) then
						cstate <= write_disable;
					else
						cstate <= wait1;
					end if;
				when write_disable =>
					cstate <= csw_enable;
				when csw_enable =>
					cstate <= stop;
					io_RamCS <= '1';
					io_MemWR <= '1';
				when read_setup =>
					if (w = 0) then
						cstate <= read1;
						io_RamAdv <= '0';
						io_RamCS <= '0';
						io_RamLB <= '0';
						io_RamUB <= '0';
						io_MemOE <= '0';
						io_MemAdr <= i_MemAdr;
						io_MemDB <= (others => 'Z');
					else
						cstate <= read_setup;
					end if;
				when read1 =>
					cstate <= wait2;
					if (io_MemDB /= tz) then
						t := io_MemDB;
					else
						t := (others => '0');
					end if;
					w := cw;
				when wait2 =>
					if (w = 0) then
						cstate <= stop;
					else
						cstate <= wait2;
					end if;
				when stop =>
					cstate <= idle;
					o_busy <= '0';
					io_RamAdv <= '1';
					io_RamCS <= '1';
					io_MemOE <= '1';
					io_RamLB <= '1';
					io_RamUB <= '1';
					io_MemDB <= (others => 'Z');
					io_MemAdr <= (others => 'Z');
				when others => null;
			end case;
		end if;
		o_MemDB <= t;
	end process p0;

end Behavioral;
