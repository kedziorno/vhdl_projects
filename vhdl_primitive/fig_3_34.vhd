----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:05:17 06/06/2023 
-- Design Name:    Mo-type NRZ-to-Manchester encoder
-- Module Name:    fig_3_34 - Behavioral 
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

entity fig_3_34 is
port (
signal clk : in std_logic;
signal reset : in std_logic;
signal Bin : in std_logic;
signal Bout : out std_logic
);
end fig_3_34;

architecture Behavioral of fig_3_34 is

component NAND2 is
port(
O : out std_ulogic;
I0 : in std_ulogic;
I1 : in std_ulogic
);
end component NAND2;

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

component INV is
port(
O : out std_ulogic;
I : in std_ulogic
);
end component INV;

signal gate1,gate2,gate3 : std_logic;
signal q0,q0b,q1,q1b : std_logic;

begin

inst_nand1 : NAND2 port map (O=>gate1,I0=>q1b,I1=>q0);
inst_nand2 : NAND2 port map (O=>gate2,I0=>q0b,I1=>Bin);
inst_nand3 : NAND2 port map (O=>gate3,I0=>gate1,I1=>gate2);

inst_FDR1 : FDR_1 port map (Q=>q1,C=>clk,D=>gate3,R=>reset);
inst_INV1 : INV port map (O=>q1b,I=>q1);
inst_FDR2 : FDR_1 port map (Q=>q0,C=>clk,D=>q0b,R=>reset);
inst_INV2 : INV port map (O=>q0b,I=>q0);

Bout <= q1;

end Behavioral;

