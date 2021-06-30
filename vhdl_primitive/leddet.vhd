----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:03:28 05/09/2021 
-- Design Name: 
-- Module Name:    leddet - Behavioral 
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

-- XXX detect first RE
Entity LEDDET Is
Port( Clock : In Std_Ulogic;
Reset : In Std_Ulogic;
Trigger: In Std_Ulogic;
LED : Out Std_Ulogic);
End LEDDET;
Architecture RTL of LEDDET is
Type Seq_state is (S0, S1);
Signal State: Seq_state;
Begin
LED_EX:Process(Clock, Reset)
Begin
If Reset='1' then
LED<='0';
State<=s0;
Elsif Rising_Edge(Clock) then
Case State is -- w jakim jestem stanie?
When S0=>
If Trigger='1' then
LED<='1' after 5ns;
State<=s1;
End If;
When S1=>
LED<='0' AFTER 5ns;
If Trigger='0' then
State<=s0;
End If;
End Case;
End If;
End Process LED_EX;
End RTL;


