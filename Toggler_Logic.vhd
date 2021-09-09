--Lab4
--Group Number: 9
--Group Members: Daniel Croos and Stephanie De Pol

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is an implentation of a modified T Flip Flop which allows to have a clear in active low 
-- The purpose of this component is to switch the value of the output at the falling edge of when the button is pushed
-- However this takes into consideration if it is able by ensuring enable is also on otherwise it keeps its current output 
Entity toggler IS Port
(
	reset, button, enable		: IN std_logic;
	output							: OUT std_logic
 );
END ENTITY;

Architecture toggler_logic of toggler is

signal current_output : std_logic := '0';

Begin

process (button, enable, reset) is

begin 

	if (reset = '0') then  -- this ensures that when reset is 0 the output of the component becomes 0
		current_output <= '0';
	
	elsif (falling_edge(button) AND (enable = '1')) then -- This ensures the conditions stated above are met to change
		current_output <= NOT current_output;

	end if;
	
end process;

--Value is assigned outside of process
output <= current_output;

End toggler_logic;