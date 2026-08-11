----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:59:41 06/21/2021 
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
use WORK.p_package.ALL;
use WORK.p_screen.ALL;
use WORK.p_rom_data.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	o_cs : out std_logic;
	o_do : out std_logic;
	o_ck : out std_logic;
	o_reset : out std_logic;
	o_rs : out std_logic
);
end top;

architecture Behavioral of top is

	component my_spi is
	port (
		i_clock : in std_logic;
		i_reset : in std_logic;
		i_enable : in std_logic;
		i_data_byte : in BYTE_TYPE;
		o_cs : out std_logic;
		o_do : out std_logic;
		o_ck : out std_logic;
		o_sended : out std_logic
	);
	end component my_spi;
	signal spi_enable,spi_cs,spi_do,spi_ck,spi_sended : std_logic;
	signal spi_data_byte : BYTE_TYPE;

	component initialize is
	port (
		i_clock : in std_logic;
		i_reset : in std_logic;
		i_run : in std_logic;
		i_color : in COLOR_TYPE;
		i_sended : in std_logic;
		o_initialized : out std_logic;
		o_enable : out std_logic;
		o_reset : out std_logic;
		o_rs : out std_logic;
		o_cs : out std_logic;
		o_data_byte : out BYTE_TYPE
	);
	end component initialize;
	signal initialize_run,initialize_sended : std_logic;
	signal initialize_initialized,initialize_enable,initialize_reset,initialize_rs,initialize_cs : std_logic;
	signal initialize_color : COLOR_TYPE;
	signal initialize_data_byte : BYTE_TYPE;

	component draw_box is
	port (
		i_clock : in std_logic;
		i_reset : in std_logic;
		i_run : in std_logic;
		i_sended : in std_logic;
		i_color : in COLOR_TYPE;
		i_raxs : in BYTE_TYPE;
		i_raxe : in BYTE_TYPE;
		i_rays : in BYTE_TYPE;
		i_raye : in BYTE_TYPE;
		i_caxs : in BYTE_TYPE;
		i_caxe : in BYTE_TYPE;
		i_cays : in BYTE_TYPE;
		i_caye : in BYTE_TYPE;
		o_data : out BYTE_TYPE;
		o_enable : out std_logic;
		o_rs : out std_logic;
		o_initialized : out std_logic
	);
	end component draw_box;
	signal drawbox_sended,drawbox_enable,drawbox_rs,drawbox_run,drawbox_initialized : std_logic;
	signal drawbox_raxs,drawbox_raxe,drawbox_rays,drawbox_raye,drawbox_caxs,drawbox_caxe,drawbox_cays,drawbox_caye : BYTE_TYPE;
	signal drawbox_data : BYTE_TYPE;
	signal drawbox_color : COLOR_TYPE;

	type states is (
	idle,
	start,get_instruction,execute_instruction,
	get_color,screen_initialize,screen_initialize_finish,
	get_draw_box,
	get_draw_box_c1,get_draw_box_c2,get_draw_box_c3,get_draw_box_c4,get_draw_box_c5,get_draw_box_c6,get_draw_box_c7,get_draw_box_c8,
	get_draw_box_finish,
	stop);
	signal state : states;

	signal index0 : integer range 0 to COUNT_ROM_DATA - 1;
	signal byte_instruciton : BYTE_TYPE;

begin

	o_cs <= spi_cs; -- TODO use initialize_cs mux
	o_do <= spi_do;
	o_ck <= spi_ck;
	o_reset <= initialize_reset when initialize_run = '1' else '1';
	o_rs <= initialize_rs when initialize_run = '1' else drawbox_rs when drawbox_run = '1' else '1';

	spi_data_byte <= initialize_data_byte when initialize_run = '1' else drawbox_data when drawbox_run = '1' else (others => '0');
	spi_enable <= initialize_enable when initialize_run = '1' else drawbox_enable when drawbox_run = '1' else '0';
	initialize_sended <= spi_sended when initialize_run = '1' else '0';
	drawbox_sended <= spi_sended when drawbox_run = '1' else '0';

	c0 : my_spi
	port map (
		i_clock => i_clock,
		i_reset => i_reset,
		i_enable => spi_enable,
		i_data_byte => spi_data_byte,
		o_cs => spi_cs,
		o_do => spi_do,
		o_ck => spi_ck,
		o_sended => spi_sended
	);

	c1 : initialize
	port map (
		i_clock => i_clock,
		i_reset => i_reset,
		i_run => initialize_run,
		i_color => initialize_color,
		i_sended => initialize_sended,
		o_initialized => initialize_initialized,
		o_cs => initialize_cs,
		o_reset => initialize_reset,
		o_rs => initialize_rs,
		o_enable => initialize_enable,
		o_data_byte => initialize_data_byte
	);

	c2 : draw_box
	port map (
		i_clock => i_clock,
		i_reset => i_reset,
		i_run => drawbox_run,
		i_sended => drawbox_sended,
		i_color => drawbox_color,
		i_raxs => drawbox_raxs,
		i_raxe => drawbox_raxe,
		i_rays => drawbox_rays,
		i_raye => drawbox_raye,
		i_caxs => drawbox_caxs,
		i_caxe => drawbox_caxe,
		i_cays => drawbox_cays,
		i_caye => drawbox_caye,
		o_data => drawbox_data,
		o_enable => drawbox_enable,
		o_rs => drawbox_rs,
		o_initialized => drawbox_initialized
	);

	p1 : process (byte_instruciton,initialize_run,drawbox_run) is -- TODO use mux
	begin
		if (initialize_run = '1' or drawbox_run = '1') then
			case (byte_instruciton) is
				when x"00" =>
					initialize_color <= SCREEN_BLACK;
					drawbox_color <= SCREEN_BLACK;
				when x"01" =>
					initialize_color <= SCREEN_BLUE;
					drawbox_color <= SCREEN_BLUE;
				when x"02" =>
					initialize_color <= SCREEN_RED;
					drawbox_color <= SCREEN_RED;
				when x"03" =>
					initialize_color <= SCREEN_GREEN;
					drawbox_color <= SCREEN_GREEN;
				when x"04" =>
					initialize_color <= SCREEN_CYAN;
					drawbox_color <= SCREEN_CYAN;
				when x"05" =>
					initialize_color <= SCREEN_MAGENTA;
					drawbox_color <= SCREEN_MAGENTA;
				when x"06" =>
					initialize_color <= SCREEN_YELLOW;
					drawbox_color <= SCREEN_YELLOW;
				when x"07" =>
					initialize_color <= SCREEN_WHITE;
					drawbox_color <= SCREEN_WHITE;
				when x"08" =>
					initialize_color <= SCREEN_ORANGE;
					drawbox_color <= SCREEN_ORANGE;
				when x"09" =>
					initialize_color <= SCREEN_LIGHTGREEN;
					drawbox_color <= SCREEN_LIGHTGREEN;
				when x"0a" =>
					initialize_color <= SCREEN_LIGHTGREY;
					drawbox_color <= SCREEN_LIGHTGREY;
				when others =>
					initialize_color <= SCREEN_BLACK;
					drawbox_color <= SCREEN_BLACK;
			end case;
		else
			initialize_color <= SCREEN_BLACK;
			drawbox_color <= SCREEN_BLACK;
		end if;
	end process p1;

	p_control : process (i_clock,i_reset,initialize_initialized) is
	begin
		if (i_reset = '1') then
			state <= idle;
		elsif (rising_edge(i_clock)) then
			case (state) is
				when idle =>
					state <= start;
					byte_instruciton <= (others => '0');
					initialize_run <= '0';
					drawbox_run <= '0';
					index0 <= 0;
					drawbox_raxs <= (others => '0');
					drawbox_raxe <= (others => '0');
					drawbox_rays <= (others => '0');
					drawbox_raye <= (others => '0');
					drawbox_caxs <= (others => '0');
					drawbox_caxe <= (others => '0');
					drawbox_cays <= (others => '0');
					drawbox_caye <= (others => '0');
				when start =>
					state <= get_instruction;
				when get_instruction =>
					state <= execute_instruction;
					byte_instruciton <= C_ROM_DATA(index0);
					index0 <= index0 + 1;
				when execute_instruction =>
					case (byte_instruciton) is
						when x"00" =>
							state <= get_instruction;
						when x"01" =>
							state <= get_color;
						when x"02" =>
							state <= get_draw_box;
						when others => null;
					end case;
				when get_color =>
					state <= screen_initialize;
					byte_instruciton <= C_ROM_DATA(index0);
					index0 <= index0 + 1;
					initialize_run <= '1';
				when screen_initialize =>
					if (initialize_initialized = '1') then
						state <= screen_initialize_finish;
						initialize_run <= '0';
					else
						state <= screen_initialize;
					end if;
				when screen_initialize_finish =>
					state <= start;
				when get_draw_box =>
					state <= get_draw_box_c1;
					byte_instruciton <= C_ROM_DATA(index0);
					index0 <= index0 + 1;
					drawbox_run <= '1';
				when get_draw_box_c1 =>
					state <= get_draw_box_c2;
					drawbox_raxs <= x"00";
				when get_draw_box_c2 =>
					state <= get_draw_box_c3;
					drawbox_raxe <= C_ROM_DATA(index0);
					index0 <= index0 + 1;
				when get_draw_box_c3 =>
					state <= get_draw_box_c4;
					drawbox_rays <= x"00";
				when get_draw_box_c4 =>
					state <= get_draw_box_c5;
					drawbox_raye <= C_ROM_DATA(index0);
					index0 <= index0 + 1;
				when get_draw_box_c5 =>
					state <= get_draw_box_c6;
					drawbox_caxs <= x"00";
				when get_draw_box_c6 =>
					state <= get_draw_box_c7;
					drawbox_caxe <= C_ROM_DATA(index0);
					index0 <= index0 + 1;
				when get_draw_box_c7 =>
					state <= get_draw_box_c8;
					drawbox_cays <= x"00";
				when get_draw_box_c8 =>
					state <= get_draw_box_finish;
					drawbox_caye <= C_ROM_DATA(index0);
					index0 <= index0 + 1;
				when get_draw_box_finish =>
					if (drawbox_initialized = '1') then
						state <= stop;
						drawbox_run <= '0';
					else
						state <= get_draw_box_finish;
					end if;
				when stop =>
					if (index0 = COUNT_ROM_DATA - 1) then
						state <= stop;
					else
						state <= start;
					end if;
				when others =>
					state <= idle;
			end case;
		end if;
	end process p_control;

end Behavioral;

