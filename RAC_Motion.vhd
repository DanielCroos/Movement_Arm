--Lab4
--Group Number: 9
--Group Members: Daniel Croos and Stephanie De Pol

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This component moves the RAC towards the target x and y when it is allowed to
-- Furthermore it indicates when the extender can move and will through an error when
-- when forced to move with the extender out
--Additionally it takes into account the toggles and reset signals and behaves accordingly 

Entity movement_arm IS Port
(
	clk, rst_n								: IN std_logic  := '0'; 
	toggle,extender_out					: IN std_logic	 := '0';
	target_x,target_y						: IN std_logic_vector(3 downto 0);
	error_led								: OUT std_logic := '0';
	current_x,current_y					: OUT std_logic_vector(3 downto 0);
	extender_en								: OUT std_logic := '0' -- follows active low 
 );
END ENTITY;
 
 Architecture logic of movement_arm is
 
 -- This component will allow for the comparison of the target position and current
 component compx4 port (
		Input_A, Input_B		   			: in	std_logic_vector(3 downto 0);
		AGTB,AEQB,ALTB							: out std_logic
	); 
	end component;
 
 -- This component is able to update current location and syncs it up with the clk signal
 component bin_counter4bit port (
			clk 							: in std_logic :='0';
			reset_n 						: in std_logic :='0';
			clk_en						: in std_logic :='0';
			up1_down0 					: in std_logic :='0';
			counter_bits				: out std_logic_vector(3 downto 0)
	); 
	end component; 

	-- This signal will hold the location values of its current target
	SIGNAL temp_target_x, temp_target_y 									: std_logic_vector(3 downto 0);
	
	--	These signals will stores the output of the comparison between the current position and 
	-- the target position
	SIGNAL C_GT_TX, C_GT_TY, C_EQ_TX, C_EQ_TY, C_LT_TX, C_LT_TY 	: std_logic := '0';
	
	-- These will monitor the net change relative to the 0000 at any given time 
	signal net_x_change, net_y_change										: std_logic_vector(3 downto 0);
	
	-- These will determine if the arm is able to move and whether to move "up" or "down" 
	signal add_en_x, add_en_y, add1_sub0_x, add1_sub0_y				: std_logic := '0' ; 
	
 BEGIN
 
 -- These instances will move the movement_arm toward the target location based on the logic of add_en
 -- and add1_sub0 for each direction
 x_move: bin_counter4bit port map (clk,rst_n,add_en_x,add1_sub0_x,net_x_change);
 y_move: bin_counter4bit port map (clk,rst_n,add_en_y,add1_sub0_y,net_y_change);
 
 -- These instances will compare the current location to the target and will indicate which direction it must
 -- move or if it has reached it
 X_compare: compx4 port map (net_x_change, temp_target_x, C_GT_TX, C_EQ_TX,C_LT_TX);
 y_compare: compx4 port map (net_y_change, temp_target_y, C_GT_TY, C_EQ_TY, C_LT_TY);
 
 -- This indicates whether it needs to move "up" to target location or down
 -- Since LT signal is used later we need to ensure if it has reached the location or if it passed the target
 add1_sub0_x <= C_LT_TX;
 add1_sub0_y <= C_LT_TY;
 
 -- This indicates its current location and will be updated accordingly
 current_x <= net_x_change;
 current_y <= net_y_change;
 
 process (rst_n, toggle, extender_out, C_EQ_TX, C_EQ_TY) is 
 
 begin
 
	-- The first condition is check if reset is on (active low) and update location and reset all signals
	if (rst_n = '0') then  
		temp_target_x <= "0000";
		temp_target_y <= "0000";
		extender_en <= '0';
		error_led <= '0';
		
	else
		
		--This ensures whether the button is pushed when it is extended and will throw an error if true
		if (extender_out = '0') then
			error_led <= '0';
		elsif ((extender_out = '1') AND (Falling_edge (toggle))) then
			error_led<= '1';
			
		end if;
		
		-- This ensures that when the button is pushed all conditions are met before it updates its target and starts
		-- moving towards the new target otherwise target is not updated 
		if (rising_edge(toggle) AND (extender_out ='0') AND (C_EQ_TX = '1') AND (C_EQ_TY ='1')) then
			temp_target_x <= target_x;
			temp_target_y <= target_y;
		
		end if;
	
		-- Since before we used the Less Than signal is used these statements ensures that it will only move when
		-- it is treactly when it hasn't reached its target, which is done first for x then y using the same logic
		if (C_EQ_TX ='1') then 
			add_en_x <= '0';
		elsif ((extender_out = '0') AND (C_EQ_TX ='0') AND (falling_edge(toggle))) then
			add_en_x<= '1';
		end if;
		
		if (C_EQ_TY ='1') then 
			add_en_y <= '0';
		elsif ((extender_out = '0') AND (C_EQ_TY ='0') AND (falling_edge(toggle))) then
			add_en_y<= '1';
		end if;
	
	
	-- This logic just ensures that extender can not start moving before the movement arm reaches its target
	-- (i.e this is when it would be moving) or it is already extended 
		if (((C_EQ_TX = '1') AND (C_EQ_TX = '1')) OR (extender_out = '1')) then
			extender_en <= '0'; -- Since this follows active low it is '0'
		else 
			extender_en <= '1';
		
		end if;
	
	end if;
 
 end process;
 
 END logic;