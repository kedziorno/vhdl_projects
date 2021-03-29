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
i_reset : in std_logic;
i_enable : in std_logic;
i_write : in std_logic;
i_read : in std_logic;
o_busy : out std_logic;
i_db_fs : in std_logic;
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
	signal MemAdr : MemoryAddressALL;
	signal MemDB : MemoryDataByte;

    signal mc : MEMORY;

begin

	io_MemOE <= MemOE;
	io_MemWR <= MemWR;
	io_RamAdv <= RamAdv;
	io_RamCS <= RamCS;
	io_RamLB <= RamLB;
	io_RamCRE <= RamCRE;
	io_RamUB <= RamUB;
	io_RamClk <= RamClk;
	--io_MemAdr <= MemAdr;
--    o_MemDB <= MemDB;

	RamLB <= '0';
	RamUB <= '0';
	RamCRE <= '0';
	RamAdv <= '0';
	RamClk <= '0';

	--io_MemDB <= i_MemDB when (RamCS = '0' and MemWR = '0') else (others => 'Z');
    --mc(to_integer(unsigned(MemAdr)))(16 to 31) <= i_MemDB when (to_integer(unsigned(MemAdr)) mod 2 = 1) else (others => 'Z');
    --mc(to_integer(unsigned(MemAdr)))(0  to 15) <= i_MemDB when (to_integer(unsigned(MemAdr)) mod 2 = 0) else (others => 'Z');
--    o_MemDB <= mc(to_integer(unsigned(MemAdr)))(16 to 31) when (to_integer(unsigned(MemAdr)) mod 2 = 1) else (others => 'Z');
--    o_MemDB <= mc(to_integer(unsigned(MemAdr)))(0  to 15) when (to_integer(unsigned(MemAdr)) mod 2 = 0) else (others => 'Z');
     
	p0 : process (i_clock,i_reset) is
		constant cw : integer := 6;
		variable w : integer range 0 to cw := 0;
		variable t : std_logic_vector(G_MemoryData-1 downto 0);
		variable tz : std_logic_vector(G_MemoryData-1 downto 0) := (others => 'Z');
		variable ima : integer;
		variable mdb : MemoryDataByte;
	begin
	    ima := to_integer(unsigned(i_MemAdr));
        if (i_reset = '1') then
            cstate <= idle;
	       --MemAdr <= (others => '0');
	       MemOE <= '1';
           MemWR <= '1';
           RamCS <= '1';
           mc <= (others => (others => '0'));
        elsif (rising_edge(i_clock)) then
--            if (to_integer(unsigned(i_MemAdr)) mod 2 = 1) then
--                mc(to_integer(unsigned(i_MemAdr)))(16 to 31) <= i_MemDB;
--            end if;
--            if (to_integer(unsigned(i_MemAdr)) mod 2 = 0) then
--                mc(to_integer(unsigned(i_MemAdr)))(0 to 15) <= i_MemDB;            
--            end if;
--            if (to_integer(unsigned(i_MemAdr)) mod 2 = 1) then
--                MemDB <= mc(to_integer(unsigned(i_MemAdr)))(16 to 31);
--            end if;
--            if (to_integer(unsigned(i_MemAdr)) mod 2 = 0) then
--                MemDB <= mc(to_integer(unsigned(i_MemAdr)))(0 to 15);            
--            end if;
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
					w := cw;
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
					case (i_db_fs) is
                      when '0' =>
                          mc(ima)(16 to 31) <= i_MemDB;
                      when '1' =>
                          mc(ima)(0 to 15) <= i_MemDB;
                      when others => null;
                    end case;
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
					w := cw;
				when wait2 =>
				   case (i_db_fs) is
                      when '0' =>
                          mdb := mc(ima)(16 to 31);
                      when '1' =>
                          mdb := mc(ima)(0 to 15); 
                      when others => null;
                    end case;
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
		o_MemDB <= mdb;
	end process p0;

end Behavioral;
