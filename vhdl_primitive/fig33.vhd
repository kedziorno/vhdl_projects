----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:00:52 06/04/2023 
-- Design Name: 
-- Module Name:    fig33 - Behavioral
-- Project Name:   Transparent Latch
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

entity fig33 is
port (
signal Data : in bit;
signal Enable : in bit;
signal Q_out : out bit;
signal Qb_out : out bit
);
end fig33;

architecture Behavioral of fig33 is

signal q1,q2 : bit;
signal de,dbe : bit; -- data & enable, dataBAR & enable

begin

de <= Data nand Enable;
dbe <= (not Data) nand Enable;

q1 <= de nand q2 after 1 ps;
q2 <= dbe nand q1;

Q_out <= q1;
Qb_out <= q2;

end Behavioral;

