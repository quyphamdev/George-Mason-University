----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:41:36 05/10/2010 
-- Design Name: 
-- Module Name:    D_FF - Behavioral 
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

entity D_FF is
    Port ( clk : in  STD_LOGIC;
           set : in  STD_LOGIC;
			  en : in std_logic;
           D : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end D_FF;

architecture Behavioral of D_FF is

begin
	process(clk, set, en)
	begin
		if set = '1' then
			Q <= '1';
		elsif rising_edge(clk) then
			if en = '1' then
				Q <= D;
			end if;
		end if;
	end process;

end Behavioral;

