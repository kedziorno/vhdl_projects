----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:15:50 01/29/2021 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
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

entity top is
Port (
	clk : in STD_LOGIC;
	btn0 : in STD_LOGIC;
	RsTx : out STD_LOGIC;
	JA : inout STD_LOGIC_VECTOR(7 downto 0);
	JB : inout STD_LOGIC_VECTOR(7 downto 0);
	JC : inout STD_LOGIC_VECTOR(7 downto 0);
	JD : inout STD_LOGIC_VECTOR(7 downto 0)
);
end top;

architecture Behavioral of top is

	COMPONENT rs232 is
	GENERIC (
		G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
		G_BAUD_RATE : integer := G_BAUD_RATE
	);
	PORT(
		clk : IN  std_logic;
		rst : IN  std_logic;
		enable : in  STD_LOGIC;
		byte_to_send : IN  std_logic_vector (NUMBER_BITS-1 downto 0);
		busy : OUT  std_logic;
		ready : OUT  std_logic;
		RsTx : OUT  std_logic
	);
	END COMPONENT rs232;

	COMPONENT memorymodule IS
	Port (
		i_clock : in std_logic;
		i_enable : in std_logic;
		i_write : in std_logic;
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
	END COMPONENT memorymodule;

	signal reset : std_logic;
	signal busy,ready : std_logic;	
	signal enable : std_logic;
	signal data_in : MemoryDataByte;

--	-- XXX test pattern
--	constant ARRAY_LENGTH : integer := 11;
--	type ARRAY_BYTES is array(0 to ARRAY_LENGTH-1) of std_logic_vector(NUMBER_BITS-1 downto 0);
--	signal bytes : ARRAY_BYTES := (x"30",x"31",x"32",x"33",x"34",x"35",x"36",x"37",x"38",x"39",x"20");

	type state_type is (st_send,st_memory_enable,st_memory_read_enable,st_memory_wait0,st_memory_read_disable,st_memory_disable,st_increment,st_waiting,st_send_nl,st_increment_nl,st_waiting_nl);
	signal state : state_type := st_send;

	signal memory_address_out,memory_address,memory_address_max : MemoryAddressALL;
	signal memory_data_in,memory_data_null : MemoryDataByte;
	signal memory_ce : std_logic;
	signal memory_oe : std_logic;
	signal memory_enable,memory_read,memory_busy : std_logic;

begin

	reset <= btn0;

	JA(0) <= memory_ce;
	JA(1) <= memory_oe;
	memory_data_in(0) <= JD(0);
	memory_data_in(1) <= JD(1);
	memory_data_in(2) <= JD(2);
	memory_data_in(3) <= JD(3);
	memory_data_in(4) <= JD(4);
	memory_data_in(5) <= JD(5);
	memory_data_in(6) <= JD(6);
	memory_data_in(7) <= JD(7);
	JB(0) <= memory_address_out(0);
	JB(1) <= memory_address_out(1);
	JB(2) <= memory_address_out(2);
	JB(3) <= memory_address_out(3);
	JB(4) <= memory_address_out(4);
	JB(5) <= memory_address_out(5);
	JB(6) <= memory_address_out(6);
	JB(7) <= memory_address_out(7);
	JC(0) <= memory_address_out(8);
	JC(1) <= memory_address_out(9);
	JC(2) <= memory_address_out(10);
	JC(3) <= memory_address_out(11);
	JC(4) <= memory_address_out(12);
	JC(5) <= memory_address_out(13);
	JC(6) <= memory_address_out(14);
	JC(7) <= memory_address_out(15);

	mm: memorymodule
	PORT MAP (
		i_clock => clk,
		i_enable => memory_enable,
		i_write => '0',
		i_read => memory_read,
		o_busy => memory_busy,
		i_MemAdr => memory_address,
		i_MemDB => memory_data_null,
		o_MemDB => open,
		io_MemOE => memory_oe,
		io_MemWR => open,
		io_RamAdv => open,
		io_RamCS => memory_ce,
		io_RamLB => open,
		io_RamCRE => open,
		io_RamUB => open,
		io_RamClk => open,
		io_MemAdr => memory_address_out,
		io_MemDB => open
	);

	uut_rs232 : rs232
	GENERIC MAP (
		G_BOARD_CLOCK => G_BOARD_CLOCK,
		G_BAUD_RATE => G_BAUD_RATE
	)
	PORT MAP (
		clk => clk,
		rst => reset,
		enable => enable,
		byte_to_send => data_in,
		busy => busy,
		ready => ready,
		RsTx => RsTx
	);

	p0 : process (clk,reset) is
--		variable index : integer range 0 to ARRAY_LENGTH-1 := 0; -- XXX test pattern
	begin
		if (reset = '1') then
--			index := 0; -- XXX test pattern
			state <= st_send;
			enable <= '0';
			memory_address_max <= (others => '1');
			memory_address <= (others => '0');
			memory_data_null <= (others => '0');
			memory_enable <= '0';
			memory_read <= '0';
		elsif (rising_edge(clk)) then
			case (state) is
				when st_memory_enable =>
					state <= st_memory_read_enable;
					memory_enable <= '1';
				when st_memory_read_enable =>
					state <= st_memory_wait0;
					memory_read <= '1';
					if (memory_address = memory_address_max) then
						memory_address <= (others => '0');
					else
						memory_address <= std_logic_vector(to_unsigned(to_integer(unsigned(memory_address) + 1),G_MemoryAddress));
					end if;
				when st_memory_wait0 =>
					if (memory_busy = '1') then
						state <= st_memory_wait0;
					else
						state <= st_memory_read_disable;
					end if;
				when st_memory_read_disable =>
					state <= st_memory_disable;
					memory_read <= '0';
				when st_memory_disable =>
					state <= st_send;
					memory_enable <= '0';
--					memory_data_in <= not bytes(index); -- XXX test pattern
				when st_send =>
					--REPORT integer'image(G_BOARD_CLOCK) SEVERITY NOTE;
					enable <= '1';
					if (ready = '1') then
--						data_in <= not bytes(index); -- XXX test pattern
--						data_in <= memory_data_in; -- XXX test pattern
						data_in <= not memory_data_in;
						state <= st_increment;
					end if;
				when st_increment =>
					if (ready = '0') then
						state <= st_waiting;
--						if (index < ARRAY_LENGTH-1) then -- XXX test pattern
--							index := index + 1;
--						else
--							index := 0;
--						end if;
					end if;
				when st_waiting =>
					if (busy = '1') then
						enable <= '0';
						state <= st_waiting;
					else
						state <= st_send_nl;
					end if;
				when st_send_nl =>
					if (memory_address = std_logic_vector(to_unsigned(to_integer(unsigned(memory_address_max)),G_MemoryAddress))) then
						enable <= '1';
						if (ready = '1') then
							state <= st_increment_nl;
							data_in <= not x"0A";
						end if;
					else
						state <= st_memory_enable;
					end if;
				when st_increment_nl =>
					if (ready = '0') then
						state <= st_waiting_nl;
					end if;
				when st_waiting_nl =>
					if (busy = '1') then
						enable <= '0';
						state <= st_waiting_nl;
					else
						state <= st_memory_enable;
					end if;
			end case;
		end if;
	end process p0;

end Behavioral;
