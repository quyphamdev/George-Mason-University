----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2019 11:32:02 PM
-- Design Name: 
-- Module Name: SimonGame - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	--use work.MyLibrary.all;

entity SimonGame is
	port(
		-- Clocks
		mclk		: in	std_logic;
		-- Rotary button and switches
        sw            : in    std_logic_vector(15 downto 0);    -- 16 switches
        btn            : in    std_logic_vector(4 downto 0);    -- 5 buttons
		-- LEDs
		led			: out	std_logic_vector(7 downto 0); -- Active High LEDs
		-- Seven Segment Display
		seg			: out	std_logic_vector(7 downto 0);
		an			: out	std_logic_vector(3 downto 0)
		);
end entity SimonGame;

architecture RTL of SimonGame is

	COMPONENT DCMSP_Clocks
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		CLK180_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

	-- DCM signals
	signal reset	: std_logic;
	signal clk0		: std_logic;
	signal clk0_180	: std_logic;
	signal clk1k	: std_logic;
	signal locked : std_logic;
	-- LED signals
	signal dcm_lock	: std_logic;
	-- Other signals
	signal button	: std_logic_vector(4 downto 0);
	signal out_led : std_logic_vector(1 downto 0);

begin
	----------------------------------------------------------------
	-- MAP THE OUTPUTS
	----------------------------------------------------------------

	dcm_lock	<= not reset;
	-- Tie off LEDs
	led	<= (7		=> dcm_lock,
			6		=> clk0,
			5		=> clk1k,
			4		=> button(4),
			3		=> button(3),
			2		=> button(2),
			1		=> button(1),
			0		=> button(0));

	----------------------------------------------------------------
	-- Clock Generation
	----------------------------------------------------------------
	-- 
	DCMSP_Clocks_inst: DCMSP_Clocks PORT MAP(
		CLKIN_IN => mclk,
		--CLKIN_IBUFG_OUT => open,
		CLK0_OUT => clk0,
		CLK180_OUT => clk0_180,
		LOCKED_OUT => locked -- (1) stable
	);
	-- reset when not stable
	reset <= not locked;
			
	-- Clk 1k generator
	clk1k_gen_inst: entity work.clk1k_gen
		port map (
			clk0 => clk0,
			reset => reset,
			-- output
			clk1k => clk1k);
	
	----------------------------------------------------------------
	-- Surrounding parts
	----------------------------------------------------------------
	-- Buttons debouncing
	debounce_inst : entity work.debounce
		port map(
			clk		=> clk1k,
			btn		=> btn,
			-- output
			button	=> button); -- 5-bit output, each bit for each buttons			

    GamePlayController_inst : entity work.GamePlayController
        port map (  
            clk     => clk1k,
		    reset     => reset,    
            sw      => sw,      -- 16 switches
            button  => button,  -- 5 debounced buttons
            -- output
		    -- Seven Segment Display
            seg     => seg,
            an      => an                        			
        );	
	
end architecture RTL;
