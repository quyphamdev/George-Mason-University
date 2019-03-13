----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2019 10:35:38 AM
-- Design Name: 
-- Module Name: GamePlayController - Behavioral
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
--use ieee.numeric_std;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GamePlayController is
    Port (  clk       : in  STD_LOGIC;
		    reset     : in std_logic;    
            sw          : in  STD_LOGIC_VECTOR (15 downto 0); -- 16 switches
            button      : in  STD_LOGIC_VECTOR (4 downto 0); -- 5 debounced buttons
            -- output
		    -- Seven Segment Display
            seg            : out    std_logic_vector(7 downto 0);
            an            : out    std_logic_vector(3 downto 0)            
            			
        );
end GamePlayController;

architecture Behavioral of GamePlayController is
	signal btn             : std_logic_vector(4 downto 0);
	signal game_diff       : std_logic_vector(1 downto 0);
	signal end_msg_displayed_2s    : std_logic;
	signal game_state      : std_logic_vector(1 downto 0); -- "00" reset, "01" start, "10" game over
	signal display_end_msg      : std_logic;
	signal pass_fail_msg_on     : std_logic;
	signal btnc_pressed_2s   : std_logic;
    signal msg_en              : std_logic;
    signal msg_idx             : std_logic_vector(1 downto 0);  -- "00" begin, "01" fail, "10" pass, "11" end 
    signal user_pattern     : std_logic_vector (1 downto 0);    -- 00=up, 01=right, 10=bottom, 11=left
    signal user_pattern_en  : std_logic;
    signal rand_pattern     : std_logic_vector (1 downto 0);    -- 00=up, 01=right, 10=bottom, 11=left
    signal rand_pattern_sseg_en  : std_logic;
    signal rand_pattern_sseg     : std_logic_vector (1 downto 0);    -- 00=up, 01=right, 10=bottom, 11=left
    signal next_rand_pattern  : std_logic;        
    signal display_level        : std_logic_vector(7 downto 0);
    signal cur_level    : integer;        	
    signal rand         : std_logic_vector(7 downto 0);
    signal user_pattern_input_en   : std_logic;
    signal display_rand_pattern_en   : std_logic;
    signal game_over  : std_logic;
    signal passed_a_level  : std_logic;-- user inputted correct pattern, will stay on for 2 sec
    signal failed_a_level  : std_logic;-- user inputted wrong pattern, will stay on for 2 sec
    signal pass_fail_msg_displayed_2s  : std_logic;
    signal display_pass_fail_msg  : std_logic;
    signal create_pattern_sequence  : std_logic;
    signal rand_pattern_cnt    : std_logic_vector(4 downto 0);

    type SeqType is array (0 to 18) of std_logic_vector(1 downto 0);
    type SSegRamPatType is array (0 to 3) of std_logic_vector(1 downto 0);    
    signal rand_pattern_seq : SeqType;
	constant SSegRamPattern	: SSegRamPatType	:= (
        "00",    -- 0=up
        "01",    -- 1=right
        "11",    -- 3=left
        "10"    -- 2=bottom        
        ); -- 00=up, 01=right, 10=bottom, 11=left
        
--	constant rand_pattern_seq	: SeqType	:= (
--            "00",    -- 0=up
--            "01",    -- 1=right
--            "11",    -- 3=left
--            "10",    -- 2=bottom
--            "00",    -- 0=up
--            "01",    -- 1=right
--            "11",    -- 3=left
--            "10",    -- 2=bottom
--            "00",    -- 0=up
--            "00",    -- 0=up
--            "01",    -- 1=right
--            "11",    -- 3=left
--            "10",    -- 2=bottom
--            "00",    -- 0=up
--            "01",    -- 1=right
--            "11",    -- 3=left
--            "10",    -- 2=bottom
--            "11",    -- 
--            "00"    -- 0=up                                
--            ); -- 00=up, 01=right, 10=bottom, 11=left          

begin
	-- Rising Edge Detector for all 5 buttons
	-- output is a spike which is much shorter than button()'s signals
	-- button's signals stay high until buttons are released
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
    
    -- 2 second timer
    -- starts when center button is pressed, en = '1' when 
    -- timer reaches 2 seconds or higher 
	BntCount2s_inst: entity work.count2s
        port map (
            clk1k   => clk,
            btn_pressed     => button(0),   -- center button
            -- output
            en => btnc_pressed_2s );
            
    -- 2 second timer for 'End' message    
	ShowEndMsgCount2s_inst: entity work.count2s
        port map (
            clk1k   => clk,
            btn_pressed     => display_end_msg,   --
            -- output 
            en => end_msg_displayed_2s );

    -- 2 second timer for pass or fail message    
	ShowPassFailMsgCount2s_inst: entity work.count2s
        port map (
            clk1k   => clk,
            btn_pressed     => display_pass_fail_msg,   --
            -- output 
            en => pass_fail_msg_displayed_2s );

    PatternDelay_inst: entity work.PatternDelay
        Port map ( 
            clk     => clk,
            reset   => reset,
            start   => rand_pattern_sseg_en,
            game_diff   => game_diff,
            -- output
            eno     => next_rand_pattern
            );

    -- Seven segment display    
	SSegInst : entity work.SSegCtrl
		port map(
			clk			=> clk,
			-- input
			reset        => reset,
			level        => display_level,   -- display when msg_en='0'
			pattern      => rand_pattern_sseg, -- display when msg_en='0'
			pattern_en   => rand_pattern_sseg_en,
            game_state  => game_state,  -- current game state
            correct     => passed_a_level, -- user input pattern is correct
            incorrect   => failed_a_level,	
			-- output
			SSegCA		=> seg,  -- 8-bit output to seven segment displays
			SSegAN		=> an);  -- 4-bit select signal to direct above output to correct sevent segment
			                     -- active low, each bit corresponds to a seg.
			                     -- seg3, seg2, seg1, seg0 (in order, from left to right)

    -- 18 (integer) convert to 1 (most significant 4-bit) and 8 (least significant 4-bit)
    -- to be displayed on two seven segment displays 
    display_level(7 downto 4) <= conv_std_logic_vector((cur_level/10), 4);
    display_level(3 downto 0) <= conv_std_logic_vector((cur_level mod 10), 4);

    -- random number generator
    -- take initial input from switches 0...7
    -- cannot be all 0's
	LFSR_rand_gen_inst: entity work.LFSR_rand_gen
    port map(
        clk => clk,
        reset => reset,
        sw  => sw(7 downto 0),  -- switches 0..7 
        -- output
        current_lfsr => rand); -- random number
    
    -- Read switches for Game difficulty parameter
    -- only at reset state
    
	process(clk, reset)
	begin
		if reset = '1' then
			game_diff <= "00";			
		elsif rising_edge(clk) then
            if game_state = "00" then   -- reset state, read switch for game difficulty
			     game_diff <= sw(15 downto 14); -- game difficulty
            end if;
        end if;
    end process;    

    

    -- Read center buttons' input
    -- adjusting game state
    
    process(clk, reset)
    begin
        if reset = '1' then
            game_state <= "00";
        elsif rising_edge(clk) then
            case game_state is
                when "00" =>    -- state reset                    
                    if btn(0) = '1' then -- center button pressed
                        game_state  <= "01";    -- start the game
                    end if;
                    
                when "01" =>    -- game start                
                    if (btnc_pressed_2s = '1') then-- center button pressed for >= 2 sec
                        game_state <= "00"; -- back to state reset
                    elsif (passed_a_level = '1' or failed_a_level = '1') then 
                        game_state <= "11"; -- change state, to display passed or failed message
                    elsif game_over = '1' then
                        game_state  <= "10";                                         
                    end if;
                                    
                when "10" =>    -- game over
                    -- delay 2 sec before go to reset state
                    if display_end_msg = '0' then -- if 'End' msg is not currently displayed
                        display_end_msg  <= '1'; -- start timer                    
                    elsif end_msg_displayed_2s = '1' then -- at least 2 sec has passed
                        game_state <= "00"; -- back to state reset
                        display_end_msg <= '0'; -- stop timer
                    end if;
                                        
                when "11" =>    -- show pass/fail message state
                    -- delay 2 sec before go to next state
                    if display_pass_fail_msg = '0' then -- not currently displayed
                        display_pass_fail_msg  <= '1'; -- start timer                    
                    elsif pass_fail_msg_displayed_2s = '1' then -- at least 2 sec has passed
                        if passed_a_level = '1' then                        
                            game_state <= "01"; -- back to game play    
                        elsif failed_a_level = '1' then
                            game_state <= "10"; -- go to game over state
                        end if;                    
                        display_pass_fail_msg <= '0'; -- stop timer
                    end if;                                        

            end case;
        end if;
    end process;

    -- During game play
    -- read button input -> generate displayed pattern
	process(clk, reset)
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
    
    -- get random pattern each clk cyc
    --
    rand_pattern  <=  rand(1 downto 0);
              
    
    -- Display random pattern for each level
    process(clk, reset)
        variable seq_idx             : integer; --
    begin
        if reset = '1' then
            rand_pattern_sseg_en    <= '0';
            user_pattern_input_en   <= '0'; -- disable user input
            rand_pattern_cnt     <= "00000";
            seq_idx     := 0;
            game_over   <= '0';
            failed_a_level      <= '0';
            passed_a_level      <= '0';
            create_pattern_sequence <= '1';
            cur_level   <= 1;
        elsif rising_edge(clk) then
            case game_state is
                when "00" =>    -- state reset
                    rand_pattern_sseg_en    <= '0';
                    user_pattern_input_en   <= '0'; -- disable user input
                    rand_pattern_cnt     <= "00000";                    
                    game_over   <= '0';
                    failed_a_level      <= '0';
                    passed_a_level      <= '0';
                    create_pattern_sequence <= '1';
                    cur_level   <= 1;                    
                    display_rand_pattern_en     <= '1'; -- display next sequence
                    
                    if seq_idx < 17 then    -- creating sequence
                        rand_pattern_seq(seq_idx)    <= rand_pattern;
                        seq_idx     := seq_idx + 1;
                    elsif seq_idx >= 17 then     -- done creating sequence 
                        seq_idx     := 0;
                        display_rand_pattern_en     <= '1'; -- display next sequence
                    end if;                                        
                    
                when "01" =>    -- game start
                    if game_over = '1' then
                        -- do nothing for now

                    elsif display_rand_pattern_en = '1' then -- displaying random pattern to seven segment displays                        
                        if cur_level > 16 then -- game ends
                            game_over   <= '1';
                        -- in middle of a sequence and no pattern being displayed
                        elsif rand_pattern_cnt < cur_level and rand_pattern_sseg_en = '0' then  
                            user_pattern_input_en   <= '0'; -- disable user input
                            rand_pattern_sseg_en     <= '1'; -- start delay timer, duration depends on game_diff
                                                            -- next_rand_pattern will be 0 until timer reaches desired delay
                            rand_pattern_sseg        <= rand_pattern_seq(conv_integer(unsigned(rand_pattern_cnt))); -- to be displayed on seven segment display
                            rand_pattern_cnt     <= rand_pattern_cnt + 1;
                            
                        -- pattern has been displayed for a desire duration
                        elsif rand_pattern_cnt < cur_level and rand_pattern_sseg_en = '1' and next_rand_pattern = '1' then
                            rand_pattern_sseg_en     <= '0'; -- reset pattern delay timer
                                                        
                        elsif rand_pattern_cnt >= cur_level and next_rand_pattern = '1' then -- done displaying random patterns
                            display_rand_pattern_en     <= '0'; -- user's turn to repeat the patterns
                            rand_pattern_cnt    <= "00000";   -- reset counter
                            rand_pattern_sseg_en     <= '0'; -- delay timer off
                            failed_a_level      <= '0';
                            passed_a_level      <= '0';
                        end if; 
                        
                    elsif display_rand_pattern_en = '0' then    -- user's turn to repeat the patterns
                        user_pattern_input_en   <= '1'; -- enable user input
                        if cur_level > 16 then -- game ends
                            game_over   <= '1';
                        elsif (passed_a_level = '0' and failed_a_level = '0') and conv_integer(unsigned(rand_pattern_cnt)) < cur_level and user_pattern_en = '1' then  -- user inputted a pattern
                            if user_pattern = rand_pattern_seq(conv_integer(unsigned(rand_pattern_cnt))) then -- correct input
                                rand_pattern_cnt     <= rand_pattern_cnt + 1;
                            else    -- incorrect input
                                failed_a_level      <= '1';
                                rand_pattern_cnt    <= "00000";   -- reset counter
                            end if;
                        elsif rand_pattern_cnt >= cur_level then -- done displaying random patterns
                            passed_a_level      <= '1';
                            cur_level           <= cur_level + 1;  -- next level
                            rand_pattern_cnt    <= "00000";   -- reset counter                                                    
--                            create_pattern_sequence <= '1'; -- add new pattern to the sequence
                            display_rand_pattern_en     <= '1'; -- display next sequence
                        end if;                         
                    end if;
                                    
                when "10" =>    -- game over
                                        
                when "11" =>    -- pass/fail message
                    -- pass/fail message has been displayed for 2s
                    if (passed_a_level = '1' or failed_a_level = '1') and pass_fail_msg_displayed_2s = '1' then
                        failed_a_level      <= '0';
                        passed_a_level      <= '0';
                        display_rand_pattern_en     <= '1'; -- if back to next level, display next sequence 
                    end if;
                
            end case;
        end if;
    end process;    

end Behavioral;
