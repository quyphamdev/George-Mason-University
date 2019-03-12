----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2019 12:43:52 PM
-- Design Name: 
-- Module Name: InputController - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InputController is
    Port (  clk       : in  STD_LOGIC;
		    reset     : in std_logic;    
            sw          : in  STD_LOGIC_VECTOR (7 downto 0);
            button      : in  STD_LOGIC_VECTOR (4 downto 0);
            passed_last_level   : in std_logic;
            user_pattern_input_en   : in std_logic;            
            -- output
            cur_game_state      : out std_logic_vector(1 downto 0); -- "00" reset, "01" start, "10" game over
            cur_game_diff       : out std_logic_vector(1 downto 0);      
            user_pattern     : out std_logic_vector (7 downto 0);    -- 00=up, 01=right, 10=bottom, 11=left
            user_pattern_en  : out std_logic;
            btnc_pressed_2s   : out std_logic
            			
        );
end InputController;

architecture Behavioral of InputController is
	signal btn             : std_logic_vector(3 downto 0);
	signal game_diff       : std_logic_vector(1 downto 0);
	signal two_sec_passed  : std_logic;
	signal game_state      : std_logic_vector(1 downto 0); -- "00" reset, "01" start, "10" game over
begin
	-- Rising Edge Detector for all 4 buttons
	-- output is a spike
	red0_inst: entity work.RED
		port map(
			clk => clk,
			button => button(0),
			reset => reset,
			en => btn(0));   -- center button
			
	red1_inst: entity work.RED
		port map(
			clk => clk,
			button => button(1),
			reset => reset,
			en => btn(1));   -- left button
			
	red2_inst: entity work.RED
		port map(
			clk => clk,
			button => button(2),
			reset => reset,
			en => btn(2));   -- up button
			
	red3_inst: entity work.RED
		port map(
			clk => clk,
			button => button(3),
			reset => reset,
			en => btn(3));   -- right button

	red4_inst: entity work.RED
		port map(
			clk => clk,
			button => button(4),
			reset => reset,
			en => btn(4));   -- bottom button
    
	count2s_inst: entity work.count2s
        port map (
            clk1k   => clk,
            btn_pressed     => button(0),   -- center button
            en => two_sec_passed );
            
    btnc_pressed_2s     <= two_sec_passed;
    
    -- Read switches for Game difficulty parameter
    --
    cur_game_diff   <= game_diff;
	process(clk)
	begin
		if reset = '1' then
			game_diff <= x"00";			
		elsif rising_edge(clk) then
            if game_state = "00" then   -- reset state, read switch for game difficulty
			     game_diff <= sw(15 downto 14); -- game difficulty
            end if;
        end if;
    end process;    

    -- Read center buttons' input
    -- adjusting game state
    cur_game_state  <= game_state;
	process(clk)
	begin
		if reset = '1' then
			game_state   <= "00";    -- reset state			
		elsif rising_edge(clk) then			
			if two_sec_passed = '1' then -- center button pressed for >= 2 sec
                if game_state = "01" then   -- during game play
                    game_state  <= "00";    -- back to reset state 
                end if;
            elsif btn(0) = '1' then -- center button pressed
                if game_state = "00" then   -- during reset state
                    game_state  <= "01";    -- start the game 
                end if;
            elsif passed_last_level = '1' then
                game_state  <= "10";    -- game over state
            end if;			
		end if;
	end process;

    -- During game play
    -- read button input -> generate displayed pattern
	process(clk)
	begin
		if reset = '1' then
			user_pattern_en   <= '0';			
		elsif rising_edge(clk) then
            if game_state = "01" and user_pattern_input_en = '1' then    
                if btn(1) = '1' then -- left button pressed
                    user_pattern <= "11";    -- 00=up, 01=right, 10=bottom, 11=left
                    user_pattern_en  <= '1';
                elsif btn(2) = '1' then -- up button pressed
                    user_pattern <= "00";
                    user_pattern_en  <= '1';
                elsif btn(3) = '1' then -- right button pressed
                    user_pattern <= "01";
                    user_pattern_en  <= '1';
                elsif btn(4) = '1' then -- bottom button pressed
                    user_pattern <= "10";    -- 00=up, 01=right, 10=bottom, 11=left
                    user_pattern_en  <= '1';
                else -- no button pressed
                    user_pattern_en  <= '0';
                end if;
            end if;				
		end if;
    end process;

end Behavioral;
