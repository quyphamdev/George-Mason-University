----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2019 11:14:06 PM
-- Design Name: 
-- Module Name: SSegCtrl - Behavioral
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

entity SSegCtrl is
	port(
		Clk			  : in    std_logic;
		reset         : in    std_logic;
		-- Inputs
		level         : in    std_logic_vector(7 downto 0);
		pattern       : in    std_logic_vector(1 downto 0);   -- 00=up, 01=right, 10=bottom, 11=left (delay depends on game difficulty)
		game_state    : in    std_logic_vector(1 downto 0); -- "00" reset, "01" start, "10" game over
		incorrect     : in    std_logic;  -- user inputted wrong pattern, will stay on for 2 sec
		correct       : in    std_logic; -- user inputted correct pattern, will stay on for 2 sec		
		-- Outputs
		SSegCA		: out	std_logic_vector(7 downto 0);
		SSegAN		: out	std_logic_vector(3 downto 0)
		);
end entity SSegCtrl;

architecture BEHAVIOR of SSegCtrl is
	--------------------------------
	-- CONSTANTS AND TYPES
	--------------------------------
	type StateType is (
		SSeg0,	-- Display Input0
		SSeg1,	-- Display Input1
		SSeg2,	-- Display Input2
		SSeg3);	-- Display Input3
		
	type SSegRamDigitType is array (0 to 9) of std_logic_vector(6 downto 0);
	type SSegRamCharType is array (0 to 9) of std_logic_vector(6 downto 0);
	type SSegRamPatType is array (0 to 3) of std_logic_vector(6 downto 0);
	type MsgRamType is array (0 to 3) of std_logic_vector(7 downto 0);
	
	-- Seven segment led is Active low
	constant SSegRamDigit	: SSegRamDigitType	:= (
		"0000001",	-- 0
		"1001111",	-- 1
		"0010010",	-- 2
		"0000110",	-- 3
		"1001100",	-- 4
		"0100100",	-- 5
		"0100000",	-- 6
		"0001111",	-- 7
		"0000000",	-- 8
		"0000100"	-- 9
        );
		
	constant SSegRamPattern	: SSegRamPatType	:= (
        "0111111",    -- 0=up
        "1001111",    -- 1=right
        "1110111",    -- 2=bottom
        "1111001"    -- 3=left
        );	
        
    constant BeginMsgRam     : MsgRamType    := (
        "11000001", --b
        "01100001", --E
        "00001001", --9
        "11010101" --n
    );        
    
    constant FailMsgRam     : MsgRamType    := (
        "01110001", --F
        "00010001", --A
        "10011111", --1
        "11100011" --L
    );
    
    constant PassMsgRam     : MsgRamType    := (
        "00110001", --P
        "00010001", --A
        "01001001", --5
        "01001001" --5
    );
    
    constant EndMsgRam     : MsgRamType    := (
        "01100001", --E
        "11010101", --n
        "10000101", --d
        "11111111" --(nothing)
    );            
     
	--------------------------------
	-- SIGNALS
	--------------------------------
	signal State	: StateType		:= SSeg0;
    signal msg_en              : std_logic;
    signal msg_idx             : std_logic_vector(1 downto 0);  -- "00" begin, "01" fail, "10" pass, "11" end
    signal toggle   : std_logic;
    	
begin

    -- output 'toggle' will enable for 0.5s and off for 0.5s
    -- uses this output to create blinking message
	blink_isnt: entity work.blink
    port map (
        reset => reset,
        clk => clk,
        toggle => toggle);

	--------------------------------
	-- STATE MACHINE
	--------------------------------
	
    process(clk, reset)
    begin
        if reset = '1' then
            
        elsif rising_edge(clk) then
            case game_state is
                when "00" =>    -- state reset
                    msg_en  <= '1';
                    msg_idx <= "00";
                when "01" =>    -- game start
                    -- display fail or pass message or (level and patterns) 
                    if incorrect = '1' or correct = '1' then                    
                        msg_en  <= '1';
                    else
                        msg_en  <= '0';                    
                    end if;                    
                                    
                when "10" =>    -- game over
                    msg_en  <= '1';
                    msg_idx <= "11";
                                                            
                when "11" =>    -- pass/fail message
                    msg_en  <= '1';
                    if incorrect = '1' then -- display fail message
                        msg_idx <= "01";
                    elsif correct = '1' then -- display pass message
                        msg_idx <= "10";
                    end if;                
                
            end case;
        end if;
    end process;    	
	
	ShowLevelPatNMsg : process(clk)
	   variable empty      : std_logic_vector(7 downto 0) := x"FF";
	   variable message    : std_logic_vector(31 downto 0);
	begin
		if rising_edge(clk) then
		  if game_state = "01" and msg_en = '0' then
                case State is
                    when SSeg0 => -- display current level, first degit
                        State	<= SSeg1;
                        SSegCA(7 downto 1)	<= SSegRamDigit(to_integer(unsigned(level(7 downto 4))));
                        SSegCA(0)  <= '1'; -- turn off decimal point
                        SSegAN	<= "0111"; -- active low
                    when SSeg1 => -- dispaly current level, second digit
                        State	<= SSeg2;
                        SSegCA(7 downto 1)	<= SSegRamDigit(to_integer(unsigned(level(3 downto  0))));
                        SSegCA(0)  <= '0'; -- turn on decimal point
                        SSegAN	<= "1011";
                    when SSeg2 => -- display pattern, left seven segment of the two
                        State	<= SSeg3;
                        if SSegRamPattern(to_integer(unsigned(pattern))) = SSegRamPattern(1) then -- when it's a right pattern, dont display on this sseg
                           SSegCA(7 downto 1)	<= (others => '1');
                        else
                           SSegCA(7 downto 1)	<= SSegRamPattern(to_integer(unsigned(pattern)));
                        end if;
                        SSegCA(0)  <= '1';
                        SSegAN	<= "1101";
                    when SSeg3 =>   -- display pattern, right seven segment of the two
                        State	<= SSeg0;
                        if SSegRamPattern(to_integer(unsigned(pattern))) = SSegRamPattern(3) then -- when it's a left pattern, dont display on this sseg
                           SSegCA(7 downto 1)    <= (others => '1');
                        else
                           SSegCA(7 downto 1)    <= SSegRamPattern(to_integer(unsigned(pattern)));
                        end if;
                        SSegCA(0)  <= '1';
                        SSegAN	<= "1110"; -- active low
                end case;
                
            elsif msg_en = '1' then
                case msg_idx is
                    when "00" => 
                        if toggle = '1' then
                            message(31 downto 24) := BeginMsgRam(0);
                            message(23 downto 16) := BeginMsgRam(1);
                            message(15 downto 8) := BeginMsgRam(2);
                            message(7 downto 0) := BeginMsgRam(3);
                        else
                            message(31 downto 24) := empty;
                            message(23 downto 16) := empty;
                            message(15 downto 8) := empty;
                            message(7 downto 0) := empty;                    
                        end if;
                    when "01" => 
                        message(31 downto 24) := FailMsgRam(0);
                        message(23 downto 16) := FailMsgRam(1);
                        message(15 downto 8) := FailMsgRam(2);
                        message(7 downto 0) := FailMsgRam(3);
                    when "10" => 
                        message(31 downto 24) := PassMsgRam(0);
                        message(23 downto 16) := PassMsgRam(1);
                        message(15 downto 8) := PassMsgRam(2);
                        message(7 downto 0) := PassMsgRam(3);
                    when "11" => 
                        if toggle = '1' then
                            message(31 downto 24) := EndMsgRam(0);
                            message(23 downto 16) := EndMsgRam(1);
                            message(15 downto 8) := EndMsgRam(2);
                            message(7 downto 0) := EndMsgRam(3);
                        else
                            message(31 downto 24) := empty;
                            message(23 downto 16) := empty;
                            message(15 downto 8) := empty;
                            message(7 downto 0) := empty;                    
                        end if;                                                
                end case;  
                          
                case State is
                    when SSeg0 =>
                        State    <= SSeg1;
                        SSegCA    <= message(31 downto 24);
                        SSegAN    <= "0111";
                    when SSeg1 =>
                        State    <= SSeg2;
                        SSegCA    <= message(23 downto 16);
                        SSegAN    <= "1011";
                    when SSeg2 =>
                        State    <= SSeg3;
                        SSegCA    <= message(15 downto 8);
                        SSegAN    <= "1101";
                    when SSeg3 =>
                        State    <= SSeg0;
                        SSegCA    <= message(7 downto 0);
                        SSegAN    <= "1110";
                end case;            
		    end if;
		end if;
	end process ShowLevelPatNMsg;

	
end architecture BEHAVIOR;
