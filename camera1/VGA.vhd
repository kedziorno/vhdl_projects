library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity RGB is
    Port ( Din 	: in	STD_LOGIC_VECTOR (7 downto 0);			-- niveau de gris du pixels sur 8 bits
			  Nblank : in	STD_LOGIC;										-- signal indique les zone d'affichage, hors la zone d'affichage
																					-- les trois couleurs prendre 0
           R 	: out	STD_LOGIC_VECTOR (3 downto 1);
           G 	: out	STD_LOGIC_VECTOR (3 downto 1);
           B 	: out	STD_LOGIC_VECTOR (3 downto 2)
					 );
end RGB;

architecture Behavioral of RGB is

begin
		R <= Din(7 downto 5) when Nblank='1' else "000";
		G <= Din(4 downto 2)  when Nblank='1' else "000";
		B <= Din(1 downto 0)  when Nblank='1' else "00";

end Behavioral;
