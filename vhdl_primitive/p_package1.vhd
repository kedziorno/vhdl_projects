library IEEE;
use IEEE.STD_LOGIC_1164.all;

package p_package1 is
	function shift_integer (signal a,b : integer) return integer;
	type matrix is array (natural range <>,natural range <>) of bit;
	constant bits : positive := 8;
	type x_input is array (natural range <>) of bit_vector(bits-1 downto 0);
	CONSTANT neurons: INTEGER := 3;
	CONSTANT weights: INTEGER := 5;
	CONSTANT N: INTEGER := 6;
	TYPE short_array IS ARRAY (1 TO neurons) OF SIGNED(N-1 DOWNTO 0);
	TYPE long_array IS ARRAY (1 TO neurons) OF SIGNED(2*N-1 DOWNTO 0);
	TYPE weight_array IS ARRAY (1 TO neurons, 1 TO weights) OF
	INTEGER RANGE -(2**(N-1)) TO 2**(N-1)-1;
	CONSTANT weight: weight_array := ((1, 4, 5, 5, -5),(5, 20, 25, 25, -25),(-30, -30, -30, -30, -30));
	FUNCTION conv_sigmoid (SIGNAL input: SIGNED) RETURN SIGNED;
end p_package1;

package body p_package1 is
	function shift_integer (signal a,b : integer) return integer is
	begin
		return a*(2**b);
	end function shift_integer;
	FUNCTION conv_sigmoid (SIGNAL input: SIGNED) RETURN SIGNED IS
		VARIABLE a: INTEGER RANGE 0 TO 4**N-1;
		VARIABLE b: INTEGER RANGE 0 TO 2**N-1;
	BEGIN
		a := TO_INTEGER(ABS(input));
		IF (a=0) THEN b:=0;
		ELSIF (a>0 AND a<97) THEN b:=2;
		ELSIF (a>=97 AND a<198) THEN b:=6;
		ELSIF (a>=198 AND a<305) THEN b:=10;
		ELSIF (a>=305 AND a<425) THEN b:=14;
		ELSIF (a>=425 AND a<567) THEN b:=18;
		ELSIF (a>=567 AND a<753) THEN b:=22;
		ELSIF (a>=753 AND a<1047) THEN b:=26;
		ELSE b:=30;
		END IF;
		IF (input(2*N-1)='0') THEN
			RETURN TO_SIGNED(b, N);
		ELSE
			RETURN TO_SIGNED(-b, N);
		END IF;
	END conv_sigmoid;
end p_package1;
