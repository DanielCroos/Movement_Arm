--Lab4
--Group Number: 9
--Group Members: Daniel Croos and Stephanie De Pol

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   Clk			: in	std_logic;
	rst_n			: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 
   leds			: out std_logic_vector(15 downto 0)	
	);
END LogicalStep_Lab4_top;

ARCHITECTURE Circuit OF LogicalStep_Lab4_top IS
	
	--These components will be used prior to Part C
	component bidir_shift_reg port (
			clk 							: in std_logic :='0';
			reset_n 						: in std_logic :='0';
			clk_en						: in std_logic :='0';
			left0_right1 				: in std_logic :='0';
			reg_bits						: out std_logic_vector(7 downto 0)
	); 
	end component; 
	
	component u_d_bin_counter8bit port (
			clk 							: in std_logic :='0';
			reset_n 						: in std_logic :='0';
			clk_en						: in std_logic :='0';
			up1_down0 					: in std_logic :='0';
			counter_bits				: out std_logic_vector(7 downto 0)
	); 
	end component; 

	-- These are the 3 components of the Robotic Arm Controller --------------------------
	component grappler port (
		rst_n							: IN std_logic := '0';	
		grap_toggle, grap_en		: IN std_logic := '0';
		grap_out						: OUT std_logic:= '0'
	);
	end component;
	
	component extender port (
		clk,rst_n						: IN std_logic := '0';	
		extender_toggle, extender_en		: IN std_logic := '0';
		position									: OUT std_logic_vector(3 downto 0);
		extender_out,grap_en					: OUT std_logic := '0'
	);
	end component;
	
	component movement_arm Port(
		clk, rst_n								: IN std_logic  := '0';
		toggle,extender_out					: IN std_logic	 := '0';
		target_x,target_y						: IN std_logic_vector(3 downto 0);
		error_led								: OUT std_logic := '0';
		current_x,current_y					: OUT std_logic_vector(3 downto 0);
		extender_en								: OUT std_logic := '0'
	);
	end component;
	
	--The signals belows are required for the implementation
	signal grappler_enable, extender_enable, extender_out : std_logic := '0';
	
BEGIN

-- PRE RAC IMPlementation ------------------------------------------------------------------
----This instance directly assigns the input signals according to 1.3.5.1 in the lab manual
--inst1: bidir_shift_reg port map (clk, pb(0), sw(0), sw(1), leds(7 downto 0));
--
----This instance directly assigns the input signals according to 1.3.5.3 in the lab manual
--inst2: u_d_bin_counter8bit port map (clk, pb(0), sw(0), sw(1), leds(7 downto 0));
---------------------------------------------------------------------------------------------


----The following instances correspond to the top level implementation of the RAC------------------

-- The purpose of this instance is to activate the grappler when at the falling edge of the button push
-- while considering reset and the extension level of the extender before activating  
inst1: grappler port map (rst_n, pb(0), grappler_enable, leds(3));

-- This instance has multiple purposes, with its first being activing the extender at falling edge of 
-- the button push while considering reset and if the RAC is moving
-- Its second is to tell the movement_arm its state to ensure it does move when it is extended (fully or partially)
-- while indicating its extension level
inst2: extender port map (clk, rst_n, pb(1), extender_enable, leds(7 downto 4), 
									extender_out, grappler_enable);

-- This instance also has multiple purposes, with its first being activating the movement arm at the falling
-- edge of its button push while considering reset and the extension of the extender
-- It must also output its (x,y) location and throw errors when user pushes button when it is extended while 
-- letting the extender know it is allowed to extend 
inst3: movement_arm port map (clk, rst_n, pb(2), extender_out, sw(7 downto 4), sw(3 downto 0), 
										leds(0),leds(15 downto 12), leds(11 downto 8), 
										extender_enable);
---------------------------------------------------------------------------------------------------------							
END Circuit;
