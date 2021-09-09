--Lab4
--Group Number: 9
--Group Members: Daniel Croos and Stephanie De Pol

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This is the modified version of the given binary counter for 4 bits since the RAC deals with position in 4 bits
-- The purpose of this is to ensure that the RAC knows its updated location as it travels to its x,y target

Entity bin_counter4bit is port 
	(										 
			clk 							: in std_logic :='0';
			reset_n 						: in std_logic :='0';
			clk_en						: in std_logic :='0';
			up1_down0 					: in std_logic :='0';
			counter_bits				: out std_logic_vector(3 downto 0)
	);										 
	end Entity;
	
	Architecture one of bin_counter4bit is 
	
	-- This signal will be modified in the process and then assigned to counter_bits after the process
	signal counter: unsigned(3 downto 0);

Begin 

process (clk, reset_n) is
begin 

	if (reset_n = '0') then 
			counter <= "0000";
				
	elsif (rising_edge(clk)) then 
	
			if ((up1_down0 = '1') and (clk_en = '1')) then	-- True when counter needs to be increased	
			
					counter <= (counter + 1);

			elsif ((up1_down0 = '0') and (clk_en = '1')) then -- True when counter needs to be decreased
			
					counter <= (counter - 1);
					
			end if;
			
	end if;
	
end process;

-- counter is assigned its value after the process has ended and hence now it can be assigned to counter_bits
counter_bits <= std_logic_vector(counter);

end;