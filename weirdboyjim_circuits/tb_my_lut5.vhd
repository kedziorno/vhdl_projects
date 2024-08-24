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

ENTITY tb_my_lut5 IS
END tb_my_lut5;

ARCHITECTURE behavior OF tb_my_lut5 IS

	COMPONENT my_lut5_1
	GENERIC (init : std_logic_vector(0 to 31) := "00000000000000000000000000000000");
	PORT(
		i0 : IN  std_logic;
		i1 : IN  std_logic;
		i2 : IN  std_logic;
		i3 : IN  std_logic;
		i4 : IN  std_logic;
		o : OUT  std_logic
	);
	END COMPONENT my_lut5_1;
	for all : my_lut5_1 use entity WORK.my_lut5(Behavioral_1);

	COMPONENT my_lut5_2
	GENERIC (init : std_logic_vector(0 to 31) := "00000000000000000000000000000000");
	PORT(
		i0 : IN  std_logic;
		i1 : IN  std_logic;
		i2 : IN  std_logic;
		i3 : IN  std_logic;
		i4 : IN  std_logic;
		o : OUT  std_logic
	);
	END COMPONENT my_lut5_2;
	for all : my_lut5_2 use entity WORK.my_lut5(Behavioral_2);

	COMPONENT my_lut5_3
	GENERIC (init : std_logic_vector(0 to 31) := "00000000000000000000000000000000");
	PORT(
		i0 : IN  std_logic;
		i1 : IN  std_logic;
		i2 : IN  std_logic;
		i3 : IN  std_logic;
		i4 : IN  std_logic;
		o : OUT  std_logic
	);
	END COMPONENT my_lut5_3;
	for all : my_lut5_3 use entity WORK.my_lut5(Behavioral_3);

	--Inputs
	signal i0a,i0b,i0c : std_logic := '0';
	signal i1a,i1b,i1c : std_logic := '0';
	signal i2a,i2b,i2c : std_logic := '0';
	signal i3a,i3b,i3c : std_logic := '0';
	signal i4a,i4b,i4c : std_logic := '0';

	--Outputs
	signal oa,ob,oc : std_logic;

	signal vtemp : std_logic_vector(4 downto 0);

BEGIN

	uut1 : my_lut5_1
	GENERIC MAP (init => "10000000000000000000000000000000")
	PORT MAP (
		i0 => i0a,
		i1 => i1a,
		i2 => i2a,
		i3 => i3a,
		i4 => i4a,
		o => oa
	);

	uut2 : my_lut5_2
	GENERIC MAP (init => "10000000000000000000000000000000")
	PORT MAP (
		i0 => i0b,
		i1 => i1b,
		i2 => i2b,
		i3 => i3b,
		i4 => i4b,
		o => ob
	);

	-- XXX work ok
	uut3 : my_lut5_3
	GENERIC MAP (init => "10000000000000000000000000000000")
	PORT MAP (
		i0 => i0c,
		i1 => i1c,
		i2 => i2c,
		i3 => i3c,
		i4 => i4c,
		o => oc
	);

	-- Stimulus process
	stim_proc : process
		variable temp : std_logic_vector(4 downto 0) := (others => '0');
	begin
	-- insert stimulus here
		l0 : for i in 0 to 31 loop
			temp := std_logic_vector(to_unsigned(i,5));
			vtemp <= temp;
			i0a <= temp(0);
			i1a <= temp(1);
			i2a <= temp(2);
			i3a <= temp(3);
			i4a <= temp(4);
			wait for 30 ns;
		end loop l0;
		i0a <= 'U';
		i1a <= 'U';
		i2a <= 'U';
		i3a <= 'U';
		i4a <= 'U';
		wait for 50 ns;
		l1 : for i in 0 to 31 loop
			temp := std_logic_vector(to_unsigned(i,5));
			vtemp <= temp;
			i0b <= temp(0);
			i1b <= temp(1);
			i2b <= temp(2);
			i3b <= temp(3);
			i4b <= temp(4);
			wait for 30 ns;
		end loop l1;
		i0b <= 'U';
		i1b <= 'U';
		i2b <= 'U';
		i3b <= 'U';
		i4b <= 'U';
		wait for 50 ns;
		l2 : for i in 0 to 31 loop
			temp := std_logic_vector(to_unsigned(i,5));
			vtemp <= temp;
			i0c <= temp(0);
			i1c <= temp(1);
			i2c <= temp(2);
			i3c <= temp(3);
			i4c <= temp(4);
			wait for 30 ns;
		end loop l2;
		i0c <= 'U';
		i1c <= 'U';
		i2c <= 'U';
		i3c <= 'U';
		i4c <= 'U';
		wait for 50 ns;
	wait;
	end process;

END;
