----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:47:31 08/21/2020 
-- Design Name: 
-- Module Name:    power_on - Behavioral 
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
use WORK.p_constants1.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity power_on is 
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	i_button : in std_logic;
	o_sda : out std_logic;
	o_scl : out std_logic
);
end power_on;

architecture Behavioral of power_on is

	COMPONENT my_i2c IS
	GENERIC (
		BOARD_CLOCK : INTEGER := G_BOARD_CLOCK;
		BUS_CLOCK : INTEGER := G_BUS_CLOCK
	);
	PORT (
		i_clock : in std_logic;
		i_reset : in std_logic;
		i_slave_address : std_logic_vector(0 to G_SLAVE_ADDRESS_SIZE-1);
		i_bytes_to_send : in ARRAY_BYTE_SEQUENCE;
		i_enable : in std_logic;
		o_busy : out std_logic;
		o_sda : out std_logic;
		o_scl : out std_logic
	);
	END COMPONENT my_i2c;

	signal enable,busy : std_logic;

begin

	my_i2c_entity : my_i2c
	GENERIC MAP (
		BOARD_CLOCK => G_BOARD_CLOCK,
		BUS_CLOCK => G_BUS_CLOCK
	)
	PORT MAP (
		i_clock => i_clock,
		i_reset => i_reset,
		i_slave_address => "0111100",
		i_bytes_to_send => sequence,
		i_enable => enable,
		o_busy => busy,
		o_sda => o_sda,
		o_scl => o_scl
	);

	p0 : process (i_clock,i_reset) is
	begin
		if (i_reset = '1') then
			enable <= '0';
		elsif (rising_edge(i_clock)) then
			if (i_button = '1') then
				enable <= '1';
			else
				if (busy = '1') then
					enable <= '0';
				end if;
			end if;
		end if;
	end process;

end Behavioral;
