-------------------------------------------------------------------------------
--
-- Title       : Test Bench for debounce
-- Design      : lab5
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\debounce_TB.vhd
-- Generated   : 4/3/2010, 11:58 PM
-- From        : z:\ECE448\lab5\debounce.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for debounce_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity debounce_tb is
	-- Generic declarations of the tested unit
		generic(
		bit_size : NATURAL := 8 );
end debounce_tb;

architecture TB_ARCHITECTURE of debounce_tb is
	-- Component declaration of the tested unit
	component debounce
		generic(
		bit_size : NATURAL := 8 );
	port(
		clk : in std_logic;
		btn : in std_logic_vector(3 downto 0);
		button : out std_logic_vector(3 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : std_logic;
	signal btn : std_logic_vector(3 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal button : std_logic_vector(3 downto 0);

	-- Add your code here ...
	-- Clock period definitions
   constant mclk_period : time := 40ns;

begin

	-- Unit Under Test port map
	UUT : debounce
		generic map (
			bit_size => bit_size
		)

		port map (
			clk => clk,
			btn => btn,
			button => button
		);

	-- Add your stimulus here ...
	mclk_process :process
   begin
		clk <= '0';
		wait for mclk_period/2;
		clk <= '1';
		wait for mclk_period/2;
   end process;
   
   btn_pro : process
   begin
	   btn <= "0110";
	   wait for mclk_period*2;
	   btn <= "1001";
	   wait for mclk_period*2;
   end process;
   
	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_debounce of debounce_tb is
	for TB_ARCHITECTURE
		for UUT : debounce
			use entity work.debounce(behavior);
		end for;
	end for;
end TESTBENCH_FOR_debounce;

