----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2019 02:37:20 PM
-- Design Name: 
-- Module Name: blink - Behavioral
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

entity blink is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           toggle : out STD_LOGIC);
end blink;

architecture Behavioral of blink is
    signal count_on : std_logic_vector(31 downto 0);
    signal count_off : std_logic_vector(31 downto 0);
    signal rst_on  : std_logic;
    signal rst_off  : std_logic;
    signal en_on  : std_logic;
    signal en_off  : std_logic;
begin

	counter_on_inst: entity work.counter
    port map (
        reset => rst_on,
        clk0 => clk,
        count_out => count_on);
    
    -- 1k clock = 1ms = 0.001s
    -- 2s = 2000ms
	en_on <= '1' when count_on >= 500 else '0';
	
	counter_off_inst: entity work.counter
    port map (
        reset => rst_off,
        clk0 => clk,
        count_out => count_off);
    
    -- 1k clock = 1ms = 0.001s
    -- 2s = 2000ms
    en_off <= '1' when count_off >= 1000 else '0';
    
    rst_on <= '1' when reset = '1' else en_off;
    rst_off <= '1' when reset = '1' else en_off;
    	
	toggle <= en_on;
	
end Behavioral;
