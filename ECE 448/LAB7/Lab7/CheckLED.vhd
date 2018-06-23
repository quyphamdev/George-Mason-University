----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:44:26 04/03/2010 
-- Design Name: 
-- Module Name:    CheckLED - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

entity CheckLED is
    Port ( clk : in  STD_LOGIC;
				reset : in std_logic;
           red_in : in  STD_LOGIC;
           out_led : out  STD_LOGIC);
end CheckLED;

architecture Behavioral of CheckLED is
	signal toggle : std_logic;
begin
	process(clk)
	begin
		if reset = '1' then
			toggle <= '0';
		elsif rising_edge(clk) then
			if red_in = '1' then
				toggle <= not toggle;
			end if;
			--if red_in = '1' then
				--toggle <= '1';
			--else
				--toggle <= '0';
			--end if;
			
		end if;		
	end process;
	out_led <= toggle;
	
end Behavioral;

