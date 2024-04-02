----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:02:21 08/06/2021 
-- Design Name: 
-- Module Name:    pll - Behavioral 
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

--
-- WIP BASED ON PLL FROM OpenSPARCT2.1.3 PROJECT
-- 

entity n2_core_pll_cust is
port (
pll_char_out : out bit_vector(1 downto 0);
pll_sys_clk : in bit_vector(1 downto 0);
dr_sel_a : in bit_vector(1 downto 0);
dr_sdel : in bit_vector(1 downto 0);
pll_sdel : in bit_vector(1 downto 0);
pll_sel_a : in bit_vector(1 downto 0);
pll_div4 : in bit_vector(6 downto 0);
pll_div3 : in bit_vector(5 downto 0);
pll_div2 : in bit_vector(5 downto 0);
pll_div1 : in bit_vector(5 downto 0);
pll_clk_out_l : out bit;
dr_clk_out_l : out bit;
pll_clk_out : out bit;
dr_clk_out : out bit;
ccu_rst_ref_buf2 : out bit;
ccu_rst_sys_clk : out bit;
sel_l2clk_fbk : in bit;
dr_stretch_a : in bit;
pll_clamp_fltr : in bit;
dr_ext_clk : in bit;
ccu_serdes_dtm : in bit;
pll_ext_clk : in bit;
vreg_selbg_l : in bit;
l2clk : in bit;
dft_rst_a_l : in bit;
pll_char_in : in bit;
pll_arst_l : in bit;
vdd_hv15 : in bit;
pll_stretch_a : in bit;
pll_bypass : in bit;
pll_testmode : in bit
);
end entity n2_core_pll_cust;
architecture Behavioral of n2_core_pll_cust is
signal vdd : bit := '1';
signal vss : bit := '0';
signal vdd_reg : bit := '1';
signal net0210 : bit_vector(9 downto 0);
signal pll_jtag_lock_everlose,fast_l,ref_ck,l1clk_buf,net0189,fast_buf,vco2_clk,slow_buf,
ref,pll_lock_pulse,dc_clk,pfd_reset,pll_lock_dyn,vco8_clk,net0131,net0132,bypass_clk,
net0135,net0136,net0139,slow,fb,net0144,fast,net159,fb_ck,net0114,net163,div_ck3,
net0117,dr_clk,fltr,net080,slow_l,vco_out,net0172,timed_pll_arst_l : bit;
component n2_core_pll_vco_sum_cust is
port (
dc_clk : in bit;
volb : out bit;
vdd_reg : in bit;
slow : in bit;
slow_l : in bit;
fast : in bit;
fltr : in bit;
fast_l : in bit
);
end component n2_core_pll_vco_sum_cust;
component n2_core_pll_tpm3_all_cust is
port (
pll_stretch_a : in bit;
ccu_serdes_dtm : in bit;
dr_ext_clk : in bit;
dc_clk : out bit;
pll_clk_out_l : out bit;
pll_div3 : in bit_vector(5 downto 0);
pll_sdel : in bit_vector(1 downto 0);
pll_sel_a : in bit_vector(1 downto 0);
pll_bypass_clk_en : in bit;
pll_arst_l : in bit;
dr_clk_out : out bit;
pll_bypass_clk : in bit;
pll_clk_out : out bit;
dr_clk_out_l : out bit;
dr_stretch_a : in bit;
pll_testmode : in bit;
dr_sdel : in bit_vector(1 downto 0);
vco8_clk : out bit;
dr_sel_a : in bit_vector(1 downto 0);
volb : in bit;
vco2_clk : out bit;
pll_ext_clk : in bit;
pll_div4 : in bit_vector(6 downto 0);
dft_rst_a_l : in bit
);
end component n2_core_pll_tpm3_all_cust;
component n2_core_pll_inv_1x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_1x_cust;
component n2_core_pll_vdd_xing_buf_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_vdd_xing_buf_4x_cust;
component n2_core_pll_charc_cust is
port (
arst_l : in bit;
ccu_rst_ref_buf2_l : out bit;
testmode : in bit;
dr_clk_out : in bit;
ccu_rst_sys_clk : out bit;
lock : in bit;
pll_charc_out : out bit_vector(1 downto 0);
fb_clk_l : in bit;
pll_charc_in : in bit;
ref_clk_l : in bit;
fast : in bit;
slow : in bit;
ref : in bit;
fb : in bit;
vco_clk : in bit;
l1clk : in bit
);
end component n2_core_pll_charc_cust;
component n2_core_pll_inv_32x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_32x_cust;
component n2_core_pll_inv_4x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_4x_cust;
component n2_core_pll_inv_8x_cust is
port (
vdd_reg : in bit;
o : out bit;
i : in bit
);
end component n2_core_pll_inv_8x_cust;
component n2_core_pll_pecl_all_cust is
port (
regdivcr : out bit;
ref_ck : out bit;
slow_l : out bit;
fast : out bit;
fast_l : out bit;
pll_clamp_fltr : in bit;
pll_lock_pulse : out bit;
vdd_reg : in bit;
fb_ck : out bit;
pll_bypass_clk_en : in bit;
ccu_serdes_dtm : in bit;
l2clk : in bit;
slow : out bit;
slow_buf : out bit;
pll_jtag_lock_everlose : out bit;
pll_lock_dyn : out bit;
raw_clk_byp : out bit;
fast_buf : out bit;
l2clkc : in bit;
testmode : in bit;
pll_arst_l : in bit;
pll_div1 : in bit_vector(5 downto 0);
pll_div2 : in bit_vector(5 downto 0);
ref : out bit;
fb : out bit;
pll_sys_clk : in bit_vector(1 downto 0);
l1clk_buf : out bit;
pfd_reset : out bit;
fltr : out bit
);
end component n2_core_pll_pecl_all_cust;
component imaginary_timed_rst is
port (
ref : in bit;
vco_clk : in bit;
pll_div2 : in bit_vector(5 downto 0);
pll_arst_l : in bit;
timed_pll_arst_l : out bit
);
end component imaginary_timed_rst;
begin
x2 : n2_core_pll_vco_sum_cust port map (
dc_clk => dc_clk,
vdd_reg => vdd_reg,
volb => vco_out,
slow => slow,
slow_l => slow_l,
fast => fast,
fltr => fltr,
fast_l => fast_l
);
x6 : n2_core_pll_tpm3_all_cust port map (
pll_div3 => pll_div3,
pll_sdel => pll_sdel,
pll_sel_a => pll_sel_a,
dr_sdel => dr_sdel,
dr_sel_a => dr_sel_a,
pll_div4 => pll_div4,
pll_stretch_a => pll_stretch_a,
ccu_serdes_dtm => ccu_serdes_dtm,
dr_ext_clk => dr_ext_clk,
dc_clk => dc_clk,
pll_clk_out_l => net0132,
pll_bypass_clk_en => pll_bypass,
--pll_arst_l => pll_arst_l,
pll_arst_l => timed_pll_arst_l,	-- worked around non-deterministic reset - mh157021
dr_clk_out => dr_clk,
pll_bypass_clk => bypass_clk,
pll_clk_out => net0144,
dr_clk_out_l => net0131,
dr_stretch_a => dr_stretch_a,
pll_testmode => pll_testmode,
vco8_clk => vco8_clk,
volb => not vco_out,
vco2_clk => vco2_clk,
pll_ext_clk => pll_ext_clk,
dft_rst_a_l => dft_rst_a_l
);
x8 : n2_core_pll_inv_1x_cust port map (
vdd_reg => vdd,
o => net163,
i => pll_arst_l
);
x9 : n2_core_pll_vdd_xing_buf_4x_cust port map (
vdd_reg => vdd_reg,
o => net159,
i => net163
);
xcharc : n2_core_pll_charc_cust port map (
pll_charc_out => pll_char_out,
arst_l => pll_arst_l,
ccu_rst_ref_buf2_l => net0139,
testmode => pll_testmode,
dr_clk_out => dr_clk,
ccu_rst_sys_clk => ccu_rst_sys_clk,
lock => pll_lock_dyn,
fb_clk_l => fb_ck,
pll_charc_in => pll_char_in,
ref_clk_l => ref_ck,
fast => fast_buf,
slow => slow_buf,
ref => ref,
fb => fb,
vco_clk => vco8_clk,
l1clk => l1clk_buf
);
x14 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd,
o => pll_clk_out_l,
i => net0144
);
x15 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd,
o => dr_clk_out_l,
i => dr_clk
);
x16 : n2_core_pll_inv_4x_cust port map (
vdd_reg => vdd_reg,
o => net0117,
i => net0172
);
x17 : n2_core_pll_inv_8x_cust port map (
vdd_reg => vdd_reg,
o => net0114,
i => net0117
);
x18 : n2_core_pll_inv_32x_cust port map (
vdd_reg => vdd,
o => ccu_rst_ref_buf2,
i => net0139
);
x1 : n2_core_pll_pecl_all_cust port map (
pll_div1 => pll_div1,
pll_div2 => pll_div2,
pll_sys_clk => pll_sys_clk,
regdivcr => div_ck3,
ref_ck => ref_ck,
slow_l => slow_l,
fast => fast,
fast_l => fast_l,
pll_clamp_fltr => net0114,
pll_lock_pulse => pll_lock_pulse,
vdd_reg => vdd_reg,
fb_ck => fb_ck,
pll_bypass_clk_en => pll_bypass,
ccu_serdes_dtm => ccu_serdes_dtm,
l2clk => l2clk,
slow => slow,
slow_buf => slow_buf,
pll_jtag_lock_everlose => pll_jtag_lock_everlose,
pll_lock_dyn => pll_lock_dyn,
raw_clk_byp => bypass_clk,
fast_buf => fast_buf,
l2clkc => vco2_clk,
testmode => sel_l2clk_fbk,
pll_arst_l => pll_arst_l,
ref => ref,
fb => fb,
l1clk_buf => l1clk_buf,
pfd_reset => pfd_reset,
fltr => fltr
);
itr: imaginary_timed_rst port map (
ref => ref,
vco_clk => vco_out,
pll_arst_l => pll_arst_l,
pll_div2 => pll_div2,
timed_pll_arst_l => timed_pll_arst_l
);
end architecture Behavioral;


















