----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:25:12 11/28/2021 
-- Design Name: 
-- Module Name:    weirdboyjim_uart - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity weirdboyjim_uart is
end weirdboyjim_uart;

-- https://easyeda.com/weirdboyjim/UART
architecture Behavioral of weirdboyjim_uart is

	component ic_74hct32 is
	port (
		i_1a,i_1b : in std_logic;
		o_1y : out std_logic;
		i_2a,i_2b : in std_logic;
		o_2y : out std_logic;
		i_3a,i_3b : in std_logic;
		o_3y : out std_logic;
		i_4a,i_4b : in std_logic;
		o_4y : out std_logic
	);
	end component ic_74hct32;
	for all : ic_74hct32 use entity WORK.ic_74hct32(Behavioral);

	signal txDataReady : std_logic;
	signal TFcount_slv30 : std_logic_vector(3 downto 0);
	signal u9_1a,u9_1b,u9_2a,u9_2b,u9_3a,u9_3b,u9_4a,u9_4b,u9_1y,u9_2y,u9_3y,u9_4y : std_logic;
begin

	U9_inst : ic_74hct32 port map (
		i_1a => u9_1a, i_1b => u9_1b, o_1y => u9_1y,
		i_2a => u9_2a, i_2b => u9_2b, o_2y => u9_2y,
		i_3a => u9_3a, i_3b => u9_3b, o_3y => u9_3y,
		i_4a => u9_4a, i_4b => u9_4b, o_4y => u9_4y
	);

	U9_connect1 : u9_1a <= u9_4y;
	U9_connect2 : u9_1b <= u9_3y;
	U9_connect3 : txDataReady <= u9_1y;
	U9_connect4 : u9_2a <= '0';
	U9_connect5 : u9_2b <= '0';
	--U9_connect6 : u9_2y <= 'X';
	U9_connect7 : u9_4b <= TFcount_slv30(3);
	U9_connect8 : u9_4a <= TFcount_slv30(2);
	U9_connect9 : u9_3b <= TFcount_slv30(1);
	U9_connect10 : u9_3a <= TFcount_slv30(0);

end Behavioral;

