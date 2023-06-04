----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:20:23 07/01/2021 
-- Design Name: 
-- Module Name:    transmission_gate - Behavioral 
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

entity transmission_gate is
port (
	io_a : in  std_logic;
	io_b : out std_logic;
	i_s : in std_logic
);
end transmission_gate;

architecture Behavioral1 of transmission_gate is

	signal s,sb,t1,t2 : std_logic;

	component GATE_NOT is
	generic (
	delay_not : TIME := 1 ns
	);
	port (
	A : in STD_LOGIC;
	B : out STD_LOGIC
	);
	end component GATE_NOT;

begin

--IOBUF_inst : IOBUF
--generic map (
--DRIVE => 12,
--IBUF_DELAY_VALUE => "0", -- Specify the amount of added input delay for buffer, "0"-"12"
--IFD_DELAY_VALUE => "AUTO", -- Specify the amount of added delay for input register, "AUTO", "0"-"6"
--IOSTANDARD => "DEFAULT",
--SLEW => "SLOW")
--port map (
--O => O, -- Buffer output
--IO => IO, -- Buffer inout port (connect directly to top-level port)
--I => I, -- Buffer input
--T => T -- 3-state enable input, high=input, low=output
--);

s <= i_s;
GNOT : GATE_NOT GENERIC MAP (1 ns) PORT MAP (A=>s,B=>sb);

--IOBUF_inst1 : IOBUF port map (O=>t1,IO=>io_a,I=>t2,T=>s);
--IOBUF_inst2 : IOBUF port map (O=>t2,IO=>io_b,I=>t1,T=>sb);

end Behavioral1;

architecture Behavioral2 of transmission_gate is

signal s,sb : std_logic;

component GATE_NOT is
generic (
delay_not : TIME := 1 ns
);
port (
A : in STD_LOGIC;
B : out STD_LOGIC
);
end component GATE_NOT;

begin

s <= i_s;
GNOT : GATE_NOT GENERIC MAP (1 ns) PORT MAP (A=>s,B=>sb);

IOBUF_inst1 : io_b <= io_a when s = '1' else 'Z';
--IOBUF_inst2 : io_a <= io_b after 1 ns when sb = '1' else 'Z';

end Behavioral2;
