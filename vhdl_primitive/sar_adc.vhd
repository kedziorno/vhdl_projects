----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:47:54 05/07/2021 
-- Design Name: 
-- Module Name:    sar_adc - Behavioral 
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

entity sar_adc is
Generic (
data_size : integer := 8
);
Port (
i_clock : in std_logic;
i_reset : in std_logic;
o_data : out std_logic_vector(data_size-1 downto 0);
o_to_pluscomparator : out std_logic; -- analog input on minuscomparator
i_from_comparator : in std_logic;
o_sar_end : inout std_logic
);
end sar_adc;

architecture Behavioral of sar_adc is

component dac_delta_sigma is
Port (
clk : in  STD_LOGIC;
data : in  STD_LOGIC_VECTOR (data_size-1 downto 0);
PulseStream : out  STD_LOGIC
);
end component dac_delta_sigma;

component succesive_approximation_register is
Generic (
n : integer := data_size
);
Port (
i_clock : in  STD_LOGIC;
i_reset : in  STD_LOGIC;
i_select : in  STD_LOGIC;
o_q : out  STD_LOGIC_VECTOR (n-1 downto 0);
o_end : inout  STD_LOGIC
);
end component succesive_approximation_register;

signal data2 : std_logic_vector(data_size-1 downto 0);
signal andgate : std_logic;

begin

o_data <= data2;
andgate <= i_clock and i_from_comparator;

dac_entity : dac_delta_sigma
Port map (clk=>i_clock,data=>data2,PulseStream=>o_to_pluscomparator);

sar_entity : succesive_approximation_register
Generic map (n => data_size)
Port map (i_clock=>i_clock,i_reset=>not i_reset,i_select=>andgate,o_q=>data2,o_end=>o_sar_end);

end Behavioral;
