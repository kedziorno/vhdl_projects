----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:28:43 05/04/2021 
-- Design Name: 
-- Module Name:    logic_analyser - Behavioral 
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

entity logic_analyser is

end logic_analyser;

architecture Behavioral of logic_analyser is

component nxp_74hc573 is
generic (
nbit : integer := 8
);
port (
i_le : in std_logic;
i_oeb : in std_logic;
i_d : in std_logic_vector(nbit-1 downto 0);
o_q : out std_logic_vector(nbit-1 downto 0)
);
end component nxp_74hc573;

component sram_62256 is
Generic (
address_size : integer := 8;
data_size : integer := 8
);
Port (
i_ceb : in  STD_LOGIC;
i_web : in  STD_LOGIC;
i_oeb : in  STD_LOGIC;
i_address : in  STD_LOGIC_VECTOR (address_size-1 downto 0);
i_data : in  STD_LOGIC_VECTOR (data_size-1 downto 0);
o_data : out  STD_LOGIC_VECTOR (data_size-1 downto 0)
);
end component sram_62256;

component ripple_counter is
Generic (
N : integer := 8
);
Port (
i_clock : in std_logic;
i_cpb : in std_logic;
i_mrb : in std_logic;
o_q : inout std_logic_vector(N-1 downto 0)
);
end component ripple_counter;

begin

end Behavioral;
