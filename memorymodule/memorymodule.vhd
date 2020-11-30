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
io_MemOE : out std_logic;
io_MemWR : out std_logic;
io_RamAdv : out std_logic;
io_RamCS : out std_logic;
io_RamLB : out std_logic;
io_RamUB : out std_logic;
io_MemAdr : out std_logic_vector(G_MemoryAddress-1 downto 0);
io_MemDB : inout std_logic_vector(G_MemoryData-1 downto 0);
o_MemDB : out std_logic_vector(G_MemoryData-1 downto 0)
);
end memorymodule;

architecture Behavioral of memorymodule is

	type state is (
	idle,
	wait0,
	csw_disable,
	setup_write,
	write_enable,
	wait1,
	write1,
	wait2,
	write_disable,
	csw_enable,
	wait3,
	setup_read,
	wait4,
	read1,
	stop
	);
	signal cstate : state;

--	signal MemOE : std_logic := '1';
--	signal MemWR : std_logic := '1';
--	signal RamAdv : std_logic := '1';
--	signal RamCS : std_logic;
--	signal RamLB : std_logic := '0';
--	signal RamUB : std_logic := '0';
--	signal MemAdr : std_logic_vector(G_MemoryAddress-1 downto 0);
--	signal MemDB_in : std_logic_vector(G_MemoryData-1 downto 0);
--	signal MemDB_out : std_logic_vector(G_MemoryData-1 downto 0);

begin

	p0 : process (i_clock) is
		constant cw0 : integer := 1;
		constant cw1 : integer := 4;
		constant cw2 : integer := 4;
		constant cw3 : integer := 100;
		constant cw4 : integer := 4;
		variable w0 : integer range 0 to cw0 := 0;
		variable w1 : integer range 0 to cw1 := 0;
		variable w2 : integer range 0 to cw2 := 0;
		variable w3 : integer range 0 to cw3 := 0;
		variable w4 : integer range 0 to cw4 := 0;
	begin
		if (rising_edge(i_clock)) then
			if (w0 > 0) then
				w0 := w0 - 1;
			end if;
			if (w1 > 0) then
				w1 := w1 - 1;
			end if;
			if (w2 > 0) then
				w2 := w2 - 1;
			end if;
			if (w3 > 0) then
				w3 := w3 - 1;
			end if;
			if (w4 > 0) then
				w4 := w4 - 1;
			end if;
			case cstate is
				when idle =>
					--if (io_RamCS = '1') then
					--	cstate <= idle;
					--else
						cstate <= csw_enable; --csw_enable; --setup_read; --wait0;
						io_RamAdv <= '1';
						w0 := cw0;
						io_RamCS <= '1';
						io_RamLB <= '1';
						io_RamUB <= '1';
						io_MemOE <= '1';
						io_MemWR <= '1';
					--end if;
				when wait0 =>
					if (w0 = 0) then
						cstate <= csw_disable;
						io_RamAdv <= '0';
						io_RamLB <= '0';
						io_RamUB <= '0';
--						io_MemAdr <= (others => 'Z');
						io_MemAdr <= x"222222";
--						io_MemDB <= (others => 'Z');
						io_MemDB <= x"ABCD";
					else
						cstate <= wait0;
					end if;
				when csw_disable =>
					cstate <= setup_write;
					io_RamCS <= '0';
					io_MemOE <= '1';
					io_MemWR <= '1';
				when setup_write =>
					cstate <= write_enable;
					io_MemWR <= '0';
					w1 := cw1;
				when write_enable =>
					cstate <= wait1;
				when wait1 =>
					if (w1 = 0) then
						cstate <= write1;
					else
						cstate <= wait1;
					end if;
				when write1 =>
					cstate <= wait2;
					w2 := cw2;
				when wait2 =>
					if (w2 = 0) then
						cstate <= write_disable;
					else
						cstate <= wait2;
					end if;
				when write_disable =>
					cstate <= csw_enable;
					w3 := cw3;
				when csw_enable =>
					cstate <= wait3; --stop; --wait3;
					io_RamLB <= '1';
					io_RamUB <= '1';
					io_RamCS <= '1';
					io_MemWR <= '1';
					io_MemDB <= (others => 'Z');
					io_MemAdr <= (others => 'Z');
				when wait3 =>
					if (w3 = 0) then
						cstate <= setup_read;
						io_MemAdr <= x"999999";
						io_MemDB <= (others => 'Z');
					else
						cstate <= wait3;
					end if;
				when setup_read =>
--					io_MemAdr <= (others => 'Z');
					cstate <= wait4;
					io_RamAdv <= '0';
					io_RamCS <= '0';
					io_RamLB <= '0';
					io_RamUB <= '0';
					io_MemOE <= '0';
					io_MemWR <= '1';
					w4 := cw4;
				when wait4 =>
					if (w4 = 0) then
						cstate <= read1;
					else
						cstate <= wait4;
					end if;
				when read1 =>
					cstate <= stop;
					o_MemDB <= io_MemDB;
				when stop =>
					cstate <= stop;
					io_MemAdr <= (others => 'Z');
					io_RamCS <= '1';
					io_MemOE <= '1';
					io_RamLB <= '1';
					io_RamUB <= '1';
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

