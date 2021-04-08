----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:11:00 11/28/2020
-- Design Name: 
-- Module Name:    /home/user/workspace/vhdl_projects/memorymodule/memorymodule.vhd
-- Project Name:   memorymodule
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

--
-- Module: 	XC2V_RAMB_1_PORT
--
-- Description: 18Kb Block SelectRAM example
--		Single Port 512 x 36 bits
--		Use template "SelectRAM_A36.vhd"
--
-- Device: 	Spartan-3 Family 
-- Date:        April, 2003
-- Disclaimer:  THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY 
--              WHATSOEVER AND XILINX SPECIFICALLY DISCLAIMS ANY 
--              IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR/
--              A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
--
--  Copyright (c) 2003 Xilinx, Inc.  All rights reserved.
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.p_memory_content.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
-- pragma translate_off
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
-- pragma translate_on

entity memorymodule is
Port (
i_clock : in std_logic;
i_reset : in std_logic;
i_enable : in std_logic;
i_write : in std_logic;
i_read : in std_logic;
o_busy : out std_logic;
i_db_fs : in std_logic;
i_MemAdr : in MemoryAddressALL;
i_MemDB : in MemoryDataByte;
o_MemDB : out MemoryDataByte;
io_MemOE : out std_logic;
io_MemWR : out std_logic;
io_RamAdv : out std_logic;
io_RamCS : out std_logic;
io_RamLB : out std_logic;
io_RamCRE : out std_logic;
io_RamUB : out std_logic;
io_RamClk : out std_logic;
io_MemAdr : out MemoryAddressALL;
io_MemDB : inout MemoryDataByte
);
end memorymodule;

architecture Behavioral of memorymodule is

component BUFG
port (
I	: in std_logic;
O	: out std_logic
);
end component;

component RAMB16_S36 
-- pragma translate_off
generic (
-- "Read during Write" attribute for functional simulation
WRITE_MODE : string := "NO_CHANGE" ; -- WRITE_FIRST(default)/ READ_FIRST/ NO_CHANGE 	
-- Output value after configuration       	
INIT : bit_vector(35 downto 0)  := X"000000000";
-- Output value if SSR active       
SRVAL : bit_vector(35 downto 0)  := X"012345678";
-- Plus bits initial content
INITP_00 : bit_vector(255 downto 0) := 
X"000000000000000000000000000000000000000000000000FEDCBA9876543210";
INITP_01 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INITP_02 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INITP_03 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INITP_04 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INITP_05 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INITP_06 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INITP_07 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
-- Regular bits initial content
INIT_00 : bit_vector(255 downto 0) := 
X"000000000000000000000000000000000000000000000000FEDCBA9876543210";
INIT_01 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_02 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_03 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_04 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_05 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_06 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_07 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_08 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_09 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0A : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0B : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0C : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0D : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0E : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0F : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_10 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_11 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_12 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_13 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_14 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_15 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_16 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_17 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_18 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_19 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1A : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1B : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1C : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1D : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1E : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1F : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_20 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_21 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_22 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_23 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_24 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_25 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_26 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_27 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_28 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_29 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2A : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2B : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2C : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2D : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2E : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2F : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_30 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_31 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_32 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_33 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_34 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_35 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_36 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_37 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_38 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_39 : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3A : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3B : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3C : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3D : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3E : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3F : bit_vector(255 downto 0) := 
X"0000000000000000000000000000000000000000000000000000000000000000"
);
-- pragma translate_on
port (
DI     : in std_logic_vector (31 downto 0);
DIP    : in std_logic_vector (3 downto 0);
ADDR   : in std_logic_vector (8 downto 0);        
EN     : in STD_LOGIC;
WE     : in STD_LOGIC;
SSR    : in STD_LOGIC;
CLK    : in STD_LOGIC;
DO     : out std_logic_vector (31 downto 0);
DOP    : out std_logic_vector (3 downto 0)	
); 
end component;

-- Attribute Declarations:
attribute WRITE_MODE : string;
attribute INIT: string;
attribute SRVAL: string;
--
attribute INITP_00: string;
attribute INITP_01: string;
attribute INITP_02: string;
attribute INITP_03: string;
attribute INITP_04: string;
attribute INITP_05: string;
attribute INITP_06: string;
attribute INITP_07: string; 
-- 
attribute INIT_00: string;
attribute INIT_01: string;
attribute INIT_02: string;
attribute INIT_03: string;
attribute INIT_04: string;
attribute INIT_05: string;
attribute INIT_06: string;
attribute INIT_07: string;
attribute INIT_08: string;
attribute INIT_09: string;
attribute INIT_0A: string;
attribute INIT_0B: string;
attribute INIT_0C: string;
attribute INIT_0D: string;
attribute INIT_0E: string;
attribute INIT_0F: string;
attribute INIT_10: string;
attribute INIT_11: string;
attribute INIT_12: string;
attribute INIT_13: string;
attribute INIT_14: string;
attribute INIT_15: string;
attribute INIT_16: string;
attribute INIT_17: string;
attribute INIT_18: string;
attribute INIT_19: string;
attribute INIT_1A: string;
attribute INIT_1B: string;
attribute INIT_1C: string;
attribute INIT_1D: string;
attribute INIT_1E: string;
attribute INIT_1F: string;
attribute INIT_20: string;
attribute INIT_21: string;
attribute INIT_22: string;
attribute INIT_23: string;
attribute INIT_24: string;
attribute INIT_25: string;
attribute INIT_26: string;
attribute INIT_27: string;
attribute INIT_28: string;
attribute INIT_29: string;
attribute INIT_2A: string;
attribute INIT_2B: string;
attribute INIT_2C: string;
attribute INIT_2D: string;
attribute INIT_2E: string;
attribute INIT_2F: string;
attribute INIT_30: string;
attribute INIT_31: string;
attribute INIT_32: string;
attribute INIT_33: string;
attribute INIT_34: string;
attribute INIT_35: string;
attribute INIT_36: string;
attribute INIT_37: string;
attribute INIT_38: string;
attribute INIT_39: string;
attribute INIT_3A: string;
attribute INIT_3B: string;
attribute INIT_3C: string;
attribute INIT_3D: string;
attribute INIT_3E: string;
attribute INIT_3F: string;
--
-- Attribute "Read during Write mode" = WRITE_FIRST(default)/ READ_FIRST/ NO_CHANGE
attribute WRITE_MODE of U_RAMB16_S36: label is "NO_CHANGE"; 
attribute INIT of U_RAMB16_S36: label is "000000000";
attribute SRVAL of U_RAMB16_S36: label is "012345678";
--
-- RAMB16 memory initialization for Alliance
-- Default value is "0" / Partial initialization strings are padded with zeros to the left
attribute INITP_00 of U_RAMB16_S36: label is 
"000000000000000000000000000000000000000000000000FEDCBA9876543210";
attribute INITP_01 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_02 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_03 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_04 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_05 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_06 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INITP_07 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
--
attribute INIT_00 of U_RAMB16_S36: label is 
"000000000000000000000000000000000000000000000000FEDCBA9876543210";
attribute INIT_01 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_02 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_03 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_04 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_05 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_06 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_07 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_08 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_09 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0A of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0B of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0C of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0D of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0E of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_0F of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_10 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_11 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_12 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_13 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_14 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_15 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_16 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_17 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_18 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_19 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1A of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1B of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1C of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1D of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1E of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_1F of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_20 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_21 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_22 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_23 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_24 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_25 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_26 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_27 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_28 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_29 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2A of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2B of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2C of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2D of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2E of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_2F of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_30 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_31 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_32 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_33 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_34 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_35 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_36 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_37 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_38 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_39 of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3A of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3B of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3C of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3D of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3E of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";
attribute INIT_3F of U_RAMB16_S36: label is 
"0000000000000000000000000000000000000000000000000000000000000000";

	type state is (
	idle,
	start,
	write_setup,
	read_setup,
	write_enable,
	wait1,
	write_disable,
	stop,
	read1,
	wait2
	);
	signal cstate : state;

	signal enable : std_logic;
	signal write1 : std_logic;
	signal MemOE : std_logic;
	signal MemWR : std_logic;
	signal RamAdv : std_logic;
	signal RamCS : std_logic;
	signal RamLB : std_logic;
	signal RamCRE : std_logic;
	signal RamUB : std_logic;
	signal RamClk : std_logic;
	signal MemAdr : MemoryAddressALL;
	signal MemDB : MemoryDataByte;

signal CLK_BUFG	: std_logic;
signal INV_SET_RESET : std_logic;
signal parity : std_logic_vector(3 downto 0);

begin

--
-- VCC <= '1';
-- GND <= '0';
--
-- Instantiate the clock Buffer
U_BUFG: BUFG
port map (
I => i_clock,
O => CLK_BUFG
);
--
-- Use of the free inverter on SSR pin
INV_SET_RESET <= NOT i_reset;

-- Block SelectRAM Instantiation
U_RAMB16_S36: RAMB16_S36
port map (
DI     => i_MemDB(31 downto 0), -- insert 32 bits data in bus (<31 downto 0>)
DIP    => parity, -- insert 4 bits parity data in bus (or <35 downto 32>)
ADDR   => i_MemAdr, -- insert 9 bits address bus        
EN     => i_enable, -- insert enable signal
WE     => i_write, -- insert write enable signal
SSR    => i_reset, -- insert set/reset signal
CLK    => CLK_BUFG, -- insert clock signal
DO     => o_MemDB(31 downto 0), -- insert 32 bits data out bus (<31 downto 0>)
DOP    => parity  -- insert 4 bits parity data out bus (or <35 downto 32>)
);

	io_MemOE <= MemOE;
	io_MemWR <= MemWR;
	io_RamAdv <= RamAdv;
	io_RamCS <= RamCS;
	io_RamLB <= RamLB;
	io_RamCRE <= RamCRE;
	io_RamUB <= RamUB;
	io_RamClk <= RamClk;
	io_MemAdr <= MemAdr;

	RamLB <= '0';
	RamUB <= '0';
	RamCRE <= '0';
	RamAdv <= '0';
	RamClk <= '0';

	--MemAdr <= i_MemAdr when (RamCS = '0' and (MemWR = '0' or MemOE = '0')) else (others => 'Z');
	--o_MemDB <= io_MemDB when (cstate = idle) else (others => 'Z');
	--io_MemDB <= i_MemDB when (RamCS = '0' and MemWR = '0') else (others => 'Z');

	p0 : process (i_clock) is
		constant cw : integer := 6;
		variable w : integer range 0 to cw := 0;
		variable t : std_logic_vector(G_MemoryData-1 downto 0);
		variable tz : std_logic_vector(G_MemoryData-1 downto 0) := (others => 'Z');
	begin
		if (rising_edge(i_clock)) then
			if (w > 0) then
				w := w - 1;
			end if;
			case cstate is
				when idle =>
					if (i_enable = '1') then
						cstate <= start; -- XXX check CSb
					else
						cstate <= idle;
					end if;
				when start =>
					if (i_write = '1') then
						cstate <= write_setup;
					elsif (i_read = '1') then
						cstate <= read_setup;
					else
						cstate <= start;
					end if;
					RamCS <= '1';
					MemWR <= '1';
					MemOE <= '1';
					enable <= '0';
					MemAdr <= i_MemAdr;
					MemDB <= i_MemDB;
				when write_setup =>
					if (w = 0) then
						cstate <= write_enable;
						o_busy <= '1';
						MemOE <= '1';
					else
						cstate <= write_setup;
					end if;
				when write_enable =>
					cstate <= wait1;
					enable <= '1';
					write1 <= '1';
					MemWR <= '0';
					RamCS <= '0';
					w := cw;
				when wait1 =>
					if (w = 0) then
						cstate <= write_disable;
					else
						cstate <= wait1;
					end if;
				when write_disable =>
					cstate <= stop;
					RamCS <= '1';
					MemWR <= '1';
					write1 <= '0';
					enable <= '0';
				when read_setup =>
					if (w = 0) then
						cstate <= read1;
						RamCS <= '0';
						MemOE <= '0';
						o_busy <= '1';
						enable <= '1';
						write1 <= '0';
					else
						cstate <= read_setup;
					end if;
				when read1 =>
					cstate <= wait2;
					w := cw;
					write1 <= '0';
				when wait2 =>
					if (w = 0) then
						cstate <= stop;
					else
						cstate <= wait2;
					end if;
				when stop =>
					cstate <= idle;
					o_busy <= '0';
					RamCS <= '1';
					MemOE <= '1';
					enable <= '0';
				when others => null;
			end case;
		end if;
	end process p0;

end Behavioral;
