----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:39:13 06/12/2021 
-- Design Name: 
-- Module Name:    core - Behavioral 
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

entity core is
port (
	reset : in std_logic;
	clk : in std_logic; -- cktpad for txclk
	rxd5 : in std_logic;
	rxd4 : in std_logic;
	rxd3 : in std_logic;
	rxd2 : in std_logic;
	rxd1 : in std_logic;
	rxd0 : in std_logic;
	rx_dv : in std_logic;
	rx_er : in std_logic;
	clk1 : in std_logic;
	crs1 : in std_logic;
	enable1_bar : in std_logic;
	link1_bar : in std_logic;
	clk2 : in std_logic;
	crs2 : in std_logic;
	enable2_bar : in std_logic;
	link2_bar : in std_logic;
	clk3 : in std_logic;
	crs3 : in std_logic;
	enable3_bar : in std_logic;
	link3_bar : in std_logic;
	clk4 : in std_logic;
	crs4 : in std_logic;
	enable4_bar : in std_logic;
	link4_bar : in std_logic;
	clk5 : in std_logic;
	crs5 : in std_logic;
	enable5_bar : in std_logic;
	link5_bar : in std_logic;
	clk6 : in std_logic;
	crs6 : in std_logic;
	enable6_bar : in std_logic;
	link6_bar : in std_logic;
	clk7 : in std_logic;
	crs7 : in std_logic;
	enable7_bar : in std_logic;
	link7_bar : in std_logic;
	clk8 : in std_logic;
	crs8 : in std_logic;
	enable8_bar : in std_logic;
	link8_bar : in std_logic;
	rx_en1 : out std_logic;
	tx_en1 : out std_logic;
	partition1_bar : inout std_logic;
	jabber1_bar : inout std_logic;
	rx_en2 : out std_logic;
	tx_en2 : out std_logic;
	partition2_bar : inout std_logic;
	jabber2_bar : inout std_logic;
	rx_en3 : out std_logic;
	tx_en3 : out std_logic;
	partition3_bar : inout std_logic;
	jabber3_bar : inout std_logic;
	rx_en4 : out std_logic;
	tx_en4 : out std_logic;
	partition4_bar : inout std_logic;
	jabber4_bar : inout std_logic;
	rx_en5 : out std_logic;
	tx_en5 : out std_logic;
	partition5_bar : inout std_logic;
	jabber5_bar : inout std_logic;
	rx_en6 : out std_logic;
	tx_en6 : out std_logic;
	partition6_bar : inout std_logic;
	jabber6_bar : inout std_logic;
	rx_en7 : out std_logic;
	tx_en7 : out std_logic;
	partition7_bar : inout std_logic;
	jabber7_bar : inout std_logic;
	rx_en8 : out std_logic;
	tx_en8 : out std_logic;
	partition8_bar : inout std_logic;
	jabber8_bar : inout std_logic;
	txd5 : out std_logic;
	txd4 : out std_logic;
	txd3 : out std_logic;
	txd2 : out std_logic;
	txd1 : out std_logic;
	txd0 : out std_logic;
	txdata : inout std_logic; -- tx_enall
	idle : out std_logic;
	preamble : out std_logic;
	data : out std_logic;
	jam : inout std_logic;
	collision : inout std_logic;
	wptr2 : out std_logic;
	wptr1 : out std_logic;
	wptr0 : out std_logic;
	rptr2 : out std_logic;
	rptr1 : out std_logic;
	rptr0 : out std_logic
);
end core;

use work.portetop_pkg.all;

architecture archcore of core is
	signal txclk1,nosel,areset,sel1,sel2,sel3,sel4 : std_logic;
	signal sel5,sel6,sel7,sel8,rxclk,txclk : std_logic;
	signal activity1,activity2,activity3,activity4,activity5,activity6,activity7,activity8 : std_logic;
	signal carrier : std_logic;
	signal wptrclr,wptrinc,rptrclr,rptrinc,symbolinc : std_logic;
	signal switch1,switch2,switch3 : std_logic;
	signal symbolend1,symbolend2,symbolend3 : std_logic;
	signal symbolclr : std_logic;
	signal symbol1,symbol2,symbol3 : std_logic_vector(1 downto 0);
	signal dmuxout : std_logic_vector(5 downto 0);
	signal prescale : std_logic;
begin
	u1 : clockmux8 port map (areset,clk1,clk2,clk3,clk4,clk5,clk6,clk7,clk8,txclk1,sel1,sel2,sel3,sel4,sel5,sel6,sel7,sel8,nosel,rxclk);
	u2 : arbiter8 port map (txclk,areset,activity1,activity2,activity3,activity4,activity5,activity6,activity7,activity8,sel1,sel2,sel3,sel4,sel5,sel6,sel7,sel8,nosel,carrier,collision);
	u3 : fifo port map (rxclk,txclk,areset,wptrclr,wptrinc,rptrclr,rptrinc,rxd5,rxd4,rxd3,rxd2,rxd1,rxd0,dmuxout,wptr2,wptr1,wptr0,rptr2,rptr1,rptr0);
	u4 : symbolmux port map (txclk,areset,symbolclr,symbolinc,switch1,switch2,switch3,symbol1,symbol2,symbol3,dmuxout,symbolend1,symbolend2,symbolend3,txd5,txd4,txd3,txd2,txd1,txd0);
	u5 : control port map (txclk,areset,carrier,collision,rx_er,rx_dv,symbolend1,symbolend2,symbolend3,symbolclr,symbolinc,symbol1,symbol2,symbol3,switch1,switch2,switch3,wptrclr,wptrinc,rptrclr,rptrinc,txdata,idle,preamble,data,jam,prescale);
	u6 : porte port map (txclk,areset,crs1,enable1_bar,link1_bar,sel1,carrier,collision,jam,txdata,prescale,rx_en1,tx_en1,activity1,jabber1_bar,partition1_bar);
	u7 : porte port map (txclk,areset,crs2,enable2_bar,link2_bar,sel2,carrier,collision,jam,txdata,prescale,rx_en2,tx_en2,activity2,jabber2_bar,partition2_bar);
	u8 : porte port map (txclk,areset,crs3,enable3_bar,link3_bar,sel3,carrier,collision,jam,txdata,prescale,rx_en3,tx_en3,activity3,jabber3_bar,partition3_bar);
	u9 : porte port map (txclk,areset,crs4,enable4_bar,link4_bar,sel4,carrier,collision,jam,txdata,prescale,rx_en4,tx_en4,activity4,jabber4_bar,partition4_bar);
	u10 : porte port map (txclk,areset,crs5,enable5_bar,link5_bar,sel5,carrier,collision,jam,txdata,prescale,rx_en5,tx_en5,activity5,jabber5_bar,partition5_bar);
	u11 : porte port map (txclk,areset,crs6,enable6_bar,link6_bar,sel6,carrier,collision,jam,txdata,prescale,rx_en6,tx_en6,activity6,jabber6_bar,partition6_bar);
	u12 : porte port map (txclk,areset,crs7,enable7_bar,link7_bar,sel7,carrier,collision,jam,txdata,prescale,rx_en7,tx_en7,activity7,jabber7_bar,partition7_bar);
	u13 : porte port map (txclk,areset,crs8,enable8_bar,link8_bar,sel8,carrier,collision,jam,txdata,prescale,rx_en8,tx_en8,activity8,jabber8_bar,partition8_bar);
	txclk <= clk;
	txclk1 <= clk;
	areset <= reset;
end archcore;
