-------------------------------------------------------------------------------
-- Copyright (c) 2006 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor      : Xilinx
-- \   \   \/     Version     : J.23
--  \   \         Description : Xilinx HDL Macro Library
--  /   /                       Toggle Flip-Flop with Toggle and Clock Enable and Synchronous Reset and Set
-- /___/   /\     Filename    : FTRSE.vhd
-- \   \  /  \    Timestamp   : Tues Jul 18 2006
--  \___\/\___\
--
-- Revision:
-- 07/18/06 - Initial version.
-- End Revision

----- CELL FTRSE -----


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FTRSE is
generic(
    INIT : bit := '0'
    );

  port (
    Q   : out STD_LOGIC;
    C   : in STD_LOGIC;
    CE  : in STD_LOGIC;
    R   : in STD_LOGIC;
    S   : in STD_LOGIC;
    T   : in STD_LOGIC
    );
end FTRSE;

architecture Behavioral of FTRSE is
signal q_tmp : std_logic := TO_X01(INIT);
begin

process(C)
begin
  if (C'event and C = '1') then
    if(R='1') then
      q_tmp <= '0';
    elsif(S='1') then
      q_tmp <= '1';
    elsif(CE='1') then
      if(T='1') then
        q_tmp <= not q_tmp;
      end if;
    end if;
  end if;  
end process;

Q <= q_tmp;

end Behavioral;

