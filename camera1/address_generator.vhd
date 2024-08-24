----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Address_Generator is
    Port ( 	CLK25,enable : in  STD_LOGIC;								-- horloge de 25 MHz et signal d'activation respectivement
            rez_160x120  : IN std_logic;
            rez_320x240  : IN std_logic;
            vsync        : in  STD_LOGIC;
			address 		 : out STD_LOGIC_VECTOR (14 downto 0));	-- adresse généré
end Address_Generator;

architecture Behavioral of Address_Generator is
   signal val: STD_LOGIC_VECTOR(address'range):= (others => '0');		-- signal intermidiaire
	 constant RES1 : integer := 160*120;
	 constant RES2 : integer := 320*240;
	 constant RES3 : integer := 640*480;
begin
	address <= val;																		-- adresse généré

	process(CLK25,val,enable)
		begin
         if rising_edge(CLK25) then
--            if (enable='1') then													-- si enable = 0 on arrete la génération d'adresses
               if rez_160x120 = '1' then
								if (enable='1') then
                  if (to_integer(unsigned(val)) < RES1) then										-- si l'espace mémoire est balayé complétement				
                     val <= std_logic_vector(to_unsigned(to_integer(unsigned(val))+1,address'left+1));
                  end if;
								end if;
               elsif rez_320x240 = '1' then
								if (enable='1') then
                  if (to_integer(unsigned(val)) < RES2) then										-- si l'espace mémoire est balayé complétement				
                     val <= std_logic_vector(to_unsigned(to_integer(unsigned(val))+1,address'left+1));
                  end if;
								end if;
               else
								if (enable='1') then
                  if (to_integer(unsigned(val)) < RES3) then										-- si l'espace mémoire est balayé complétement				
                     val <= std_logic_vector(to_unsigned(to_integer(unsigned(val))+1,address'left+1));
                  end if;
								end if;
               end if;
--				end if;
            if vsync = '0' then 
               val <= (others => '0');
            end if;
			end if;	
		end process;
end Behavioral;
