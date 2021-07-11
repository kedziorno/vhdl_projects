----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:24:27 07/11/2021 
-- Design Name: 
-- Module Name:    sn5474ls245 - Behavioral 
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

entity sn5474ls245 is
Generic (
	N : integer := 8
);
Port (
	i_dir : in  STD_LOGIC;
	i_eb : in  STD_LOGIC;
	io_a : inout  STD_LOGIC_VECTOR (N-1 downto 0);
	io_b : inout  STD_LOGIC_VECTOR (N-1 downto 0)
);
end sn5474ls245;

architecture Behavioral of sn5474ls245 is
	component sn5474ls245_cell is
	Port (
		i_s : in  STD_LOGIC;
		i_sb : in  STD_LOGIC;
		io_a : inout  STD_LOGIC;
		io_b : inout  STD_LOGIC
	);
	end component sn5474ls245_cell;

	signal and2_dir,and2_eb : std_logic;
--	signal t1,t2 : std_logic_vector(N-1 downto 0);
--	signal t1,t2 : std_logic := '0';
	constant WAIT_AND : time := 1 ns;
begin

	and2_dir <= i_dir and not i_eb after WAIT_AND;
	and2_eb <= not i_dir and not i_eb after WAIT_AND;

--	g0 : for i in N-1 downto 0 generate
--		IOBUF_inst1 : IOBUF
--		port map (O=>t1(i),IO=>io_a(i),I=>t2(i),T=>and2_eb);
----		port map (O=>t1,IO=>io_a(i),I=>t2,T=>and2_eb);
--		IOBUF_inst2 : IOBUF
--		port map (O=>t2(i),IO=>io_b(i),I=>t1(i),T=>and2_dir);
----		port map (O=>t2,IO=>io_b(i),I=>t1,T=>and2_dir);
--	end generate g0;
	
	g0 : for i in io_a'range generate
		g0_sn : sn5474ls245_cell
		Port map (
			i_s => and2_dir,
			i_sb => and2_eb,
			io_a => io_a(i),
			io_b => io_b(i)
		);
	end generate g0;

end Behavioral;
