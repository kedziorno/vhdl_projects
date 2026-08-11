----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:05 04/18/2021 
-- Design Name: 
-- Module Name:    FDCPE_Q_QB - Behavioral 
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

entity FDCPE_Q_QB is
Generic (
	INIT : BIT := '0'
);
Port (
	Q : out  STD_LOGIC;
	QB : out  STD_LOGIC;
	C : in  STD_LOGIC;
	CE : in  STD_LOGIC;
	CLR : in  STD_LOGIC;
	D : in  STD_LOGIC;
	PRE : in  STD_LOGIC
);
end FDCPE_Q_QB;

architecture Behavioral of FDCPE_Q_QB is
	signal s_q : std_logic;
begin
	FDCPE_inst : FDCPE
	generic map (INIT => INIT)
	port map (Q=>s_q,C=>C,CE=>CE,CLR=>CLR,D=>D,PRE=>PRE);
	Q <= s_q;
	QB <= not s_q after 100 ps; -- XXX wait from FDCPE lib
end Behavioral;

