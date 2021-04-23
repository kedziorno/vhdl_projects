----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:01 04/23/2021 
-- Design Name: 
-- Module Name:    shift_register - Behavioral 
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

entity shift_register is
generic (
	M : integer := 4;
	N : integer := 8
);
port (
	clk,load : in bit;
	x : in x_input(1 to M);
	d : in bit_vector(N-1 downto 0);
	q : out bit_vector(N-1 downto 0)
);
end shift_register;

architecture Behavioral of shift_register is
	signal temp1 : x_input(0 to M);
	signal temp2 : x_input(1 to M);
	component multiplexer is
	generic (
		bits : positive
	);
	port (
		i1,i2 : in bit_vector(bits-1 downto 0);
		sel : in bit;
		o : out bit_vector(bits-1 downto 0)
	);
	end component multiplexer;
	component ff is
	Generic (
		bits : positive
	);
	Port (
		d : in bit_vector(bits-1 downto 0);
		clk : in bit;
		q : out bit_vector(bits-1 downto 0)
	);
	end component ff;
begin
	temp1(0) <= d;
	g : for i in 1 to M generate
		mux_e : multiplexer generic map (N) port map (temp1(i-1),x(i),load,temp2(i));
		ff_e : ff generic map (N) port map (temp2(i),clk,temp1(i));
	end generate g;
	q <= temp1(M);
end Behavioral;
