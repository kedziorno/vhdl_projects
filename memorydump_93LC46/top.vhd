----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:48 03/18/2021 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
use WORK.p_constants.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port (
	i_clock : in  STD_LOGIC;
	i_reset : in  STD_LOGIC;
	o_cs : out  STD_LOGIC;
	o_sk : out  STD_LOGIC;
	o_di : out  STD_LOGIC;
	i_do : in  STD_LOGIC;
	o_RsTx : out  STD_LOGIC
);
end top;

architecture Behavioral of top is

	COMPONENT rs232 IS
	Generic (
		G_BOARD_CLOCK : integer := G_BOARD_CLOCK;
		G_BAUD_RATE : integer := G_BAUD_RATE
	);
	Port(
		clk : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		enable : in  STD_LOGIC;
		byte_to_send : in  STD_LOGIC_VECTOR (G_MemoryData-1 downto 0);
		busy : out  STD_LOGIC;
		ready : out  STD_LOGIC;
		RsTx : out  STD_LOGIC
	);
	END COMPONENT rs232;

	signal rs232_enable,rs232_busy,rs232_ready : std_logic;
	signal rs232_byte_to_send : MemoryDataByte;

begin

	c_rs232 : rs232
	GENERIC MAP (
		G_BOARD_CLOCK => G_BOARD_CLOCK,
		G_BAUD_RATE => G_BAUD_RATE
	)
	PORT MAP (
		clk => i_clock,
		rst => i_reset,
		enable => rs232_enable,
		byte_to_send => rs232_byte_to_send,
		busy => rs232_busy,
		ready => rs232_ready,
		RsTx => o_RsTx
	);

end Behavioral;
