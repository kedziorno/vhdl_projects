----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Controller for the OV760 camera - transferes registers to the 
--              camera over an I2C like bus
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_controller is
    Port ( clk   : in    STD_LOGIC;
			  resend :in    STD_LOGIC;
			  config_finished : out std_logic;
           sioc  : out   STD_LOGIC;
           siod  : inout STD_LOGIC;
           reset : out   STD_LOGIC;
           pwdn  : out   STD_LOGIC;
			  xclk  : out   STD_LOGIC
);
end ov7670_controller;

architecture Behavioral of ov7670_controller is
	COMPONENT i3c2 GENERIC (
		clk_divide  : std_logic_vector(7 downto 0)
   );
	PORT(
		clk : IN std_logic;
		inst_data : IN std_logic_vector(8 downto 0);
		inputs : IN std_logic_vector(15 downto 0);    
		i2c_sda : INOUT std_logic;      
		inst_address : OUT std_logic_vector(9 downto 0);
		i2c_scl : OUT std_logic;
		outputs : OUT std_logic_vector(15 downto 0);
		reg_addr : OUT std_logic_vector(4 downto 0);
		reg_data : OUT std_logic_vector(7 downto 0);
		reg_write : OUT std_logic;
		error : OUT std_logic
		);
	END COMPONENT;

   signal inputs  : std_logic_vector(15 downto 0);
   signal outputs : std_logic_vector(15 downto 0);
   signal data    : std_logic_vector( 8 downto 0);
   signal address : std_logic_vector( 9 downto 0);
   signal sys_clk : std_logic := '0';
begin
   inputs(0) <= resend;
   config_finished <= outputs(0);
	
	Inst_i3c2: i3c2 GENERIC MAP(
      clk_divide => std_logic_vector(to_unsigned(125,8)) 
   ) PORT MAP(
		clk => clk,
		inst_address => address ,
		inst_data => data,
		i2c_scl => sioc,
		i2c_sda => siod,
		inputs => inputs,
		outputs => outputs,
		reg_addr => open,
		reg_data => open,
		reg_write => open,
		error => open
	);

	reset <= '1'; 						-- Normal mode
	pwdn  <= '0'; 						-- Power device up
	xclk  <= sys_clk;
	
	process(clk)
	begin
		if rising_edge(clk) then
			sys_clk <= not sys_clk;
         
         case address is
           when "0000000000" => data <= "011100100"; -- delay
           when "0000000001" => data <= "101000010"; -- 0x42
           when "0000000010" => data <= "100010010"; -- 0x12 COM7
           when "0000000011" => data <= "110000000"; -- reset all regs
           when "0000000100" => data <= "011111111"; -- send
           when "0000000101" => data <= "011101001"; -- delay long
           when "0000000110" => data <= "101000010"; -- 0x42
           when "0000000111" => data <= "100010010"; -- 0x12 COM7
           when "0000001000" => data <= "100000100"; -- set RGB XXXXXXXXXXXXXXXXXXXXXXXXXXXXx
           when "0000001001" => data <= "011111111"; -- send
           when "0000001010" => data <= "101000010"; -- 0x42
           when "0000001011" => data <= "100010001"; -- 0x11 CLKRC
           when "0000001100" => data <= "100000000"; -- 0x00 or 0x80 default
           when "0000001101" => data <= "011111111"; -- send
           when "0000001110" => data <= "101000010"; -- 0x42
           when "0000001111" => data <= "100001100"; -- 0x0C COM3
           when "0000010000" => data <= "100000000"; -- 0x00 default
           when "0000010001" => data <= "011111111"; -- send
           when "0000010010" => data <= "101000010"; -- 0x42
           when "0000010011" => data <= "100111110"; -- 0x3E COM14
           when "0000010100" => data <= "100000000"; -- 0x00 default
           when "0000010101" => data <= "011111111"; -- send
           when "0000010110" => data <= "101000010"; -- 0x42
           when "0000010111" => data <= "110001100"; -- 0x8C RGB444
           when "0000011000" => data <= "100000011"; -- enable RGBx
           when "0000011001" => data <= "011111111"; -- send
           when "0000011010" => data <= "101000010"; -- 0x42
           when "0000011011" => data <= "100000100"; -- 0x08 RAVE
           when "0000011100" => data <= "100000000"; -- 0x00 default
           when "0000011101" => data <= "011111111"; -- send
           when "0000011110" => data <= "101000010"; -- 0x42
           when "0000011111" => data <= "101000000"; -- 0x40 COM15
           when "0000100000" => data <= "111110000"; -- 
           when "0000100001" => data <= "011111111"; -- send
           when "0000100010" => data <= "101000010"; -- 0x42
           when "0000100011" => data <= "100111010"; -- 0x3A TSLB
           when "0000100100" => data <= "100000100"; -- 0x0D default, use reserved bit
           when "0000100101" => data <= "011111111"; -- send
           when "0000100110" => data <= "101000010"; -- 0x42
           when "0000100111" => data <= "100010100"; -- 0x14 COM9
           when "0000101000" => data <= "100111000"; -- 0x4A default
           when "0000101001" => data <= "011111111"; -- send
           when "0000101010" => data <= "101000010"; -- 0x42
           when "0000101011" => data <= "101001111"; -- 0x4F MTX1
           when "0000101100" => data <= "101000000"; -- 0x40 default
           when "0000101101" => data <= "011111111"; -- send
           when "0000101110" => data <= "101000010"; -- 0x42
           when "0000101111" => data <= "101010000"; -- 0x50 MTX2
           when "0000110000" => data <= "100110100"; -- 0x34 default
           when "0000110001" => data <= "011111111"; -- send
           when "0000110010" => data <= "101000010"; -- 0x42
           when "0000110011" => data <= "101010001"; -- 0x51 MTX3
           when "0000110100" => data <= "100001100"; -- 0x0C default
           when "0000110101" => data <= "011111111"; -- send
           when "0000110110" => data <= "101000010"; -- 0x42
           when "0000110111" => data <= "101010010"; -- 0x52 MTX4
           when "0000111000" => data <= "100010111"; -- 0x17 default
           when "0000111001" => data <= "011111111"; -- send
           when "0000111010" => data <= "101000010"; -- 0x42
           when "0000111011" => data <= "101010011"; -- 0x53 MTX5
           when "0000111100" => data <= "100101001"; -- 0x29 default
           when "0000111101" => data <= "011111111"; -- send
           when "0000111110" => data <= "101000010"; -- 0x42
           when "0000111111" => data <= "101010100"; -- 0x54 MTX6
           when "0001000000" => data <= "101000000"; -- 0x40 default
           when "0001000001" => data <= "011111111"; -- send
           when "0001000010" => data <= "101000010"; -- 0x42
           when "0001000011" => data <= "101011000"; -- 0x58 MTXS
           when "0001000100" => data <= "100011110"; -- 0x1E default
           when "0001000101" => data <= "011111111"; -- send
           when "0001000110" => data <= "101000010"; -- 0x42
           when "0001000111" => data <= "100111101"; -- 0x3D COM13
           when "0001001000" => data <= "111000000"; -- 0x88 default,gamma enable,UVSL-UV auto adjust
           when "0001001001" => data <= "011111111"; -- send
           when "0001001010" => data <= "101000010"; -- 0x42
           when "0001001011" => data <= "100010001"; -- 0x11 CLKRC
           when "0001001100" => data <= "100000000"; -- 0x00 or 0x80 default,not use reserved bits
           when "0001001101" => data <= "011111111"; -- send
           when "0001001110" => data <= "101000010"; -- 0x42
           when "0001001111" => data <= "100010111"; -- 0x17 HSTART
           when "0001010000" => data <= "100010001"; -- 0x11 default
           when "0001010001" => data <= "011111111"; -- send
           when "0001010010" => data <= "101000010"; -- 0x42
           when "0001010011" => data <= "100011000"; -- 0x18 HSTOP
           when "0001010100" => data <= "101100001"; -- 0x61 default
           when "0001010101" => data <= "011111111"; -- send
           when "0001010110" => data <= "101000010"; -- 0x42
           when "0001010111" => data <= "100110010"; -- 0x32 HREF
           when "0001011000" => data <= "110100100"; -- 0x80 default,HREF start/end low 3 LSB
           when "0001011001" => data <= "011111111"; -- send
           when "0001011010" => data <= "101000010"; -- 0x42
           when "0001011011" => data <= "100011001"; -- 0x19 VSTRT
           when "0001011100" => data <= "100000011"; -- 0x03 default
           when "0001011101" => data <= "011111111"; -- send
           when "0001011110" => data <= "101000010"; -- 0x42
           when "0001011111" => data <= "100011010"; -- 0x1A VSTOP
           when "0001100000" => data <= "101111011"; -- 0x7B default
           when "0001100001" => data <= "011111111"; -- send
           when "0001100010" => data <= "101000010"; -- 0x42
           when "0001100011" => data <= "100000011"; -- 0x03 VREF
           when "0001100100" => data <= "100001010"; -- 0x00 default,VREF start/end low 2 bit
           when "0001100101" => data <= "011111111"; -- send
           when "0001100110" => data <= "101000010"; -- 0x42
           when "0001100111" => data <= "100001110"; -- 0x07 AECHH
           when "0001101000" => data <= "101100001"; -- 0x00 default,?
           when "0001101001" => data <= "011111111"; -- send
           when "0001101010" => data <= "101000010"; -- 0x42
           when "0001101011" => data <= "100001111"; -- 0x0F COM6
           when "0001101100" => data <= "101001011"; -- 0x43 default,use 0x4B
           when "0001101101" => data <= "011111111"; -- send
           when "0001101110" => data <= "101000010"; -- 0x42
           when "0001101111" => data <= "100010110"; -- 0x16 RSVD
           when "0001110000" => data <= "100000010"; -- 0xXX default
           when "0001110001" => data <= "011111111"; -- send
           when "0001110010" => data <= "101000010"; -- 0x42
           when "0001110011" => data <= "100011110"; -- 0x1E MVFP
           when "0001110100" => data <= "100000101"; -- 0x01 default,mirror/vflip image,black sun enable
           when "0001110101" => data <= "011111111"; -- send
           when "0001110110" => data <= "101000010"; -- 0x42
           when "0001110111" => data <= "100100001"; -- 0x21 ADCCTR1
           when "0001111000" => data <= "100000010"; -- 0x02 default
           when "0001111001" => data <= "011111111"; -- send
           when "0001111010" => data <= "101000010"; -- 0x42
           when "0001111011" => data <= "100100010"; -- 0x22 ADCCTR2
           when "0001111100" => data <= "110010001"; -- 0x01 default,?
           when "0001111101" => data <= "011111111"; -- send
           when "0001111110" => data <= "101000010"; -- 0x42
           when "0001111111" => data <= "100101001"; -- 0x29 RSVD
           when "0010000000" => data <= "100000111"; -- 0xXX default,?
           when "0010000001" => data <= "011111111"; -- send
           when "0010000010" => data <= "101000010"; -- 0x42
           when "0010000011" => data <= "100110011"; -- 0x33 CHLF
           when "0010000100" => data <= "100001011"; -- 0x08 default,?
           when "0010000101" => data <= "011111111"; -- send
           when "0010000110" => data <= "101000010"; -- 0x42
           when "0010000111" => data <= "100110101"; -- 0x35 RSVD
           when "0010001000" => data <= "100001011"; -- 0xXX default,?
           when "0010001001" => data <= "011111111"; -- send
           when "0010001010" => data <= "101000010"; -- 0x42
           when "0010001011" => data <= "100110111"; -- 0x37 ADC
           when "0010001100" => data <= "100011101"; -- 0x3F default,?
           when "0010001101" => data <= "011111111"; -- send
           when "0010001110" => data <= "101000010"; -- 0x42
           when "0010001111" => data <= "100111000"; -- 0x38 ACOM
           when "0010010000" => data <= "101110001"; -- 0x01 default,?
           when "0010010001" => data <= "011111111"; -- send
           when "0010010010" => data <= "101000010"; -- 0x42
           when "0010010011" => data <= "100111001"; -- 0x39 OFON
           when "0010010100" => data <= "100101010"; -- 0x00 default,?
           when "0010010101" => data <= "011111111"; -- send
           when "0010010110" => data <= "101000010"; -- 0x42
           when "0010010111" => data <= "100111100"; -- 0x3C COM12
           when "0010011000" => data <= "101111000"; -- 0x68 default,?
           when "0010011001" => data <= "011111111"; -- send
           when "0010011010" => data <= "101000010"; -- 0x42
           when "0010011011" => data <= "101001101"; -- 0x4D RSVD
           when "0010011100" => data <= "101000000"; -- 0xXX default,?
           when "0010011101" => data <= "011111111"; -- send
           when "0010011110" => data <= "101000010"; -- 0x42
           when "0010011111" => data <= "101001110"; -- 0x4E RSVD
           when "0010100000" => data <= "100100000"; -- 0xXX default,?
           when "0010100001" => data <= "011111111"; -- send
           when "0010100010" => data <= "101000010"; -- 0x42
           when "0010100011" => data <= "101101001"; -- 0x69 GFIX
           when "0010100100" => data <= "100000000"; -- 0x00 default
           when "0010100101" => data <= "011111111"; -- send
           when "0010100110" => data <= "101000010"; -- 0x42
           when "0010100111" => data <= "101101011"; -- 0x6B DBLV PLL CONTROL
           when "0010101000" => data <= "101001010"; -- 0x0A default,input clock 4x
           when "0010101001" => data <= "011111111"; -- send
           when "0010101010" => data <= "101000010"; -- 0x42
           when "0010101011" => data <= "101110100"; -- 0x74 REG74
           when "0010101100" => data <= "100010000"; -- 0x00 default,digital gain control REG74/bypass
           when "0010101101" => data <= "011111111"; -- send
           when "0010101110" => data <= "101000010"; -- 0x42
           when "0010101111" => data <= "110001101"; -- 0x8D RSVD
           when "0010110000" => data <= "101001111"; -- 0xXX default,?
           when "0010110001" => data <= "011111111"; -- send
           when "0010110010" => data <= "101000010"; -- 0x42
           when "0010110011" => data <= "110001110"; -- 0x8E RSVD
           when "0010110100" => data <= "100000000"; -- 0xXX default,?
           when "0010110101" => data <= "011111111"; -- send
           when "0010110110" => data <= "101000010"; -- 0x42
           when "0010110111" => data <= "110001111"; -- 0x8F RSVD
           when "0010111000" => data <= "100000000"; -- 0xXX default,?
           when "0010111001" => data <= "011111111"; -- send
           when "0010111010" => data <= "101000010"; -- 0x42
           when "0010111011" => data <= "110010000"; -- 0x90 RSVD
           when "0010111100" => data <= "100000000"; -- 0xXX default,?
           when "0010111101" => data <= "011111111"; -- send
           when "0010111110" => data <= "101000010"; -- 0x42
           when "0010111111" => data <= "110010001"; -- 0x91 RSVD
           when "0011000000" => data <= "100000000"; -- 0xXX default,?
           when "0011000001" => data <= "011111111"; -- send
           when "0011000010" => data <= "101000010"; -- 0x42
           when "0011000011" => data <= "110010110"; -- 0x96 RSVD
           when "0011000100" => data <= "100000000"; -- 0xXX default,?
           when "0011000101" => data <= "011111111"; -- send
           when "0011000110" => data <= "101000010"; -- 0x42
           when "0011000111" => data <= "110011010"; -- 0x9A RSVD
           when "0011001000" => data <= "100000000"; -- 0xXX default,?
           when "0011001001" => data <= "011111111"; -- send
           when "0011001010" => data <= "101000010"; -- 0x42
           when "0011001011" => data <= "110110000"; -- 0xB0 RSVD
           when "0011001100" => data <= "110000100"; -- 0xXX default,?
           when "0011001101" => data <= "011111111"; -- send
           when "0011001110" => data <= "101000010"; -- 0x42
           when "0011001111" => data <= "110110001"; -- 0xB1 ABLC1
           when "0011010000" => data <= "100001100"; -- 0x00 default,enable ABLC func
           when "0011010001" => data <= "011111111"; -- send
           when "0011010010" => data <= "101000010"; -- 0x42
           when "0011010011" => data <= "110110010"; -- 0xB2 RSVD
           when "0011010100" => data <= "100001110"; -- 0xXX default,?
           when "0011010101" => data <= "011111111"; -- send
           when "0011010110" => data <= "101000010"; -- 0x42
           when "0011010111" => data <= "110110011"; -- 0xB3 THL_ST
           when "0011011000" => data <= "110000010"; -- 0x80 default,?
           when "0011011001" => data <= "011111111"; -- send
           when "0011011010" => data <= "101000010"; -- 0x42
           when "0011011011" => data <= "110111000"; -- 0xB8 RSVD
           when "0011011100" => data <= "100001010"; -- 0xXX default,?
           when "0011011101" => data <= "011111111"; -- send
					 
--					 when "0011011110" => data <= "101000010"; -- 0x42
--           when "0011011111" => data <= "110111000"; -- 0xB8 RSVD
--           when "0011100000" => data <= "100000000"; -- 0xXX default,?
--           when "0011100001" => data <= "011111111"; -- send
--					 
--					 when "0011100010" => data <= "101000010"; -- 0x42
--           when "0011100011" => data <= "110111000"; -- 0xB8 RSVD
--           when "0011100100" => data <= "100000000"; -- 0xXX default,?
--           when "0011100101" => data <= "011111111"; -- send
					 
--           when "0011100110" => data <= "011111110"; -- user defined
--           when "0011100111" => data <= "011111110"; -- user defined
--           when "0011101000" => data <= "010000000"; -- SKIPCLEAR n | Skip if input n clear
--           when "0011101001" => data <= "000000000"; -- JUMP m      | Set PC to m (n = m/8),0
--           when "0011101010" => data <= "000011100"; -- JUMP m      | Set PC to m (n = m/8),28,m=n*8,m=28*8=224

           when "0011011110" => data <= "011111110"; -- user defined
           when "0011011111" => data <= "011111110"; -- user defined
           when "0011100000" => data <= "010000000"; -- SKIPCLEAR n | Skip if input n clear
           when "0011100001" => data <= "000000000"; -- JUMP m      | Set PC to m (n = m/8),0
           when "0011100010" => data <= "000011100"; -- JUMP m      | Set PC to m (n = m/8),28,m=n*8,m=28*8=224

           when others => data <= (others =>'0'); -- all list have 226 instructions,XXX TODO
        end case;
		end if;
	end process;
end Behavioral;
