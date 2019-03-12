----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2019 12:07:11 AM
-- Design Name: 
-- Module Name: RED - Behavioral
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

entity RED is
    Port ( clk : in  STD_LOGIC;
			button : in  STD_LOGIC;
			reset : in std_logic;
           en : out  STD_LOGIC);
end RED;

architecture Behavioral of RED is
signal Q : std_logic;
begin
	RegEn_inst: entity work.RegEn
		port map(
			clk0 => clk,
			en => '1',
			reset => reset,
			D => button,
			Q => Q);

	en <= (not Q) and button when reset = '0' else '0'; -- rising edge detector
	--en <= Q and (not button); -- falling edge detector

end Behavioral;

