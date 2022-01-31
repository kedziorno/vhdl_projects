----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:20:23 07/01/2021 
-- Design Name: 
-- Module Name:    transmission_gate_lr - Behavioral 
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

entity transmission_gate_lr is
port (
	io_a : in std_logic;
	io_b : out std_logic;
	i_s : in std_logic
--	i_sb : in std_logic
);
end transmission_gate_lr;

architecture Behavioral of transmission_gate_lr is
begin
	io_b <= io_a when i_s = '1' else 'Z';
end Behavioral;
