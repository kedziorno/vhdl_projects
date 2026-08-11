----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:18:24 07/11/2021 
-- Design Name: 
-- Module Name:    sn5474ls245_cell - Behavioral 
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

entity sn5474ls245_cell is
Port (
i_s : in  STD_LOGIC;
i_sb : in  STD_LOGIC;
io_a : inout  STD_LOGIC;
io_b : inout  STD_LOGIC
);
end sn5474ls245_cell;

architecture Behavioral of sn5474ls245_cell is
	signal t1,t2 : std_logic;
begin

--	io_a <= io_b after 1 ns when i_s = '1' and i_sb = '0' else 'Z';
--	io_b <= io_a after 1 ns when i_s = '0' and i_sb = '1' else 'Z';

IOBUF_inst1 : IOBUF
generic map (
DRIVE => 12,
IBUF_DELAY_VALUE => "12",
IFD_DELAY_VALUE => "6",
IOSTANDARD => "DEFAULT",
SLEW => "SLOW")
port map (IO=>io_a,I=>t1,O=>t2,T=>i_s);

IOBUF_inst2 : IOBUF
generic map (
DRIVE => 12,
IBUF_DELAY_VALUE => "12",
IFD_DELAY_VALUE => "6",
IOSTANDARD => "DEFAULT",
SLEW => "SLOW")
port map (IO=>io_b,I=>t2,O=>t1,T=>i_sb);

end Behavioral;
