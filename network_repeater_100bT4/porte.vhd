----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:58:02 06/12/2021 
-- Design Name: 
-- Module Name:    porte - Behavioral 
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

entity porte is
port (
	txclk : in std_logic;
	areset : in std_logic;
	crs : in std_logic; -- carrier sense
	enable_bar : in std_logic;
	link_bar : in std_logic; -- pma link ok
	selected : in std_logic; -- arbiter s
	carrier : in std_logic; -- arbiter c
	collision : in std_logic; -- arbiter c
	jam : in std_logic; -- control j
	txdata : in std_logic; -- control tx data
	prescale : in std_logic; -- counter prescale
	rx_en : out std_logic;
	tx_en : out std_logic;
	activity : out std_logic;
	jabber_bar : inout std_logic;
	partition_bar : inout std_logic
);
end porte;

use work.portetop_pkg.all;

architecture archporte of porte is
	type states is (CLEAR_STATE, IDLE_STATE, CWATCH_STATE, CCOUNT_STATE, PWAIT_STATE, PHOLD_STATE, PCWATCH_STATE, WAIT_STATE);
--	attribute state_encoding of states : type is one_hot_one;
	signal state, newstate : states;
	signal crsdd, link_bardd, enable_bardd : std_logic;
	signal transmit, copyd, copyin, collisiond : std_logic;
	signal jabcnt : std_logic_vector(3 downto 0);
	signal jabberclr, jabberinc : std_logic;
	signal quietd : std_logic;
	signal cccnt : std_logic_vector(6 downto 0);
	signal cclimit, nocoldone : std_logic;
	signal nocolcnt : std_logic_vector(7 downto 0);
	signal ccclr, ccinc, nocolclr, nocolinc : std_logic;
	signal carpres,tx_eni : std_logic;
begin
	u0 : rsynch port map (txclk, areset, crs, crsdd);
	u1 : psynch port map (txclk, areset, link_bar, link_bardd);
	u2 : psynch port map (txclk, areset, enable_bar, enable_bardd);
	u3 : rdff1 port map (txclk, areset, tx_eni, tx_en);
	u4 : rdff1 port map (txclk, areset, copyin, copyd);
	u5 : rdff1 port map (txclk, areset, collision, collisiond);
	u6 : ascount generic map (4) port map (txclk, areset, jabberclr, jabberinc, jabcnt);
	u7 : ascount generic map (7) port map (txclk, areset, ccclr, ccinc, cccnt);
	u8 : ascount generic map (8) port map (txclk, areset, nocolclr, nocolinc, nocolcnt);

	carpres <= crsdd and not enable_bardd;
	activity <= carpres and not link_bardd and jabber_bar and partition_bar;
	rx_en <= not enable_bardd and not link_bardd and selected and collision;
	tx_eni <= not enable_bardd and not link_bardd and jabber_bar and transmit;	
	copyin <= carrier and not selected;
	transmit <= txdata and (copyd or collisiond);	
	jabber_bar <= not (jabcnt(3) and jabcnt(2));
	jabberclr <= not carpres;
	jabberinc <= carpres and prescale and jabber_bar;
	quietd <= not copyd;
	cclimit <= cccnt(6);
	nocoldone <= nocolcnt(7);

	p1 : process (state, carpres, collisiond, copyd, quietd, nocoldone, cclimit, enable_bardd) is
	begin
		case state is
			when CLEAR_STATE =>
				partition_bar <= '1';
				ccclr <= '1';
				ccinc <= '0';
				nocolclr <= '1';
				nocolinc <= '0';
				if (enable_bardd = '1') then
					newstate <= CLEAR_STATE;
				elsif (quietd = '1') then
					newstate <= IDLE_STATE;
				else
					newstate <= CLEAR_STATE;
				end if;
			when IDLE_STATE =>
				partition_bar <= '1';
				ccclr <= '0';
				ccinc <= '0';
				nocolclr <= '1';
				nocolinc <= '0';
				if (enable_bardd = '1') then
					newstate <= CLEAR_STATE;
				elsif (carpres = '1') then
					newstate <= CWATCH_STATE;
				else
					newstate <= IDLE_STATE;
				end if;
			when CWATCH_STATE =>
				partition_bar <= '1';
				ccclr <= '0';
				ccinc <= collisiond;
				nocolclr <= '0';
				nocolinc <= '1';
				if (enable_bardd = '1') then
					newstate <= CLEAR_STATE;
				elsif (collisiond = '1') then
					newstate <= CCOUNT_STATE;
				elsif (carpres = '0') then
					newstate <= IDLE_STATE;
				elsif (nocoldone = '1') then
					newstate <= CLEAR_STATE;
				else
					newstate <= CWATCH_STATE;
				end if;
			when CCOUNT_STATE =>
				partition_bar <= '1';
				ccclr <= '0';
				ccinc <= '0';
				nocolclr <= '1';
				nocolinc <= '0';
				if (enable_bardd = '1') then
					newstate <= CLEAR_STATE;
				elsif (cclimit = '1') then
					newstate <= PWAIT_STATE;
				elsif (carpres = '0' and quietd = '1') then
					newstate <= IDLE_STATE;
				else
					newstate <= CCOUNT_STATE;
				end if;
			when PWAIT_STATE =>
				partition_bar <= '0';
				ccclr <= '0';
				ccinc <= '0';
				nocolclr <= '1';
				nocolinc <= '0';
				if (enable_bardd = '1') then
					newstate <= CLEAR_STATE;
				elsif (carpres = '0' and quietd = '1') then
					newstate <= PHOLD_STATE;
				else
					newstate <= PWAIT_STATE;
				end if;
			when PHOLD_STATE =>
				partition_bar <= '0';
				ccclr <= '0';
				ccinc <= '0';
				nocolclr <= '1';
				nocolinc <= '0';
				if (enable_bardd = '1') then
					newstate <= CLEAR_STATE;
				elsif (collisiond = '1' or copyd = '1') then
					newstate <= PCWATCH_STATE;
				else
					newstate <= PHOLD_STATE;
				end if;
			when PCWATCH_STATE =>
				partition_bar <= '0';
				ccclr <= '0';
				ccinc <= '0';
				nocolclr <= '0';
				nocolinc <= '1';
				if (enable_bardd = '1') then
					newstate <= CLEAR_STATE;
				elsif (carpres = '1') then
					newstate <= PWAIT_STATE;
				elsif (quietd = '0') then
					newstate <= PHOLD_STATE;
				elsif (nocoldone = '1' and copyd = '1') then
					newstate <= WAIT_STATE;
				else
					newstate <= PCWATCH_STATE;
				end if;
			when WAIT_STATE =>
				partition_bar <= '0';
				ccclr <= '1';
				ccinc <= '0';
				nocolclr <= '1';
				nocolinc <= '0';
				if (enable_bardd = '1') then
					newstate <= CLEAR_STATE;
				elsif (carpres = '0' and quietd = '1') then
					newstate <= IDLE_STATE;
				else
					newstate <= WAIT_STATE;
				end if;
		end case;
	end process p1;

	p1clk : process (txclk,areset) is
	begin
		if (areset = '1') then
			state <= clear_state;
		elsif (rising_edge(txclk)) then
			state <= newstate;
		end if;
	end process p1clk;
	
end archporte;
