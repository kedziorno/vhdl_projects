----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:52:17 02/25/2025 
-- Design Name: 
-- Module Name:    counter_test2 - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- based on https://github.com/smunaut/ice40-playground/blob/d2fa0050129c14a7fc42f64f115366f6f2a51669/projects/usb_audio/rtl/audio_pcm.v#L221
-- less resources
-- -use_new_parser no
entity counter_test2 is
port (
i_clock : in std_logic;
i_reset : in std_logic;
i_a : in std_logic; -- -
i_b : in std_logic; -- +
o_counter : out std_logic_vector (31 downto 0)
);
end entity counter_test2;

architecture behavioral of counter_test2 is

signal zero_middle : std_logic_vector (31 downto 1);
signal counter : std_logic_vector (31 downto 0);
signal step : std_logic_vector (31 downto 0);

begin

o_counter <= std_logic_vector (counter);

-- LUT based counter
-- must wait one cycle for change +/- step (floating 1) - nevermind - zero_middle out of p0
-- synthesis
--Number of Slices
--17
--8672
--0%
--Number of Slice Flip Flops
--32
--17344
--0%
--Number of 4 input LUTs
--33
--17344
--0%
--Number of bonded IOBs
--36
--250
--14%
--Number of GCLKs
--1
--24
--4%
--Macro Statistics
--# Accumulators                                         : 1
-- 32-bit up accumulator                                 : 1
--# Xors                                                 : 1
-- 1-bit xor2                                            : 1
p0 : process (i_clock, i_reset) is
  variable temp : std_logic;
begin
  if (i_reset = '1') then
    counter <= (others => '0');
  elsif (rising_edge (i_clock)) then
    counter <= std_logic_vector (to_signed ((to_integer (signed (counter))) + to_integer (signed (step)), 32));
  end if;
end process p0;
zero_middle <= (others => ((i_a) and (not i_b)));
step <= (zero_middle) & (i_a xor i_b);

-- normal counter
-- synthesis
--Number of Slices
--17
--8672
--0%
--Number of Slice Flip Flops
--32
--17344
--0%
--Number of 4 input LUTs
--34
--17344
--0%
--Number of bonded IOBs
--36
--250
--14%
--Number of GCLKs
--1
--24
--4%
--Macro Statistics
--# Counters                                             : 1
-- 32-bit updown counter                                 : 1
--p1 : process (i_clock, i_reset) is
--  variable temp : std_logic;
--begin
--  if (i_reset = '1') then
--    counter <= (others => '0');
--  elsif (rising_edge (i_clock)) then
--    if (i_a = '1' and i_b = '0') then
--      counter <= std_logic_vector (to_signed ((to_integer (signed (counter))) - 1, 32));
--    elsif (i_a = '0' and i_b = '1') then
--      counter <= std_logic_vector (to_signed ((to_integer (signed (counter))) + 1, 32));
--    end if;
--  end if;
--end process p1;

end architecture behavioral;
