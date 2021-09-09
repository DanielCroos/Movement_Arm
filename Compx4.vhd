--Lab4
--Group Number: 9
--Group Members: Daniel Croos and Stephanie De Pol

library ieee;
use ieee.std_logic_1164.all;

entity compx4 is

	port
	(
		Input_A,Input_B		   : in	std_logic_vector(3 downto 0);
		AGTB,AEQB,ALTB				: out std_logic
	);

end entity;


architecture compare of compx4 is

	component compx1 port (
		a_bit, b_bit		   			: in std_logic;
		outgreater,outequal,outless	: out std_logic
	); 
	end component;

	
-- These signals exist to store the output of comparing each individual signal of Input_A and Input_B
	signal AGTBperbit, AEQBperbit, ALTBperbit		: std_logic_vector(3 downto 0);
	
begin

-- These 4 instances compare each bit of Input_A and Input_B using compx1
inst1: compx1 port map (
								Input_A(0),Input_B(0),
								AGTBperbit(0),AEQBperbit(0),ALTBperbit(0)
								); 
inst2: compx1 port map (
								Input_A(1),Input_B(1),
								AGTBperbit(1),AEQBperbit(1),ALTBperbit(1)
								); 
inst3: compx1 port map (
								Input_A(2),Input_B(2),
								AGTBperbit(2),AEQBperbit(2),ALTBperbit(2)
								); 
inst4: compx1 port map (
								Input_A(3),Input_B(3),
								AGTBperbit(3),AEQBperbit(3),ALTBperbit(3)
								); 

-- This statment will be true if the Input A's bit is greater than Input B's bit while all preceding bit is equal starting from the msb 
AGTB <= AGTBperbit(3) OR 
		(AEQBperbit(3) AND AGTBperbit(2)) OR 
		(AEQBperbit(3) And AEQBperbit(2) AND AGTBperbit(1)) OR 
		(AEQBperbit(3) And AEQBperbit(2) AND AEQBperbit(1) AND AGTBperbit(0));

-- Input A and Input B are equal only if each of their signal/bit are the same 
AEQB <= AEQBperbit(3) And AEQBperbit(2) And AEQBperbit(1) And AEQBperbit(0);

-- This statment will be true if the Input B's bit is greater than Input A's bit while all preceding bit is equal starting from the msb
ALTB <= ALTBperbit(3) OR 
		(AEQBperbit(3) AND ALTBperbit(2)) OR 
		(AEQBperbit(3) And AEQBperbit(2) AND ALTBperbit(1)) OR 
		(AEQBperbit(3) And AEQBperbit(2) AND AEQBperbit(1) AND ALTBperbit(0));

end compare;