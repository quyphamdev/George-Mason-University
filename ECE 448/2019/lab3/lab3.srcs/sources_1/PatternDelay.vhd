----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2019 04:35:50 PM
-- Design Name: 
-- Module Name: PatternDelay - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PatternDelay is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           game_diff : in STD_LOGIC_VECTOR (1 downto 0);
           start    : in std_logic;
           eno : out STD_LOGIC);
end PatternDelay;

architecture Behavioral of PatternDelay is
    signal count : std_logic_vector(31 downto 0);
    signal rst  : std_logic;
begin
	counter_inst: entity work.counter
        port map (
            reset => rst,
            clk0 => clk,
            count_out => count);

--    rst <= not start;

    -- 1k clock = 1ms = 0.001s
    -- 2s = 2000ms
    
    process(clk, reset, game_diff)
        variable    sec : integer;
    begin
        if reset = '1' then
            eno     <= '0';
        elsif rising_edge(clk) then
            case game_diff is
                when "00"   =>  -- delay 2 sec
                        sec := 3000;
                when "01"   =>  -- delay 1.5 sec
                        sec := 2250;                
                when "10"   =>  -- delay 1 sec
                        sec := 1500;  
                when "11"   =>  -- delay 0.5 sec
                        sec := 750;    
            end case;
            
            if count >= sec then
                eno <= '1';
                rst <= '1';
            else
                eno <= '0';
                rst <= '0';
            end if;              
        end if;
    end process;

end Behavioral;
