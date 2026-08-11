----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:40:20 06/04/2023 
-- Design Name:    Master-slave neg-edge D FF
-- Module Name:    fig35 - Behavioral 
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

entity fig35 is
port (
Data : in bit;
clock : in bit;
Q,Qb : out bit
);
end fig35;

architecture Behavioral of fig35 is

component fig33 is
port (
signal Data : in bit;
signal Enable : in bit;
signal Q_out : out bit;
signal Qb_out : out bit
);
end component fig33;

signal clockbar : bit;
signal qd : bit;

begin

clockbar <= not clock;

data_latch_master : fig33
port map (
Data => Data,
Enable => not clock,
Q_out => qd,
Qb_out => open
);

data_latch_slave : fig33
port map (
Data => qd,
Enable => not clockbar,
Q_out => Q,
Qb_out => Qb
);

end Behavioral;

