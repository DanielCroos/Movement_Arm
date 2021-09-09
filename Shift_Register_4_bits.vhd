--Lab4
--Group Number: 9
--Group Members: Daniel Croos and Stephanie De Pol

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
-- This is the modified version of the given binary register for 4 bits since the RAC deals with position in 4 bits
-- The purpose of this component is to output to the correct extender state to the leds

Entity bidir_shift_reg_4_bit is port 
	(
			clk 							: in std_logic :='0';
			reset_n 						: in std_logic :='0';
			clk_en						: in std_logic :='0';
			left0_right1 				: in std_logic :='0';
			reg_bits						: out std_logic_vector(3 downto 0)
	);
	end Entity;
	
	ARCHITECTURE one OF bidir_shift_reg_4_bit IS
	
	--This signal will be assigned the calculated value of reg_bits at the end of the process
	signal sreg 						: std_logic_vector(3 downto 0);
	
BEGIN

process (clk, reset_n) is
begin 

	if (reset_n = '0') then 
			sreg <= "0000";
				
	elsif (rising_edge(clk) and (clk_en = '1')) then 
			if (left0_right1 = '1') then						-- True for right shifts
			
				sreg(3 downto 0) <= '1' & sreg(3 downto 1); -- right shifts of bits 

			elsif (left0_right1 = '0') then 					-- True for left shifts
			
				sreg(3 downto 0) <= sreg (2 downto 0) & '0';  -- left shifting of bits
			
			end if;
			
	end if;
	
end process;

-- sreg is assigned its value after the process has ended and hence now it can be assigned to reg_bits
reg_bits <= sreg;

END one;

		