----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:07:54 10/27/2020 
-- Design Name: 
-- Module Name:    memory1 - Behavioral 
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

-- https://www.conwaylife.com/patterns/gosperglidergun.cells
-- !Name: Gosper glider gun
-- !Author: Bill Gosper
-- !The first known gun and the first known finite pattern with unbounded growth.
-- !www.conwaylife.com/wiki/index.php?title=Gosper_glider_gun
-- ........................O
-- ......................O.O
-- ............OO......OO............OO
-- ...........O...O....OO............OO
-- OO........O.....O...OO
-- OO........O...O.OO....O.O
-- ..........O.....O.......O
-- ...........O...O
-- ............OO

entity memory1 is
Generic (
WIDTH : integer;
HEIGHT : integer);
Port (
i_clk : in  STD_LOGIC;
i_x : in  STD_LOGIC;
i_y : in  STD_LOGIC;
o_bit : out  STD_LOGIC);
end memory1;

architecture Behavioral of memory1 is
type array1 is array(0 to WIDTH-1,0 to HEIGHT-1) of std_logic;
begin


end Behavioral;

