----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:20:23 07/01/2021 
-- Design Name: 
-- Module Name:    transmission_gate_rl - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity transmission_gate_rl is
generic (
	delay_ba : time := 0 ns;
	delay_baz : time := 0 ns
);
port (
	io_a : inout std_logic;
	io_b : in std_logic;
	i_s : in std_logic;
	i_sb : in std_logic
);
end transmission_gate_rl;

architecture Behavioral of transmission_gate_rl is
begin
	io_a <= io_b after delay_ba when i_s = '0' and i_sb = '1' else 'Z' after delay_baz when i_s = '1' and i_sb = '0';
end Behavioral;
