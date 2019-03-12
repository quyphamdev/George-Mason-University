----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2019 07:33:11 PM
-- Design Name: 
-- Module Name: count2s - Behavioral
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

entity count2s is
    Port ( clk1k        : in  STD_LOGIC;
          btn_pressed   : in std_logic;
           en           : out  STD_LOGIC);
end count2s;

architecture Behavioral of count2s is
    signal count : std_logic_vector(31 downto 0);
    signal rst  : std_logic;
begin
    rst <= not btn_pressed;
	counter_inst: entity work.counter
    port map (
        reset => rst,
        clk0 => clk1k,
        count_out => count);
    
    -- 1k clock = 1ms = 0.001s
    -- 2s = 2000ms
	en <= '1' when count >= 2000 else '0'; -- enable when button pressed for more than 2 sec

end Behavioral;
