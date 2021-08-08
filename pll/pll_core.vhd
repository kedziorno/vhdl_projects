LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity pll_core is
port (
pll_arst_l : in bit;
sysclk : in bit;
fdbkclk : in bit;
div : in bit_vector(5 downto 0);
vco_out : out bit
);
end entity pll_core;
architecture arch of pll_core is
signal vco_tmp,locked : bit;
signal neg_delay,ref_per,vco_per,vco_hi_ph,vco_lo_ph : time;
signal t0,t1,posedge_vco_tmp,posedge_fdbkclk,insdelay,adj_delay : time := 0 ps;
signal j,ph_offset_past,ph_offset : integer;
signal pulse_cnt : integer := 2;
signal mult,mult2x : unsigned(6 downto 0) := (others => '0');
signal vco_shift : bit;
signal tmp_clk1,tmp_clk2,tmp_clk3,tmp_clk4 : bit;
signal lock_cnt : bit_vector(2 downto 0);
signal qnt_err : time;
--synthesis translate_off
--https://groups.google.com/g/comp.lang.vhdl/c/OxgjdpZDOxU/m/SOB3tlzxQwgJ
---------------------------------------------------------- to_sl ---
---- convert 'bit' to 'std_logic' ---
---------------------------------------------------------- to_sl ---
function to_sl(b: bit) return std_logic is
begin
if b='1' then
return '1';
else
return '0';
end if;
end;
--------------------------------------------------------- to_slv ---
---- convert 'bit_vector' to 'std_logic_vector' ---
--------------------------------------------------------- to_slv ---
function to_slv(bv:bit_vector) return std_logic_vector is
variable sv: std_logic_vector(bv'RANGE);
begin
for i in bv'RANGE loop
sv(i) := to_sl(bv(i));
end loop;
return sv;
end;

begin
mult <= to_unsigned(to_integer(unsigned(to_slv(div))),7) + "1";
mult2x <= (mult(5 downto 0)&"0"); 
p0 : process (sysclk) is
begin
	t0 <= NOW;
	if (sysclk'event and sysclk = '1') then
	t1 <= NOW;
	ref_per <= t1 - t0;
	vco_per <= time(ref_per / (to_integer(unsigned(to_slv(div)))+1));
	vco_hi_ph <= ref_per / (to_integer(unsigned(mult2x)));
	vco_lo_ph <= vco_per - vco_hi_ph; 
	qnt_err <= ref_per - (vco_hi_ph + vco_lo_ph) * to_integer(unsigned(mult));
	end if;
end process p0;
p1 : process (sysclk) is
variable jj : integer := 0;
begin
	vco_tmp <= '1';
	l0 : for j in 1 to to_integer(mult) loop
		jj := j;
		vco_tmp <= '0' after vco_hi_ph;
		if ((jj = shift_right(mult,1)) and (qnt_err /= 0 ns)) then
			jj := jj / 2;
		end if;
		if (jj = 1) then
			exit;
		end if;
		vco_tmp <= '1';
	end loop l0;
	vco_tmp <= '0' after vco_hi_ph;
end process p1;
--always @ ( posedge  sysclk ) begin
--	vco_tmp = 1'b1;
--	for ( j = 1; j < mult; j = j+1 ) begin 	
--		#(vco_hi_ph) vco_tmp = 1'b0;  
--		if ((j == (mult >> 1))  && (qnt_err != 0)) // internal multiplier for N2 is always even 
--			#(j/2);
--		#(vco_lo_ph) vco_tmp = 1'b1;  
--	end
--	#(vco_hi_ph) vco_tmp = 1'b0;		// for remaining part of cycle
--end
p2 : process (vco_tmp,pll_arst_l) is
begin
	if (pll_arst_l = '0') then
		posedge_vco_tmp <= 0 ps;
		posedge_fdbkclk <= 0 ps;
		adj_delay <= 0 ps;
		insdelay <= 0 ps;
		ph_offset_past <= 360;		
	elsif (vco_tmp'event and vco_tmp = '1') then
		if (locked = '1') then
			insdelay <= insdelay;
		else
			posedge_vco_tmp <= NOW;
--			wait until (fdbkclk'event and fdbkclk = '1');
			posedge_fdbkclk <= NOW;
			insdelay <= posedge_fdbkclk - posedge_vco_tmp;
		end if;
		l1 : while (vco_per <= insdelay) loop 
			insdelay <= insdelay - vco_per;
		end loop l1; 
		adj_delay <= vco_per - insdelay;
	end if;
end process p2;
--XXX finish
--always @ ( posedge vco_tmp or negedge pll_arst_l ) begin
--	if (!pll_arst_l) begin
--		posedge_vco_tmp = 0;
--		posedge_fdbkclk = 0;
--		adj_delay = 0;
--		insdelay = 0;
--		ph_offset_past = 360;
--	end else begin
--		if (locked)
--			insdelay = insdelay;
--		else begin
--			posedge_vco_tmp = $realtime;
--			@(posedge fdbkclk );
--			posedge_fdbkclk = $realtime;
--			insdelay = posedge_fdbkclk - posedge_vco_tmp; 
--		end 
--		`ifdef PLL_PH_DEBUG
--		// DEBUG BEGIN
--		ph_offset = (360 * insdelay)/vco_per; 
--		if (ph_offset != ph_offset_past) 
--			$display ("phase offset changed changed from %d to %d degrees", 
--				ph_offset_past, ph_offset ); 
--		ph_offset_past = ph_offset;
--		// DEBUG END 
--		`endif
--		while (vco_per <= insdelay) 
--			insdelay = insdelay - vco_per ; 
--		adj_delay = vco_per - insdelay;		
-- 	end
--end

--assign vco_out = locked? vco_shift : vco_tmp;
--always @ (negedge sysclk or negedge pll_arst_l )  begin
--	if (!pll_arst_l) begin
--		locked <= 1'b0;
--		lock_cnt <= 3'b0;
--	end else begin
--		if (lock_cnt == `PLL_LOCK_CNT ) begin
--			locked <= 1'b1;
--			lock_cnt <= `PLL_LOCK_CNT; 
--		end else begin 
--			locked <= 1'b0;
--			lock_cnt <= lock_cnt + 1'b1; 
--		end
--	end
--end	
--`ifdef FDBK_TRACKING 	
--	always @ (vco_tmp)  tmp_clk1 = #(adj_delay/4) vco_tmp;
--	always @ (tmp_clk1) tmp_clk2 = #(adj_delay/4) tmp_clk1;
--	always @ (tmp_clk2) tmp_clk3 = #(adj_delay/4) tmp_clk2;
--	always @ (tmp_clk3) tmp_clk4 = #(adj_delay/4) tmp_clk3;
--`else 
--	always @ (vco_tmp)  tmp_clk1 = vco_tmp;
--	always @ (tmp_clk1) tmp_clk2 = tmp_clk1;
--	always @ (tmp_clk2) tmp_clk3 = tmp_clk2;
--	always @ (tmp_clk3) tmp_clk4 = tmp_clk3;
--`endif
--assign vco_shift = tmp_clk4;
--synthesis translate_on
end architecture arch;

