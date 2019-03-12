----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2019 10:22:03 PM
-- Design Name: 
-- Module Name: gui - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gui is
    Port ( 
        clk     : in std_logic;
        reset   : in std_logic;
        -- input
        cur_game_state      : in std_logic_vector(1 downto 0);  -- "00" reset, "01" start, "10" game over
        compare_result      : in std_logic_vector(1 downto 0);  -- user input sequence = system sequence ?
                                                                -- "01" fail, "10" pass
        -- patterns for display                                                                    
        user_pattern        : in std_logic_vector (7 downto 0);    -- 00=up, 01=right, 10=bottom, 11=left
        user_pattern_en     : in std_logic;
        rand_pattern        : in std_logic_vector (7 downto 0);    -- 00=up, 01=right, 10=bottom, 11=left
        rand_pattern_en     : in std_logic;                
        -- output
        user_pattern_input_en   : in std_logic;
        pattern             : in std_logic_vector (7 downto 0);    -- 00=up, 01=right, 10=bottom, 11=left
        msg_en              : out std_logic;
        msg_idx             : out std_logic_vector(1 downto 0)  -- "00" begin, "01" fail, "10" pass, "11" end        
    );
end gui;

architecture Behavioral of gui is

begin

	process(clk, reset)
	begin    
        if reset = '1' then
            msg_en  <= '1';
            msg_idx <= "00";
        elsif rising_edge(clk) then
            if cur_game_state = "00" then   -- during reset state
                msg_en  <= '1';
                msg_idx <= "00";
            elsif cur_game_state = "01" then   -- during game play
                if compare_result = "01" then   -- fail
                    msg_en  <= '1';
                    msg_idx <= "01";    -- fail
                elsif compare_result = "10" then    -- pass
                    msg_en  <= '1';
                    msg_idx <= "10";    -- pass
                else
                    msg_en  <= '0'; -- stop displaying message                
                end if;
            elsif cur_game_state = "10" then   -- during game end
                msg_en  <= '1';
                msg_idx <= "11";            
            end if;
        end if;
    end process;

end Behavioral;
