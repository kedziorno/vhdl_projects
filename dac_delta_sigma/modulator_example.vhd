library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulator is
generic (
	N_AUDIO : integer := 16;
	N_DELTA : integer := 24;
	N_SIGMA : integer := 32;
	N_DELAY : integer := 25
port (
);
	i_clock : in std_logic;
	i_reset : in std_logic; -- resetb?
	i_audio : in signed(N_AUDIO-1 downto 0);
	i_pwm_fb : in signed(N_DELTA-1 downto 0);
	o_pwm_out : out std_logic
);
end entity modulator;

architecture arch of modulator is
	signal compare : std_logic;
	signal delta,feedback : signed(N_DELTA-1 downto 0);
	signal sigma : signed(N_SIGMA-1 downto 0);
	signal delay : std_logic_vector(N_DELAY-1 downto 0);
begin
	-- discrete-time model of first-order asynch delta-sigma modulator
	p0 : process (i_clock,i_reset) is
	begin
		if (reset = '1') then
			delta <= 0;
			sigma <= 0;
			delay <= (others => '0');
		elsif (rising_edge(i_clock)) then
			delta <= audio_in - feedback;
			sigma <= sigma + delta;
			delay <= delay(N_DELAY-2 downto 0) & compare;
		end if;
	end process p0;
	
	-- comparator : check sign bit (MSB) of input word
	compare <= not sigma(N_SIGMA-1);
	-- PWM out : last bit of delay line
	pwm_out <= delay(N_DELAY-1);
	-- generate feedback amplitude from PWM state
	feedback <= pwm_fb when (pwm_out = '1') else -pwm_fb;
end architecture arch;

