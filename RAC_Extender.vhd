--Lab4
--Group Number: 9
--Group Members: Daniel Croos and Stephanie De Pol

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is the vertical "mover" of the RAC 
-- The purpose of this component is to ensure the RAC moves to its target when RAC is not along x and y
-- Furthermore it must indicate its state so that the grappler knows when it can activate
--Additionally it takes into account the toggles and reset signals and behaves accordingly 

Entity extender IS Port
(
	clk,rst_n								: IN std_logic := '0';	
	extender_toggle, extender_en		: IN std_logic := '0'; -- extender_en follows active low
	position									: OUT std_logic_vector(3 downto 0);
	extender_out,grap_en					: OUT std_logic := '0'
	
 );
END ENTITY;
 
 Architecture state_machine of extender is
 
 -- component used by the extender to output its state to the leds and update location
 component bidir_shift_reg_4_bit port (
			clk 							: in std_logic :='0';
			reset_n 						: in std_logic :='0';
			clk_en						: in std_logic :='0';
			left0_right1 				: in std_logic :='0';
			reg_bits						: out std_logic_vector(3 downto 0)
	); 
	end component; 
 
 -- component used by the extender to ensure it moves only when it met all conditions 
 -- which safely allow movement
 component toggler port (
		reset, button, enable		: IN std_logic;
		output							: OUT std_logic
		);
	end component;
 
 --Extender is the state machine hence it has 4 states which it can be at any given time
	TYPE STATE_NAMES IS (closed, extending, opened, retracting);

-- This ensures the intial state is closed and stays closed till it needs to be updated
 SIGNAL current_state, next_state	:  STATE_NAMES := closed;  

 -- Signals used which will be output to leds and used by the state machine
 SIGNAL moving, retract0_extend1 	: std_logic;
 SIGNAL c_state 							: std_logic_vector (3 downto 0);
 
 BEGIN
 
 inst1: bidir_shift_reg_4_bit port map(clk, rst_n, moving, retract0_extend1, c_state);
 
 inst2: toggler port map(rst_n, extender_toggle, ((NOT moving) AND (NOT extender_en)), retract0_extend1);
 
 position <= c_State;
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (clk, rst_n)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= closed;
	ELSIF(rising_edge(clk)) THEN
		current_state <= next_state;
	END IF;
END PROCESS;	

-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (current_state, retract0_extend1, c_state) 

BEGIN
     CASE current_state IS
         WHEN closed =>	
			
			-- When closed it will either stay closed or start extending based on retract0_extend1 
			--	which takes into account rst_n, toggles and enables
				if (retract0_extend1 = '1') then 
				next_state <= extending;
				else 
				next_state <= current_state;
				END IF;
				
         WHEN extending =>	
			
			-- when extending it will either continue extending or become opened based on its previous "extension"
			-- If max extension is reached then it will change state otherwise it will continue
				if (c_state = "1111") then
				next_state <= opened;
				else 
				next_state <= current_state;
				END IF;
				
         WHEN opened =>	
			
			-- When opened it will either stay open or start retracting based on retract0_extend1 
			--	which takes into account rst_n, toggles and enables
				if (retract0_extend1 = '0') then 
				next_state <= retracting;
				else 
				next_state <= current_state; 
				END IF;
				
         WHEN others => -- This can only be when current_state is retracting
			
			-- when retracting it will either continue retracting or become closed based on its previous "extension"
			-- If max retraction is reached then it will change state otherwise it will continue
				if (c_state = "0000") then
				next_state <= closed;
				else 
				next_state <= current_state;
				END IF;
				
 	END CASE;

 END PROCESS;

-- DECODER SECTION PROCESS (Moore Form) 
-- Moore form is used since it only depends on current_state and does take in more inputs

Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
         WHEN closed =>
			--When closed  RAC can move but the extender itself is not moving currently
			-- Grappler can't be used now since it is not extended
				extender_out <= '0';
				grap_en <= '0';
				moving <= '0';	

         WHEN opened =>
			--When opened, RAC can't move but the extender itself is not moving anymore
			-- Grappler can now be used
				extender_out <= '1';
				grap_en <= '1';
				moving <= '0';
			
         WHEN others =>
			-- Whether it is retracting or extending it is moving and would still not allow the RAC to move 
			-- Since it is not fully extended grappler can not work
				extender_out <= '1';
				grap_en <= '0';
				moving <= '1';
			
  END CASE;
 END PROCESS;
 
 END state_machine;