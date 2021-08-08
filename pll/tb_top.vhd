--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:34:46 08/08/2021
-- Design Name:   
-- Module Name:   /home/user/workspace/vhdl_projects/pll/tb_top.vhd
-- Project Name:  pll
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: n2_core_pll_cust
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_top IS
END tb_top;

ARCHITECTURE behavior OF tb_top IS
-- Component Declaration for the Unit Under Test (UUT)
COMPONENT n2_core_pll_cust
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
END COMPONENT;

--Inputs
signal pll_sys_clk : bit_vector(1 downto 0) := (others => '0');
signal dr_sel_a : bit_vector(1 downto 0) := (others => '0');
signal dr_sdel : bit_vector(1 downto 0) := (others => '0');
signal pll_sdel : bit_vector(1 downto 0) := (others => '0');
signal pll_sel_a : bit_vector(1 downto 0) := (others => '0');
signal pll_div4 : bit_vector(6 downto 0) := (others => '0');
signal pll_div3 : bit_vector(5 downto 0) := (others => '0');
signal pll_div2 : bit_vector(5 downto 0) := (others => '0');
signal pll_div1 : bit_vector(5 downto 0) := (others => '0');
signal sel_l2clk_fbk : bit := '0';
signal dr_stretch_a : bit := '0';
signal pll_clamp_fltr : bit := '0';
signal dr_ext_clk : bit := '0';
signal ccu_serdes_dtm : bit := '0';
signal pll_ext_clk : bit := '0';
signal vreg_selbg_l : bit := '0';
signal l2clk : bit := '0';
signal dft_rst_a_l : bit := '0';
signal pll_char_in : bit := '0';
signal pll_arst_l : bit := '0';
signal vdd_hv15 : bit := '0';
signal pll_stretch_a : bit := '0';
signal pll_bypass : bit := '0';
signal pll_testmode : bit := '0';

--Outputs
signal pll_char_out : bit_vector(1 downto 0);
signal pll_clk_out_l : bit;
signal dr_clk_out_l : bit;
signal pll_clk_out : bit;
signal dr_clk_out : bit;
signal ccu_rst_ref_buf2 : bit;
signal ccu_rst_sys_clk : bit;

-- Clock period definitions
constant pll_sys_clk_period : time := 10 ns;
constant ccu_rst_sys_clk_period : time := 10 ns;
constant dr_ext_clk_period : time := 10 ns;
constant pll_ext_clk_period : time := 10 ns;
constant l2clk_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: n2_core_pll_cust PORT MAP (
pll_char_out => pll_char_out,
pll_sys_clk => pll_sys_clk,
dr_sel_a => dr_sel_a,
dr_sdel => dr_sdel,
pll_sdel => pll_sdel,
pll_sel_a => pll_sel_a,
pll_div4 => pll_div4,
pll_div3 => pll_div3,
pll_div2 => pll_div2,
pll_div1 => pll_div1,
pll_clk_out_l => pll_clk_out_l,
dr_clk_out_l => dr_clk_out_l,
pll_clk_out => pll_clk_out,
dr_clk_out => dr_clk_out,
ccu_rst_ref_buf2 => ccu_rst_ref_buf2,
ccu_rst_sys_clk => ccu_rst_sys_clk,
sel_l2clk_fbk => sel_l2clk_fbk,
dr_stretch_a => dr_stretch_a,
pll_clamp_fltr => pll_clamp_fltr,
dr_ext_clk => dr_ext_clk,
ccu_serdes_dtm => ccu_serdes_dtm,
pll_ext_clk => pll_ext_clk,
vreg_selbg_l => vreg_selbg_l,
l2clk => l2clk,
dft_rst_a_l => dft_rst_a_l,
pll_char_in => pll_char_in,
pll_arst_l => pll_arst_l,
vdd_hv15 => vdd_hv15,
pll_stretch_a => pll_stretch_a,
pll_bypass => pll_bypass,
pll_testmode => pll_testmode
);

-- Clock process definitions
pll_sys_clk_process :process
begin
pll_sys_clk <= "00";
wait for pll_sys_clk_period/4;
pll_sys_clk <= "01";
wait for pll_sys_clk_period/4;
pll_sys_clk <= "10";
wait for pll_sys_clk_period/4;
pll_sys_clk <= "11";
wait for pll_sys_clk_period/4;
end process;

--ccu_rst_sys_clk_process :process
--begin
--ccu_rst_sys_clk <= '0';
--wait for ccu_rst_sys_clk_period/2;
--ccu_rst_sys_clk <= '1';
--wait for ccu_rst_sys_clk_period/2;
--end process;

dr_ext_clk_process :process
begin
dr_ext_clk <= '0';
wait for dr_ext_clk_period/2;
dr_ext_clk <= '1';
wait for dr_ext_clk_period/2;
end process;

pll_ext_clk_process :process
begin
pll_ext_clk <= '0';
wait for pll_ext_clk_period/2;
pll_ext_clk <= '1';
wait for pll_ext_clk_period/2;
end process;

l2clk_process :process
begin
l2clk <= '0';
wait for l2clk_period/2;
l2clk <= '1';
wait for l2clk_period/2;
end process;

-- Stimulus process
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
wait for pll_sys_clk_period*10;
-- insert stimulus here
wait;
end process;

END;
