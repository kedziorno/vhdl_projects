----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:05:12 05/01/2021 
-- Design Name: 
-- Module Name:    sram_row - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity sram_row is
Generic (
	N : integer := 4
);
Port (
	i_tristate_input : in std_logic;
	i_tristate_output : in std_logic;
	i_address_col : in std_logic_vector(N-1 downto 0);
	i_bit : in std_logic;
	o_bit : out std_logic
);
end sram_row;

architecture Behavioral of sram_row is
	signal sram_column : std_logic_vector(2**N-1 downto 0);
--	signal bufi,bufo : std_logic;
begin
--BUFG_inst1 : BUFG port map (O => bufi,I => i_tristate_input);
--BUFG_inst2 : BUFG port map (O => bufo,I => i_tristate_output);
--	bufi <= not (not i_tristate_input);
--	bufo <= not (not i_tristate_output);
--	sram_column_generate : for i in sram_column'range generate
--		sram_column(i) <= i_bit when (i=to_integer(unsigned(i_address_col)) and rising_edge(i_tristate_input));
--	end generate sram_column_generate;
--	sram_column(to_integer(unsigned(i_address_col))) <= i_bit when falling_edge(bufi);
--	o_bit <= sram_column(to_integer(unsigned(i_address_col))) when falling_edge(bufo);
	sram_column(to_integer(unsigned(i_address_col))) <= i_bit when falling_edge(i_tristate_input);
	o_bit <= sram_column(to_integer(unsigned(i_address_col))) when falling_edge(i_tristate_output);
end Behavioral;
