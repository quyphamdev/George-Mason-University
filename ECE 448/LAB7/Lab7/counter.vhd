----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:30:21 03/30/2010 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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

entity counter is
    Port ( reset : in  STD_LOGIC;
           clk0 : in  STD_LOGIC;
           count_out : out  STD_LOGIC_VECTOR (14 downto 0));
end counter;

architecture Behavioral of counter is
signal count : std_logic_vector(14 downto 0);
begin
	process(clk0, reset)
	begin
		if rising_edge(clk0) then
			if reset = '1' then
				count <= (others => '0');
			else
				count <= count + 1;
			end if;
		end if;
	end process;
	
	count_out <= count;
	
end Behavioral;

