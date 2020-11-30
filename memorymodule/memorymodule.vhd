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
use WORK.p_globals.ALL;

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
	csw_disable,
	write_enable,
	wait1,
	write_disable,
	csw_enable,
	read_setup,
	read1,
	stop
	);
	signal cstate : state;

begin

	p0 : process (i_clock) is
		constant cw : integer := 1;
		variable w : integer range 0 to cw := 0;
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
					elsif (i_read = '1') then
						cstate <= read_setup;
					else
						cstate <= idle;
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
					io_MemWR <= '1';
				when csw_enable =>
					cstate <= stop;
					io_RamCS <= '1';
				when read_setup =>
					if (w = 0) then
						cstate <= read1;
						io_RamAdv <= '0';
						io_RamLB <= '0';
						io_RamUB <= '0';
						io_MemAdr <= i_MemAdr;
						io_MemDB <= (others => 'Z');
					else
						cstate <= read_setup;
					end if;
				when read1 =>
					cstate <= stop;
					o_MemDB <= io_MemDB;
				when stop =>
					cstate <= idle;
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
	end process p0;

--	io_MemOE <= '1' when MemOE = '1' else '0' when MemOE = '0' else 'Z';
--	io_MemWR <= '1' when MemWR = '1' else '0' when MemWR = '0' else 'Z';
--	io_RamAdv <= '1' when RamAdv = '1' else '0' when RamAdv = '0' else 'Z';
--	io_RamCS <= '1' when RamCS = '1' else '0' when RamCS = '0' else 'Z';
--	io_RamLB <= '1' when RamLB = '1' else '0' when RamLB = '0' else 'Z';
--	io_RamUB <= '1' when RamUB = '1' else '0' when RamUB = '0' else 'Z';
--	io_MemAdr <= MemAdr when (io_RamCS = '0') else (others => 'Z');
--	io_MemAdr <= MemAdr;
--	io_MemDB <= MemDB_out when (io_RamCS = '0' and MemWR = '1' and MemOE = '0') else MemDB_in when (io_RamCS = '0' and MemWR = '0' and MemOE = '1') else (others => 'Z');
--	io_MemDB <= MemDB_in when (io_RamCS = '0' and io_MemOE = '1') else MemDB_out when (io_RamCS = '0' and io_MemWR = '1') else (others => 'Z');
--	io_MemDB <= MemDB_in when (io_RamCS = '0' and io_MemOE = '1') else (others => 'Z');
--	io_MemDB <= MemDB_in;
--	io_MemDB <= MemDB;

end Behavioral;

