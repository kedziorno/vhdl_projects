----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:06:53 02/26/2021 
-- Design Name: 
-- Module Name:    pwm - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: Majewski,Zbysiński "Układy FPGA w przykładach" list.4.24 p.97
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

entity PWM is
Generic (PWM_RES : integer := 4);
Port (
	clk : in  STD_LOGIC;
	res : in  STD_LOGIC;
	ld : in  STD_LOGIC;
	data : in  STD_LOGIC_VECTOR (PWM_RES-1 downto 0);
	pwm : out  STD_LOGIC
);
end PWM;

architecture Behavioral of pwm is
	signal data_int_cmp,data_int,cnt_out : std_logic_vector(PWM_RES-1 downto 0);
	signal res_pwm_o,q,co : std_logic;
	constant ZERO : std_logic_vector(PWM_RES-1 downto 0) := (others=>'0');
	constant FF : std_logic_vector(PWM_RES-1 downto 0) := (others=>'1');
begin
	p0 : process (ld,res,data) is -- reg in 1st
	begin
		if (res = '1') then
			data_int <= (others => '0');
		elsif (ld = '1') then
			data_int <= data;
		end if;
	end process p0;
	
	p1 : process (co,res) is -- reg in 2st
	begin
		if (res = '1') then
			data_int_cmp <= (others => '0');
		elsif (rising_edge(co)) then
			data_int_cmp <= data_int;
		end if;
	end process p1;
	
	p2 : process (clk,res) is -- PWM counter
	begin
		if (res = '1') then
			cnt_out <= (others => '0');
		elsif (rising_edge(clk)) then
			cnt_out <= std_logic_vector(to_unsigned(to_integer(unsigned(cnt_out))+1,PWM_RES));
		end if;
	end process p2;
	
	p3 : process (clk,res,cnt_out) is -- signal gen carry from counter
	begin
		if (res = '1' or cnt_out < FF) then
			co <= '0';
		elsif (rising_edge(clk) and cnt_out = FF) then
			co <= '1';
		end if;
	end process p3;
	
	p4 : process (data_int_cmp,cnt_out) is -- PWM comparator
	begin
		if (cnt_out = ZERO) then
			res_pwm_o <= '0';
		elsif (data_int_cmp >= cnt_out) then
			res_pwm_o <= '1';
		else
			res_pwm_o <= '0';
		end if;
	end process p4;
	
	p5 : process (clk,res,res_pwm_o) is
	begin
		if (res = '1') then
			q <= '0';
		elsif (rising_edge(clk)) then
			q <= res_pwm_o;
		end if;
	end process p5;
	
	pwm <= q;
end Behavioral;

