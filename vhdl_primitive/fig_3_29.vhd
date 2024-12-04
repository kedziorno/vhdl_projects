----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:22:23 06/05/2023 
-- Design Name:    Me-type NRZ-to-Manchester encoder
-- Module Name:    fig_3_29 - Behavioral 
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

entity fig_3_29 is
port (
signal Bin : in std_logic;
signal clk : in std_logic;
signal reset : in std_logic;
signal Bout : out std_logic
);
end fig_3_29;

architecture Behavioral of fig_3_29 is

component AND3 is
port(
O : out std_ulogic;
I0 : in std_ulogic;
I1 : in std_ulogic;
I2 : in std_ulogic
);
end component AND3;

component AND2 is
port(
O : out std_ulogic;
I0 : in std_ulogic;
I1 : in std_ulogic
);
end component AND2;

component OR2 is
port(
O : out std_ulogic;
I0 : in std_ulogic;
I1 : in std_ulogic
);
end component OR2;

component INV is
port(
O : out std_ulogic;
I : in std_ulogic
);
end component INV;

component FDR_1 is
generic(
INIT                           :  bit := '0'
);
port(
Q                              :  out   STD_ULOGIC;
C                              :  in    STD_ULOGIC;
D                              :  in    STD_ULOGIC;
R                              :  in    STD_ULOGIC
);
end component FDR_1;

signal gate1,gate2,gate3 : std_logic;
signal q0,q0b,q1,q1b : std_logic;
signal binb : std_logic;

begin

inst_INVB : INV port map (O=>binb,I=>Bin);

inst_AND3a : AND3 port map (O=>gate1,I0=>q0b,I1=>q1b,I2=>binb);
inst_AND3b : AND3 port map (O=>gate2,I0=>q0b,I1=>q1b,I2=>Bin);

inst_FDR1 : FDR_1 generic map (INIT=>'1') port map (Q=>q0,C=>clk,D=>gate1,R=>reset);
inst_INVFF1 : INV port map (O=>q0b,I=>q0);
inst_FDR2 : FDR_1 generic map (INIT=>'0') port map (Q=>q1,C=>clk,D=>gate2,R=>reset);
inst_INVFF2 : INV port map (O=>q1b,I=>q1);

inst_OR : OR2 port map (O=>gate3,I0=>q0,I1=>Bin);

inst_AND2 : AND2 port map (O=>Bout,I0=>gate3,I1=>q1b);

end Behavioral;

