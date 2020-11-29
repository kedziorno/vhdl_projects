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
i_RamClk : in std_logic;
io_MemOE : inout std_logic;
io_MemWR : inout std_logic;
io_RamAdv : inout std_logic;
io_RamCS : inout std_logic;
io_RamCRE : inout std_logic;
io_RamLB : inout std_logic;
io_RamUB : inout std_logic;
io_RamWait : in std_logic;
io_MemAdr : inout std_logic_vector(G_MemoryAddress-1 downto 0);
io_MemDB : inout std_logic_vector(G_MemoryData-1 downto 0)
);
end memorymodule;

architecture Behavioral of memorymodule is

	type state is (
	idle,
	wait0,
	csw_disable,
	setup_write,
	write_enable,
	csw_enable,
	wait1,
	write1,
	wait2,
	write_disable,
	wait3,
	setup_read,
	wait4,
	read1,
	stop
	);
	signal cstate : state;

	signal RamClk : std_logic;
	signal MemOE : std_logic := '1';
	signal MemWR : std_logic := '1';
	signal RamAdv : std_logic := '1';
	signal RamCS : std_logic;
	signal RamCRE : std_logic;
	signal RamLB : std_logic := '1';
	signal RamUB : std_logic := '1';
	signal RamWait : std_logic;
	signal MemAdr : std_logic_vector(G_MemoryAddress-1 downto 0);
	signal MemDB : std_logic_vector(G_MemoryData-1 downto 0);

begin

	p0 : process (i_RamClk) is
		constant cw0 : integer := 1;
		constant cw1 : integer := 1;
		constant cw2 : integer := 1;
		constant cw3 : integer := 10;
		constant cw4 : integer := 1;
		variable w0 : integer range 0 to cw0 := 0;
		variable w1 : integer range 0 to cw1 := 0;
		variable w2 : integer range 0 to cw2 := 0;
		variable w3 : integer range 0 to cw3 := 0;
		variable w4 : integer range 0 to cw4 := 0;
	begin
		if (rising_edge(i_RamClk)) then
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
					if (RamCS = '1') then
						cstate <= idle;
					else
						cstate <= wait0;
						RamAdv <= '0';
						w0 := cw0;
					end if;
				when wait0 =>
					if (w0 = 0) then
						cstate <= csw_disable;
						RamLB <= '0';
						RamUB <= '0';
					else
						cstate <= wait0;
					end if;
				when csw_disable =>
					cstate <= setup_write;
					MemOE <= '1';
					MemWR <= '1';
				when setup_write =>
					cstate <= write_enable;
					MemWR <= '0';
					w1 := cw1;
				when write_enable =>
					cstate <= wait1;
					MemAdr <= x"AAAAAA";
					MemDB <= x"3333";
				when wait1 =>
					if (w1 = 0) then
						cstate <= write1;
					else
						cstate <= wait1;
					end if;
				when write1 =>
					cstate <= wait2;
					MemWR <= '0';
					w2 := cw2;
				when wait2 =>
					if (w2 = 0) then
						cstate <= write_disable;
					else
						cstate <= wait2;
					end if;
				when write_disable =>
					cstate <= csw_enable;
					MemAdr <= (others => 'Z');
					MemDB <= (others => 'Z');
					w3 := cw3;
				when csw_enable =>
					cstate <= wait3;
					MemWR <= '1';
					RamLB <= '1';
					RamUB <= '1';
					RamCS <= '0';
				when wait3 =>
					if (w3 = 0) then
						cstate <= setup_read;
					else
						cstate <= wait3;
					end if;
				when setup_read =>
					MemAdr <= x"AAAAAA";
					cstate <= wait4;
					RamCS <= '0';
					RamLB <= '0';
					RamUB <= '0';
					MemOE <= '0';
					MemWR <= '1';
				when wait4 =>
					if (w4 = 0) then
						cstate <= read1;
					else
						cstate <= wait4;
					end if;
				when read1 =>
					cstate <= stop;
				when stop =>
					cstate <= idle;
					MemAdr <= (others => 'Z');
					RamCS <= '1';
					MemOE <= '1';
					RamLB <= '1';
					RamUB <= '1';
				when others => null;
			end case;
		end if;
	end process p0;

	io_MemOE <= '1' when MemOE = '1' else '0' when MemOE = '0' else 'Z';
	io_MemWR <= '1' when MemWR = '1' else '0' when MemWR = '0' else 'Z';
	io_RamAdv <= '1' when RamAdv = '1' else '0' when RamAdv = '0' else 'Z';
	io_RamCS <= '1' when RamCS = '1' else '0' when RamCS = '0' else 'Z';
	io_RamCRE <= '1' when RamCRE = '1' else '0' when RamCRE = '0' else 'Z';
	io_RamLB <= '1' when RamLB = '1' else '0' when RamLB = '0' else 'Z';
	io_RamUB <= '1' when RamUB = '1' else '0' when RamUB = '0' else 'Z';
	io_MemAdr <= MemAdr;
	io_MemDB <= MemDB;

end Behavioral;

