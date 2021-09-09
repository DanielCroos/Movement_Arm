--Lab4
--Group Number: 9
--Group Members: Daniel Croos and Stephanie De Pol

library ieee;
use ieee.std_logic_1164.all;

entity compx1 is

	port
	(
		a_bit, b_bit		   				: in std_logic;
		outgreater,outequal,outless		: out std_logic
	);

end entity;


architecture compare of compx1 is

begin

-- An xor gate will ensure each bit is different while "AND a_bit" ensures this statement is true only when that a_bit is 1 and b_bit is 0
outgreater <= (a_bit XOR b_bit) And a_bit;

-- An xnor gate will be true when both signals are the same (i.e when they're equal)
outequal <= (a_bit XNOR b_bit);

-- An xor gate will ensure each bit is different while "AND b_bit" ensures this statment is true only when that b_bit is 1 and a_bit is 0 
outless <= (a_bit XOR b_bit) And b_bit;

end compare;