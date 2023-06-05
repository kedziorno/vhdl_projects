----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:23:38 06/05/2023 
-- Design Name:    My-type Serial BCD to Ex-3 Code Converter
-- Module Name:    fig_3_22 - Behavioral 
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

entity fig_3_22 is
port (
clk : in std_logic;
reset : in std_logic;
Bin : in std_logic;
Bout : out std_logic
);
end fig_3_22;

architecture Behavioral of fig_3_22 is

component NAND2 is
port(
O : out std_ulogic;
I0 : in std_ulogic;
I1 : in std_ulogic
);
end component NAND2;

component NAND3 is
port(
O : out std_ulogic;
I0 : in std_ulogic;
I1 : in std_ulogic;
I2 : in std_ulogic
);
end component NAND3;

component FDR is
port(
Q : out std_ulogic;
C : in std_ulogic;
D : in std_ulogic;
R : in std_ulogic
);
end component FDR;

signal d0,d1,d2 : std_logic;
signal q0,q1,q2 : std_logic;
signal q0b,q1b,q2b : std_logic;

signal binb,boutb : std_logic;
signal gate1,gate2,gate3,gate4,gate5,gate6 : std_logic;

begin

binb <= not Bin;

inst_nand1 : NAND3 port map (O=>gate1, I0=>q0   , I1=>q1   , I2=>q2   );
inst_nand2 : NAND3 port map (O=>gate2, I0=>q0   , I1=>q2b  , I2=>binb );
inst_nand3 : NAND3 port map (O=>gate3, I0=>q0b  , I1=>q1b  , I2=>Bin  );
inst_nand4 : NAND3 port map (O=>gate4, I0=>gate1, I1=>gate2, I2=>gate3);

inst_FDRq0 : FDR port map (Q=>q0, C=>clk, D=>q1b  , R=>reset);
inst_FDRq1 : FDR port map (Q=>q1, C=>clk, D=>q0   , R=>reset);
inst_FDRq2 : FDR port map (Q=>q2, C=>clk, D=>gate4, R=>reset);
q0b <= not q0;
q1b <= not q1;
q2b <= not q2;

inst_nand5 : NAND2 port map (O=>gate5, I0=>Bin,   I1=>q2   );
inst_nand6 : NAND2 port map (O=>gate6, I0=>binb,  I1=>q2b  );
inst_nand7 : NAND2 port map (O=>boutb, I0=>gate5, I1=>gate6);

Bout <= boutb;

end Behavioral;

