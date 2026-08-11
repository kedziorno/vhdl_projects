----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:56:46 06/12/2021 
-- Design Name: 
-- Module Name:    symbolmux - Behavioral 
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

entity symbolmux is
port (
	txclk : in std_logic;
	areset : in std_logic;
	symbolclr : in std_logic;
	symbolinc : in std_logic;
	switch1 : in std_logic; -- line 1 d/s switch control
	switch2 : in std_logic;
	switch3 : in std_logic;
	symbol1 : in std_logic_vector(1 downto 0); -- line 1 symbol mux ctrl
	symbol2 : in std_logic_vector(1 downto 0);
	symbol3 : in std_logic_vector(1 downto 0);
	dmuxout : in std_logic_vector(5 downto 0); -- fifo data input
	symbolend1 : buffer std_logic;
	symbolend2 : out std_logic;
	symbolend3 : out std_logic;
	txd5 : out std_logic;
	txd4 : out std_logic;
	txd3 : out std_logic;
	txd2 : out std_logic;
	txd1 : out std_logic;
	txd0 : out std_logic
);
end symbolmux;

use work.portetop_pkg.all;

architecture archsymbolmux of symbolmux is
	signal clearcount : std_logic;
	signal symbolcount : std_logic_vector(2 downto 0);
	signal sosb1,sosb2,sosb3,bad1,bad2,bad3,jam : std_logic_vector(1 downto 0);
	signal txd,muxout,smuxout : std_logic_vector(5 downto 0);
	constant plus : std_logic_vector(1 downto 0) := "10";
	constant zero: std_logic_vector(1 downto 0) := "00";
	constant minus : std_logic_vector(1 downto 0) := "01";
begin
	u1 : ascount generic map (3) port map (txclk,areset,clearcount,symbolinc,symbolcount);
	u2 : rdff generic map (6) port map (txclk,areset,muxout,txd);

	txd5 <= txd(5);
	txd4 <= txd(4);
	txd3 <= txd(3);
	txd2 <= txd(2);
	txd1 <= txd(1);
	txd0 <= txd(0);
	symbolend1 <= symbolcount(0) and not symbolcount(1) and symbolcount(2);
	symbolend2 <= symbolcount(0) and not symbolcount(1) and not symbolcount(2);
	symbolend3 <= symbolcount(0) and symbolcount(1) and not symbolcount(2);
	clearcount <= symbolend1 or symbolclr;

	with symbol1 select smuxout(1 downto 0) <=
	jam when "00",
	sosb1 when "01",
	bad1 when "10",
	zero when others;

	with switch1 select muxout(1 downto 0) <=
	smuxout(1 downto 0) when '0',
	dmuxout(1 downto 0) when others;

	with symbol2 select smuxout(3 downto 2) <=
	jam when "00",
	sosb2 when "01",
	bad2 when "10",
	zero when others;

	with switch2 select muxout(3 downto 2) <=
	smuxout(3 downto 2) when '0',
	dmuxout(3 downto 2) when others;

	with symbol3 select smuxout(5 downto 4) <=
	jam when "00",
	sosb3 when "01",
	bad3 when "10",
	zero when others;

	with switch3 select muxout(5 downto 4) <=
	smuxout(5 downto 4) when '0',
	dmuxout(5 downto 4) when others;

	with symbolcount(0) select jam <=
	plus when '0',
	minus when others;

	with symbolcount select sosb1 <=
	plus when "000",
	minus when "001",
	plus when "010",
	minus when "011",
	minus when "100",
	plus when "101",
	zero when others;

	with symbolcount select sosb2 <=
	minus when "000",
	plus when "001",
	plus when "010",
	minus when "011",
	plus when "100",
	minus when "101",
	zero when others;

	with symbolcount select sosb3 <=
	plus when "000",
	minus when "001",
	minus when "010",
	plus when "011",
	plus when "100",
	minus when "101",
	zero when others;

	with symbolcount select bad1 <=
	minus when "000",
	minus when "001",
	minus when "010",
	plus when "011",
	plus when "100",
	plus when "101",
	zero when others;

	with symbolcount select bad2 <=
	plus when "000",
	plus when "001",
	minus when "010",
	minus when "011",
	minus when "100",
	plus when "101",
	zero when others;

	with symbolcount select bad3 <=
	minus when "000",
	plus when "001",
	plus when "010",
	plus when "011",
	minus when "100",
	minus when "101",
	zero when others;
end archsymbolmux;
