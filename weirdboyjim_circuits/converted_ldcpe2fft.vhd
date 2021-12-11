----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:46:40 12/05/2021 
-- Design Name: 
-- Module Name:    converted_ldcpe2fft - Behavioral 
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

entity converted_ldcpe2fft is
port (
	signal i_t : in std_logic;
	signal i_sd,i_rd : in std_logic;
	signal o_q1,o_q2 : out std_logic
);
end converted_ldcpe2fft;

architecture Behavioral of converted_ldcpe2fft is

--	component delayed_programmable_circuit is
--	port (
--	i_reg1 : in std_logic;
--	i_reg2 : in std_logic;
--	i_reg3 : in std_logic;
--	i_reg4 : in std_logic;
--	i_reg5 : in std_logic;
--	i_reg6 : in std_logic;
--	i_reg7 : in std_logic;
--	i_input : in std_logic;
--	o_output : out std_logic
--	);
--	end component delayed_programmable_circuit;
--	for all : delayed_programmable_circuit use entity WORK.delayed_programmable_circuit(Behavioral);

	signal d,q1,q2,xorout,i_sd_not,dpc_xorout : std_logic;

begin

	i_sd_not <= not i_sd;
	q2 <= not q1;

	o_q1 <= q1;
	o_q2 <= q2;

--	dpc_inst : delayed_programmable_circuit
--	port map (
--		i_reg1 => '1',
--		i_reg2 => '1',
--		i_reg3 => '1',
--		i_reg4 => '1',
--		i_reg5 => '1',
--		i_reg6 => '1',
--		i_reg7 => '1',
--		i_input => xorout,
--		o_output => dpc_xorout
--	);

--	XORCY_inst : xorout <= i_t xor q1 after 99 ps; -- XXX half cycle 199 ps
	XORCY_inst : XORCY
	port map (
		O => xorout, -- XOR output signal
		CI => i_t, -- Carry input signal
		LI => q1 -- LUT4 input signal
	);

--	FDCPE_inst : FDCPE
--	generic map (INIT => '0')
--	port map (
--		Q => q1,
--		C => '1',
--		CE => '1',
--		CLR => i_rd,
--		D => xorout,
--		PRE => i_sd_not
--	);

--	LDCPE_inst : LDCPE
--	generic map (INIT => '0') --Initial value of latch ('0' or '1')
--	port map (
--		Q => q1, -- Data output
--		CLR => i_rd, -- Asynchronous clear/reset input
--		D => xorout, -- Data input
--		G => '1', -- Gate input
--		GE => '0', -- Gate enable input
--		PRE => i_sd_not -- Asynchronous preset/set input
--	);

end Behavioral;

