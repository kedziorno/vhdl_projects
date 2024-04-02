----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:21:26 04/23/2021 
-- Design Name: 
-- Module Name:    neural_net - Behavioral 
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

ENTITY neural_net IS
PORT (clk, rst: IN STD_LOGIC;
	x: IN SIGNED(N-1 DOWNTO 0);
	y: OUT short_array
);
END neural_net;

ARCHITECTURE neural_net OF neural_net IS
	SIGNAL prod, acc1, acc2: long_array;
	SIGNAL sigmoid: short_array;
	SIGNAL counter: INTEGER RANGE 1 TO weights+1;
BEGIN
	P0: PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk='1') THEN
			IF (rst='1') THEN
				counter <= 1;
			ELSE
				counter <= counter + 1;
			END IF;
		END IF;
	END PROCESS P0;
	P1 : PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk='1') THEN
			IF (rst='1') THEN
				FOR i IN 1 TO neurons LOOP
					y(i) <= sigmoid(i);
					acc2(i) <= (OTHERS=>'0');
				END LOOP;
			ELSE
				FOR i IN 1 TO neurons LOOP
					acc2(i) <= acc1(i);
				END LOOP;
			END IF;
		END IF;
	END PROCESS P1;
	P2 : PROCESS(x, counter)
	BEGIN
		FOR i IN 1 TO neurons LOOP
			prod(i) <= x * TO_SIGNED(weight(i, counter), N);
			acc1(i) <= prod(i) + acc2(i);
			IF ((acc2(i)(2*N-1)=prod(i)(2*N-1)) AND (acc1(i)(2*N-1)/=acc2(i)(2*N-1))) THEN
				acc1(i) <= ((2*N-1)=>acc2(i)(2*N-1),OTHERS=>NOT acc2(i)(2*N-1));
			END IF;
			sigmoid(i) <= conv_sigmoid(acc2(i));
		END LOOP;
	END PROCESS P2;
END neural_net;
