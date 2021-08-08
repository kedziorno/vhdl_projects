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
signal mult,mult2x : bit_vector(6 downto 0);
signal vco_shift : bit;
signal tmp_clk1,tmp_clk2,tmp_clk3,tmp_clk4 : bit;
signal lock_cnt : bit_vector(2 downto 0);
signal qnt_err : time;
begin
--synthesis translate_off
mult <= div + '1';
mult2x <= (mult(5 downto 0),'0'); 
p0 : process (sysclk) is
begin
	if (rising_edge(sysclk)) then
	t0 <= NOW;
	t1 <= NOW;
	ref_per = t1 - t0;
	vco_per = ref_per / (div+'1');
	vco_hi_ph = ref_per / (mult2x);
	vco_lo_ph = vco_per - vco_hi_ph; 
	qnt_err = ref_per - (vco_hi_ph + vco_lo_ph) * mult;
	end if;
end process p0;
p1 : process (sysclk) is
begin
	vco_tmp <= '1';
	l0 : for j in 1 to mult loop
		vco_tmp <= '0' after vco_hi_ph ns;
		if ((j = shift_rigth(mult,1)) and (qnt_err /= 0)) then
			j := j / 2;
		end if;
		vco_tmp <= '1';
	end loop l0;
	vco_tmp <= '0'; after vco_hi_ph;
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
		posedge_vco_tmp <= 0;
		posedge_fdbkclk <= 0;
		adj_delay <= 0;
		insdelay <= 0;
		ph_offset_past <= 360;		
	elsif (rising_edge(vco_tmp)) then
		if (locked) then
			indelay <= insdelay;
		else
			posedge_vco_tmp = NOW;
			wait for rising_edge(fdbkclk);
			posedge_fdbkclk = NOW;
			insdelay = posedge_fdbkclk - posedge_vco_tmp;
		end if;
		l1 : while (vco_per <= insdelay) loop 
			insdelay = insdelay - vco_per;
		end loop l1; 
		adj_delay = vco_per - insdelay;
	end if;
end process p2;
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

