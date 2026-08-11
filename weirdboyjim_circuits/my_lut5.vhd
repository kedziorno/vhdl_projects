----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:23:29 12/07/2021 
-- Design Name: 
-- Module Name:    my_lut5 - Behavioral 
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

entity my_lut5 is
generic (
	init : std_logic_vector(0 to 31) := "00000000000000000000000000000000"
);
port (
	signal i0,i1,i2,i3,i4 : in std_logic;
	signal o : out std_logic
);
end entity my_lut5;

-- XXX based on https://stackoverflow.com/q/38073868
architecture Behavioral_1 of my_lut5 is -- XXX not work
	signal h4,g4,ii : std_logic;
begin

	lut4_h4 : LUT4
	generic map (INIT => to_bitvector(init(16 to 31)))
	port map (O => h4, I0 => i0, I1 => i1, I2 => i2, I3 => i3);

	lut4_g4 : LUT4
	generic map (INIT => to_bitvector(init(16 to 31)))
	port map (O => g4, I0 => i0, I1 => i1, I2 => i2, I3 => i3);

	lut4_out : LUT4
	generic map (INIT => to_bitvector(init(0 to 15)))
	port map (O => o, I0 => g4, I1 => h4, I2 => i4, I3 => '0');

end architecture Behavioral_1;

---- XXX based on https://stackoverflow.com/q/38073868
architecture Behavioral_2 of my_lut5 is -- XXX not work
	signal hh : std_logic;
begin

	lut4_in : LUT4
	generic map (INIT => to_bitvector(init(0 to 15)))
	port map (O => hh, I0 => i1, I1 => i2, I2 => i3, I3 => i4);

	lut4_out : LUT4
	generic map (INIT => to_bitvector(init(16 to 31)))
	port map (O => o, I0 => i0, I1 => i1, I2 => i2, I3 => hh);

end architecture Behavioral_2;

---- XXX based on Xilinx xapp466 p3 Figure5
architecture Behavioral_3 of my_lut5 is -- XXX seems to work correctly
	signal gg,hh : std_logic;
	constant cinit1 : std_logic_vector(0 to 15) := init(0 to 15);
	constant cinit2 : std_logic_vector(0 to 15) := init(16 to 31);
begin

	MUXF5_inst : MUXF5 port map (O => o, I0 => hh, I1 => gg, S => i4);

	lut4_a : LUT4
	generic map (INIT => to_bitvector(cinit1))
	port map (O => gg, I0 => i0, I1 => i1, I2 => i2, I3 => i3);

	lut4_b : LUT4
	generic map (INIT => to_bitvector(cinit2))
	port map (O => hh, I0 => i0, I1 => i1, I2 => i2, I3 => i3);

end architecture Behavioral_3;
