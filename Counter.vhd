--Lab4
--Group Number: 9
--Group Members: Daniel Croos and Stephanie De Pol

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity u_d_bin_counter8bit is port 
	(
			clk 							: in std_logic :='0';
			reset_n 						: in std_logic :='0';
			clk_en						: in std_logic :='0';
			up1_down0 					: in std_logic :='0';
			counter_bits				: out std_logic_vector(7 downto 0)
	);
	end Entity;
	
	Architecture one of  u_d_bin_counter8bit is 
	
	-- This signal will be modified in the process and then assigned to counter_bits after the process
	signal ud_bin_counter: unsigned(7 downto 0);

Begin 

process (clk, reset_n) is
begin 

	if (reset_n = '0') then 
			ud_bin_counter <= "00000000";
				
	elsif (rising_edge(clk)) then 
	
			if ((up1_down0 = '1') and (clk_en = '1')) then	-- True when counter needs to be increased	
			
					ud_bin_counter <= (ud_bin_counter + 1);

			elsif ((up1_down0 = '0') and (clk_en = '1')) then -- True when counter needs to be decreased
			
					ud_bin_counter <= (ud_bin_counter - 1);
					
			end if;
			
	end if;
	
end process;

-- ud_bin_counter is assigned its value after the process has ended and hence now it can be assigned to counter_bits
counter_bits <= std_logic_vector(ud_bin_counter);

end;