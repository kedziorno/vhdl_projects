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
	o_sda : out std_logic;
	o_scl : out std_logic
);
end power_on;

architecture Behavioral of power_on is

	component my_i2c_pc is
	port(
	i_clock : in std_logic;
	i_reset : in std_logic;
	i_slave_address : in std_logic_vector(0 to G_SLAVE_ADDRESS_SIZE-1);
	i_slave_rw : in std_logic;
	i_bytes_to_send : in std_logic_vector(0 to G_BYTE_SIZE-1);
	i_enable : in std_logic;
	o_busy : out std_logic;
	o_sda : out std_logic;
	o_scl : out std_logic
	);
	end component my_i2c_pc;
	for all : my_i2c_pc use entity WORK.my_i2c_pc(Behavioral);

	signal enable,busy : std_logic;
--	signal prev_busy : std_logic;
	signal bytes_to_send : std_logic_vector(0 to G_BYTE_SIZE-1);
	signal clock : std_logic;

begin

	clock_process : process (i_reset,i_clock) is
--	constant clock_period : time := 18.368 us;
--		constant clock_period : time := 467.36 ns;
		constant clock_period : integer := 467; -- ns
		constant board_period : integer := 20; -- ns
		constant t : integer := (clock_period / board_period);
		variable v : integer range 0 to t-1;
	begin
		if (i_reset = '1') then
			v := 0;
			clock <= '0';
			report integer'image(clock_period) & "," & integer'image(board_period) & "," & integer'image(t);
		elsif (rising_edge(i_clock)) then
			if (v = t-1) then
				v := 0;
				clock <= '1';
			else
				v := v + 1;
				clock <= '0';
			end if;
		end if;
	end process clock_process;

	my_i2c_entity : my_i2c_pc
	PORT MAP (
		i_clock => clock,
		i_reset => i_reset,
		i_slave_address => "0111100",
		i_slave_rw => '1',
		i_bytes_to_send => bytes_to_send,
		i_enable => enable,
		o_busy => busy,
		o_sda => o_sda,
		o_scl => o_scl
	);

--	p1 : process (i_reset,i_clock) is
--	begin
--		if (i_reset = '1') then
--			prev_busy <= '0';
--		elsif (rising_edge(i_clock)) then
--			prev_busy <= busy;
--		end if;
--	end process p1;

	p0 : process (busy,i_reset) is
		variable v1 : integer;
	begin
		if (i_reset = '1') then
			enable <= '1';
			v1 := 0;
			bytes_to_send <= sequence(v1);
		elsif (rising_edge(busy)) then
--			prev_busy <= busy;
--			if (prev_busy = '0' and busy = '1') then
				bytes_to_send <= sequence(v1);
--			else
				if (v1 = BYTES_SEQUENCE_LENGTH-1) then
					v1 := 0;
					enable <= '0';
--					if (prev_busy = '1' and busy = '0') then
--						enable <= '0';
--					else
--						enable <= '1';
--					end if;
				else
					v1 := v1 + 1;
					enable <= '1';
--					if (prev_busy = '0' and busy = '1') then
--						enable <= '0';
--					else
--						enable <= '1';
--					end if;
				end if;
--			end if;
		end if;
	end process;

end Behavioral;
