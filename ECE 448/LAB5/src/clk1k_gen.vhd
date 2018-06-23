----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:23:38 03/30/2010 
-- Design Name: 
-- Module Name:    clk1k_gen - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity clk1k_gen is
    Port ( clk0 : in  STD_LOGIC;
			reset : std_logic;
           clk1k : out  STD_LOGIC);
end clk1k_gen;

architecture Behavioral of clk1k_gen is
signal reset_en,rst : std_logic;
signal count : std_logic_vector(14 downto 0);
signal Q : std_logic;
signal nQ : std_logic ;
begin
	rst <= reset_en or reset;
	counter_inst: entity work.counter
		port map (
			reset => rst,
			clk0 => clk0,
			count_out => count);
			
	count25k_inst: entity work.count25k
		port map (
			count => count,
			en => reset_en);
	
	nQ <= not Q;
	RegEn_inst: entity work.RegEn
		port map (
			en => reset_en,
			reset => reset,
			D => nQ,
			Q => Q,
			clk0 => clk0);
			
	CLK0_BUFG_INST : BUFG
      port map (I=>Q,
                O=>clk1k);

end Behavioral;

