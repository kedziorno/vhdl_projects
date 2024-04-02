----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:33:10 06/12/2021 
-- Design Name: 
-- Module Name:    fifo - Behavioral 
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

entity fifo is
port (
	rxclk : in std_logic; -- from clk mux circuit
	txclk : in std_logic; -- txclk ref
	areset : in std_logic; 
	wptrclr : in std_logic;
	wptrinc : in std_logic;
	rptrclr : in std_logic;
	rptrinc : in std_logic;
	rxd0 : in std_logic;
	rxd1 : in std_logic;
	rxd2 : in std_logic;
	rxd3 : in std_logic;
	rxd4 : in std_logic;
	rxd5 : in std_logic;
	dmuxout : out std_logic_vector(5 downto 0);
	wptr2 : out std_logic;
	wptr1 : out std_logic;
	wptr0 : out std_logic;
	rptr2 : out std_logic;
	rptr1 : out std_logic;
	rptr0 : out std_logic
);
end fifo;

use work.portetop_pkg.all;

architecture archfifo of fifo is
	signal rptr,wptr : std_logic_vector(2 downto 0);
	signal qout0,qout1,qout2,qout3,qout4,qout5,qout6,qout7,rxd : std_logic_vector(5 downto 0);
	signal en : std_logic_vector(7 downto 0);
begin
	u1 : rreg generic map (6) port map (rxclk,areset,en(0),rxd,qout0);
	u2 : rreg generic map (6) port map (rxclk,areset,en(1),rxd,qout1);
	u3 : rreg generic map (6) port map (rxclk,areset,en(2),rxd,qout2);
	u4 : rreg generic map (6) port map (rxclk,areset,en(3),rxd,qout3);
	u5 : rreg generic map (6) port map (rxclk,areset,en(4),rxd,qout4);
	u6 : rreg generic map (6) port map (rxclk,areset,en(5),rxd,qout5);
	u7 : rreg generic map (6) port map (rxclk,areset,en(6),rxd,qout6);
	u8 : rreg generic map (6) port map (rxclk,areset,en(7),rxd,qout7);

	u10 : ascount generic map (3) port map (rxclk,areset,wptrclr,wptrinc,wptr);
	u11 : ascount generic map (3) port map (txclk,areset,rptrclr,rptrinc,rptr);

	rxd <= (rxd5,rxd4,rxd3,rxd2,rxd1,rxd0);
	wptr2 <= wptr(2);
	wptr1 <= wptr(1);
	wptr0 <= wptr(0);
	rptr2 <= rptr(2);
	rptr1 <= rptr(1);
	rptr0 <= rptr(0);

	with rptr select dmuxout <=
	qout0 when "000",
	qout0 when "001",
	qout0 when "010",
	qout0 when "011",
	qout0 when "100",
	qout0 when "101",
	qout0 when "110",
	qout0 when others;

	with wptr select en <=
	"00000001" when "000",
	"00000010" when "001",
	"00000100" when "010",
	"00001000" when "011",
	"00010000" when "100",
	"00100000" when "101",
	"01000000" when "110",
	"10000000" when others;
end archfifo;
