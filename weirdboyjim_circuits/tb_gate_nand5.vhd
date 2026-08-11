--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:35:05 12/07/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/weirdboyjim_circuits/tb_my_lut5.vhd
-- Project Name:  weirdboyjim_circuits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: my_lut5
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

ENTITY tb_gate_nand5 IS
END tb_gate_nand5;

ARCHITECTURE behavior OF tb_gate_nand5 IS

	COMPONENT my_nand5
	PORT(
		a : IN  std_logic;
		b : IN  std_logic;
		c : IN  std_logic;
		d : IN  std_logic;
		e : IN  std_logic;
		f : OUT  std_logic
	);
	END COMPONENT my_nand5;
	for all : my_nand5 use entity WORK.my_nand5(Behavioral);

	--Inputs
	signal i0 : std_logic := '0';
	signal i1 : std_logic := '0';
	signal i2 : std_logic := '0';
	signal i3 : std_logic := '0';
	signal i4 : std_logic := '0';

	--Outputs
	signal o : std_logic;

	signal vtemp : std_logic_vector(4 downto 0);

BEGIN

	uut1 : my_nand5
	PORT MAP (
		a => i0,
		b => i1,
		c => i2,
		d => i3,
		e => i4,
		f => o
	);

	-- Stimulus process
	stim_proc : process
		variable temp : std_logic_vector(4 downto 0) := (others => '0');
	begin
	-- insert stimulus here
		l0 : for i in 0 to 31 loop
			temp := std_logic_vector(to_unsigned(i,5));
			vtemp <= temp;
			i0 <= temp(0);
			i1 <= temp(1);
			i2 <= temp(2);
			i3 <= temp(3);
			i4 <= temp(4);
			wait for 30 ns;
		end loop l0;
		i0 <= 'U';
		i1 <= 'U';
		i2 <= 'U';
		i3 <= 'U';
		i4 <= 'U';
		wait for 50 ns;
	wait;
	end process;

END;
