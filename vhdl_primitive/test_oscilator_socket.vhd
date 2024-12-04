----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:25:20 07/02/2021 
-- Design Name: 
-- Module Name:    test_oscilator_socket - Behavioral 
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

entity test_oscilator_socket is
port (
i_clock : in std_logic;
i_reset : in std_logic;
o_led : out std_logic
);
end test_oscilator_socket;

architecture Behavioral of test_oscilator_socket is

component counter_ping is
generic (
	max : integer := 1
);
port (
	i_clock : in std_logic;
	i_reset : in std_logic;
	o_ping : out std_logic
);
end component counter_ping;

begin

u0 : counter_ping
generic map (
--	max => 50_000_000
	max => 8_000_000
)
port map (
	i_clock => i_clock,
	i_reset => i_reset,
	o_ping => o_led
);

end Behavioral;
