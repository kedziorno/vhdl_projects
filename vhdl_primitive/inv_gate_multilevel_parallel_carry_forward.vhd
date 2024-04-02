----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:49:32 06/20/2022 
-- Design Name: 
-- Module Name:    inv_gate_multilevel_parallel_carry_forward - Behavioral 
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

entity inv_gate_multilevel_parallel_carry_forward is
generic (
	N : integer := 2;
	M : integer := 5
);
port (
	signal i_in : in std_logic_vector(N-1 downto 0);
	signal o_and : out std_logic;
--	signal o_or : out std_logic
	signal o_or : out std_logic_vector(M-1 downto 0)
);
end inv_gate_multilevel_parallel_carry_forward;

architecture Behavioral of inv_gate_multilevel_parallel_carry_forward is

signal a : std_logic_vector(M-1 downto 0);
signal a1 : std_logic_vector(M-1 downto 0);
--signal b : std_logic_vector(N-1 downto 0);
--signal b1 : std_logic_vector(N-1 downto 0);

begin

--o_or <= a(M-1);
--o_or <= b(N-1);

--g1 : for i in 0 to M-1 generate
--begin
--	aa : block
--	begin
		pa : process (a1) is
			variable ff : std_logic;
		begin
--			ff := a1(0);
			lb : for i in 1 to M-1 loop
--				ff := ff or a1(i);
				lc : for j in 1 to i loop
--				ff := a1(i);
--				la : for j in 1 to i loop
					a(i) <= a(j) or a1(j-1);
--				end loop la;
				end loop lc;
--				a(i) <= ff;
			end loop lb;
		end process pa;
--	end block aa;
--end generate g1;

--g2 : for i in 0 to M-1 generate
--begin
--	ab : block
--	begin
--		pb : process (b1) is
--			variable fg : std_logic := b1(i);
--		begin
--			la : for j in i to N-1 loop
--				fg := fg and b1(j-1);
--			end loop la;
--			o_and <= fg;
--		end process pb;
--	end block ab;
--end generate g2;

g0 : for i in 0 to M-1 generate
begin
	b0 : block
	begin
		p0or : process (i_in) is
		attribute Keep : string;
			variable j : std_logic := '0';
			attribute keep of j : variable is "true";
		begin
--			j := '0';
			for k in 0 to N-1 loop
				j := j or i_in(k);
			end loop k;
--			a1(i) <= j;
			o_or(i) <= j;
		end process p0or;
	end block b0;
--	b1 : block
--	begin
--		p0and : process (i_in) is
--			variable j : std_logic := '1';
--		begin
--			for k in 0 to N-1 loop
--				j := j and i_in(k);
--			end loop k;
--			b1(i) <= j;
--		end process p0and;
--	end block b1;
end generate g0;

end Behavioral;
