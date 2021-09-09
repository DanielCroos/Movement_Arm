--Lab4
--Group Number: 9
--Group Members: Daniel Croos and Stephanie De Pol

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is the "claw" of the robotic arm which will active when the toggle is pressed and it is fully extended

Entity grappler IS Port
(
	rst_n							: IN std_logic := '0';	
	grap_toggle, grap_en		: IN std_logic := '0';
	grap_out						: OUT std_logic:= '0'
 );
END ENTITY;
 
 Architecture logic of grappler is
 
 -- Addtional component used by the grappler-----------------------------------------
	component toggler port (
		reset, button, enable		: IN std_logic ;
		output							: OUT std_logic
		);
	end component; 
 
 BEGIN
 
 -- The instance below activates the grappler when it is fully extended and at the falling edge of the toggle
 -- This instance allows resets the state to 0 when reset becomes '0'
 inst0: toggler port map (rst_n,grap_toggle,grap_en);
 
END logic;