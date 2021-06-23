----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:09:37 06/23/2021 
-- Design Name: 
-- Module Name:    draw_box - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity draw_box is
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
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
	o_rs : out std_logic
);
end draw_box;

architecture Behavioral of draw_box is

	signal rs,enable : std_logic;
	signal send_data,send_command : BYTE_TYPE;
	type states is (idle,sendracmd,sendraxs,sendrays,sendraxe,sendraye,sendcacmd,sendcaxs,sendcays,sendcaxe,sendcaye,sendmemwr,fillarea,stop);
	signal state : states;

begin

	o_data <= send_command when rs = '0' else send_data when rs = '1';
	o_rs <= rs;
	
	p0 : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			state <= idle;
		elsif (rising_edge(i_clock)) then
			case (state) is
				when idle =>
					state <= sendracmd;
					enable <= '1';
				when sendracmd =>
					state <= sendraxs;
					rs <= '0';
					send_command <= x"2b"; --RASET
				when sendraxs =>
					state <= sendrays;
					rs <= '1';
					send_data <= i_raxs;
				when sendrays =>
					state <= sendraxe;
					rs <= '1';
					send_data <= i_rays;
				when sendraxe =>
					state <= sendraye;
					rs <= '1';
					send_data <= i_raxe;
				when sendraye =>
					state <= sendcacmd;
					rs <= '1';
					send_data <= i_raye;
				when sendcacmd =>
					state <= sendcaxs;
					rs <= '0';
					send_command <= x"2a"; --CASET
				when sendcaxs =>
					state <= sendcays;
					rs <= '1';
					send_data <= i_caxs;
				when sendcays =>
					state <= sendcaxe;
					rs <= '1';
					send_data <= i_cays;
				when sendcaxe =>
					state <= sendcaye;
					rs <= '1';
					send_data <= i_caxe;
				when sendcaye =>
					state <= sendmemwr;
					rs <= '1';
					send_data <= i_caye;
				when sendmemwr =>
					state <= fillarea;
					rs <= '0';
					send_command <= x"2c"; --RAMWR
				when fillarea =>
					state <= stop;
					rs <= '1';
					send_data <= i_color;
				when stop =>
					state <= idle;
					enable <= '0';
				when others =>
					state <= idle;
			end case;
		end if;
	end process p0;

end Behavioral;
