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
		g_divider : integer := 1
	);
	Port (
		i_reset : in STD_LOGIC;
		i_clock : in STD_LOGIC;
		o_clock : out STD_LOGIC
	);
	END COMPONENT clock_divider_count;

	COMPONENT clock_divider_sub is
	Port(
		i_clk : in STD_LOGIC;
		i_rst : in STD_LOGIC;
		i_board_clock : in INTEGER;
		i_divider : in INTEGER;
		o_clk : out STD_LOGIC
	);
	END COMPONENT clock_divider_sub;

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

	COMPONENT fifo is
	Generic (
		WIDTH : integer := FIFO_WIDTH;
		HEIGHT : integer := FIFO_HEIGHT
	);
	Port (
		i_clk1 : in  STD_LOGIC;
		i_clk2 : in  STD_LOGIC;
		i_rst : in  STD_LOGIC;
		i_data : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
		o_data : out  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
		o_full : out  STD_LOGIC;
		o_empty : out  STD_LOGIC;
		o_memory_index : out  std_logic_vector(HEIGHT-1 downto 0)
	);
	END COMPONENT fifo;

	signal reset : std_logic;
	signal o_clk_count,o_clk_sub : std_logic;
	signal busy,ready : std_logic;	
	signal enable : std_logic;
	signal byte_to_send : std_logic_vector (NUMBER_BITS-1 downto 0);
	signal rx : std_logic;
	signal tx : std_logic;
	signal data_in : STD_LOGIC_VECTOR(FIFO_WIDTH-1 downto 0);
	signal data_out : STD_LOGIC_VECTOR(FIFO_WIDTH-1 downto 0);
	signal full : std_logic;
	signal empty : std_logic;
	signal memory_index : std_logic_vector(FIFO_HEIGHT-1 downto 0);

	constant ARRAY_LENGTH : integer := 10;
	type ARRAY_BYTES is array(0 to ARRAY_LENGTH-1) of std_logic_vector(NUMBER_BITS-1 downto 0);
--	signal bytes : ARRAY_BYTES := (x"41",x"42",x"43",x"44",x"45",x"46",x"47",x"48",x"49",x"50");
--	signal bytes : ARRAY_BYTES := (x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF");
	signal bytes : ARRAY_BYTES := (x"AA",x"AA",x"AA",x"AA",x"AA",x"AA",x"AA",x"AA",x"AA",x"AA");

	constant C_WAIT0 : integer := G_BOARD_CLOCK/G_BAUD_RATE/10;
	signal wait0 : integer range 0 to C_WAIT0 - 1;

	type state_type is (idle,send,increment,waiting);
	signal state : state_type := idle;

begin

	reset <= btn0;

	uut_clock_divider_count : clock_divider_count
	GENERIC MAP ( g_board_clock => G_BOARD_CLOCK, g_divider => G_BOARD_CLOCK/G_BAUD_RATE )
	PORT MAP (
		i_reset => reset,
		i_clock => clk,
		o_clock => o_clk_count
	);

	uut_clock_divider_sub : clock_divider_sub
	PORT MAP(
		i_clk => clk,
		i_rst => reset,
		i_board_clock => G_BOARD_CLOCK,
		i_divider => G_BOARD_CLOCK/2,
		o_clk => o_clk_sub
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

	uut_fifo : fifo
	PORT MAP (
		i_rst => reset,
		i_clk1 => o_clk_count,
		i_clk2 => o_clk_count,
		i_data => data_in,
		o_data => data_out,
		o_full => full,
		o_empty => empty,
		o_memory_index => memory_index
	);

	p0 : process (clk,reset) is
		variable index : integer range 0 to ARRAY_LENGTH-1 := 0;
	begin
		if (reset = '1') then
			state <= idle;
			enable <= '0';
			--data_in <= x"00";
			index := 0;
			wait0 <= 0;
		elsif (rising_edge(clk)) then
			case (state) is
				when idle =>
					if (ready = '1') then
						state <= send;
					end if;
				when send =>
					if (ready = '1') then
						enable <= '1';
						data_in <= bytes(index);
						state <= increment;
					end if;
				when increment =>
					state <= waiting;
					enable <= '0';
					if (index < ARRAY_LENGTH-1) then
						index := index + 1;
					else
						index := 0;
					end if;
				when waiting =>
--					if (busy = '1') then
--						state <= waiting;
--					else
--						state <= idle;
--					end if;
					if (wait0 < C_WAIT0) then
						state <= waiting;
						wait0 <= wait0 + 1;
						enable <= '0';
					else
						wait0 <= 0;
						state <= idle;
					end if;
			end case;
		end if;
	end process p0;

end Behavioral;
