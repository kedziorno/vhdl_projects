----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:12:47 06/12/2021 
-- Design Name: 
-- Module Name:    arbiter - Behavioral 
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

entity arbiter8 is
port (
	txclk : in std_logic;
	areset : in std_logic;
	activity1 : in std_logic;
	activity2 : in std_logic;
	activity3 : in std_logic;
	activity4 : in std_logic;
	activity5 : in std_logic;
	activity6 : in std_logic;
	activity7 : in std_logic;
	activity8 : in std_logic;
	sel1 : out std_logic;
	sel2 : out std_logic;
	sel3 : out std_logic;
	sel4 : out std_logic;
	sel5 : out std_logic;
	sel6 : out std_logic;
	sel7 : out std_logic;
	sel8 : out std_logic;
	nosel : out std_logic;
	carrier : out std_logic;
	collision : out std_logic
);
end arbiter8;

use work.portetop_pkg.all;

architecture archarbiter8 of arbiter8 is
	signal colin,carin : std_logic;
	signal activityin1,activityin2,activityin3,activityin4,activityin5,activityin6,activityin7,activityin8 : std_logic;
	signal noactivity : std_logic;
begin
	u1 : rdff1 port map (txclk,areset,activity1,sel1);
	u2 : rdff1 port map (txclk,areset,activity2,sel2);
	u3 : rdff1 port map (txclk,areset,activity3,sel3);
	u4 : rdff1 port map (txclk,areset,activity4,sel4);
	u5 : rdff1 port map (txclk,areset,activity5,sel5);
	u6 : rdff1 port map (txclk,areset,activity6,sel6);
	u7 : rdff1 port map (txclk,areset,activity7,sel7);
	u8 : rdff1 port map (txclk,areset,activity8,sel8);

--	u9 : pdff1 port map (txclk,areset,noactivity,nosel);
	u9 : rdff1 port map (txclk,areset,noactivity,nosel);

	u10 : rdff1 port map (txclk,areset,colin,collision);
	u11 : rdff1 port map (txclk,areset,carin,carrier);

	activityin1 <= activity1;
	activityin2 <= activity2 and not activity1;
	activityin3 <= activity3 and not (activity1 or activity2);
	activityin4 <= activity4 and not (activity1 or activity2 or activity3);
	activityin5 <= activity5 and not (activity1 or activity2 or activity3 or activity4);
	activityin6 <= activity6 and not (activity1 or activity2 or activity3 or activity4 or activity5);
	activityin7 <= activity7 and not (activity1 or activity2 or activity3 or activity4 or activity5 or activity6);
	activityin8 <= activity8 and not (activity1 or activity2 or activity3 or activity4 or activity5 or activity6 or activity7);

	noactivity <= not (activity1 or activity2 or activity3 or activity4 or activity5 or activity6 or activity7 or activity8);

	colin <= 
	(activity1 and (activity2 or activity3 or activity4 or activity5 or activity6 or activity7 or activity8)) or
	(activity2 and (activity1 or activity3 or activity4 or activity5 or activity6 or activity7 or activity8)) or
	(activity3 and (activity1 or activity2 or activity4 or activity5 or activity6 or activity7 or activity8)) or
	(activity4 and (activity1 or activity2 or activity3 or activity5 or activity6 or activity7 or activity8)) or
	(activity5 and (activity1 or activity2 or activity3 or activity4 or activity6 or activity7 or activity8)) or
	(activity6 and (activity1 or activity2 or activity3 or activity4 or activity5 or activity7 or activity8)) or
	(activity7 and (activity1 or activity2 or activity3 or activity4 or activity5 or activity6 or activity8)) or
	(activity8 and (activity1 or activity2 or activity3 or activity4 or activity5 or activity6 or activity7));

	carin <= activity1 or activity2 or activity3 or activity4 or activity5 or activity6 or activity7 or activity8;
end archarbiter8;
