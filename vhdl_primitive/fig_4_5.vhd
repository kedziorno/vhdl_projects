----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:37:47 06/06/2023 
-- Design Name: 
-- Module Name:    fig_4_5 - Behavioral 
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

entity fig_4_5 is
port (
signal x_in1,x_in2 : in std_logic;
signal x_in3,x_in4,x_in5 : in std_logic;
signal y_out : out std_logic
);
end fig_4_5;

architecture Behavioral of fig_4_5 is

component AND2 is
port(
O : out std_ulogic;
I0 : in std_ulogic;
I1 : in std_ulogic
);
end component AND2;

component AND3 is
port(
O : out std_ulogic;
I0 : in std_ulogic;
I1 : in std_ulogic;
I2 : in std_ulogic
);
end component AND3;

component NOR2 is
port(
O : out std_ulogic;
I0 : in std_ulogic;
I1 : in std_ulogic
);
end component NOR2;

signal y1,y2 : std_logic;

begin

inst_AND2 : AND2 port map (O=>y1,I0=>x_in1,I1=>x_in2);
inst_AND3 : AND3 port map (O=>y2,I0=>x_in3,I1=>x_in4,I2=>x_in5);
inst_NOR2 : NOR2 port map (O=>y_out,I0=>y1,I1=>y2);

end Behavioral;

