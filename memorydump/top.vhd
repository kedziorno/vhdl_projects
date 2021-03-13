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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port (
	clk : in  STD_LOGIC;
	btn0 : in  STD_LOGIC;
	RsTx : out  STD_LOGIC;
	RsRx : in  STD_LOGIC
);
end top;

architecture Behavioral of top is

	COMPONENT clock_divider_count is
	Generic (
		g_board_clock : integer := G_BOARD_CLOCK;
		g_divider : integer := G_BAUD_RATE
	);
	Port (
		i_reset : in STD_LOGIC;
		i_clock : in STD_LOGIC;
		o_clock : out STD_LOGIC
	);
	END COMPONENT clock_divider_count;

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
		RsTx : OUT  std_logic;
		RsRx : IN  std_logic
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
	signal o_clk_count : std_logic;
	signal busy,ready : std_logic;	
	signal enable : std_logic;
	signal data_in : STD_LOGIC_VECTOR(NUMBER_BITS-1 downto 0);

	constant ARRAY_LENGTH : integer := 11;
	type ARRAY_BYTES is array(0 to ARRAY_LENGTH-1) of std_logic_vector(NUMBER_BITS-1 downto 0);
	signal bytes : ARRAY_BYTES := (x"30",x"31",x"32",x"33",x"34",x"35",x"36",x"37",x"38",x"39",x"20");

	constant C_TIME_BR : integer := G_BOARD_CLOCK/G_BAUD_RATE;
	constant C_WAIT0 : integer := C_TIME_BR;

	signal wait0 : integer range 0 to C_WAIT0 - 1;

	type state_type is (send,increment,waiting);
	signal state : state_type := send;

begin

	reset <= btn0;

	uut_clock_divider_count : clock_divider_count
	GENERIC MAP ( g_board_clock => G_BOARD_CLOCK, g_divider => C_TIME_BR )
	PORT MAP (
		i_reset => reset,
		i_clock => clk,
		o_clock => o_clk_count
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
		RsTx => RsTx,
		RsRx => RsRx
	);

	p0 : process (clk,reset) is
		variable index : integer range 0 to ARRAY_LENGTH-1 := 0;
	begin
		if (reset = '1') then
			state <= send;
			enable <= '0';
			index := 0;
			wait0 <= 0;
		elsif (rising_edge(o_clk_count)) then
			case (state) is
				when send =>
					--REPORT integer'image(G_BOARD_CLOCK) SEVERITY NOTE;
					enable <= '1';
					if (ready = '1') then
						data_in <= not bytes(index);
						state <= increment;
					end if;
				when increment =>
					if (ready = '0') then
						state <= waiting;
						if (index < ARRAY_LENGTH-1) then
							index := index + 1;
						else
							index := 0;
						end if;
					end if;
				when waiting =>
					if (busy = '1') then
						enable <= '0';
						state <= waiting;
					else
						state <= send;
					end if;
			end case;
		end if;
	end process p0;

end Behavioral;