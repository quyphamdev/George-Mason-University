----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:54:06 03/30/2010 
-- Design Name: 
-- Module Name:    RegEn - Behavioral 
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

entity RegEn is
    Port ( en : in  STD_LOGIC;
			D : in  STD_LOGIC;
			reset : std_logic;
           Q : out  STD_LOGIC;
           clk0 : in  STD_LOGIC);
end RegEn;

architecture Behavioral of RegEn is

begin
	process(clk0,en,reset)
	begin
		if reset = '1' then
			Q <= '0';
		elsif rising_edge(clk0) then
			if en = '1' then
				Q <= D;
			end if;
		end if;
	end process;

end Behavioral;

