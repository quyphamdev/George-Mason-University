-------------------------------------------------------------------------------
--
-- Title       : Test Bench for clk1k_gen
-- Design      : lab5
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\clk1k_gen_TB.vhd
-- Generated   : 4/3/2010, 7:11 PM
-- From        : z:\ECE448\Lab5\clk1k_gen.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for clk1k_gen_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library unisim;
use unisim.vcomponents.all;

	-- Add your library and packages declaration here ...

entity clk1k_gen_tb is
end clk1k_gen_tb;

architecture TB_ARCHITECTURE of clk1k_gen_tb is
	-- Component declaration of the tested unit
	component clk1k_gen
	port(
		clk0 : in std_logic;
		reset : in std_logic;
		clk1k : out std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk0 : std_logic;
	signal reset : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal clk1k : std_logic;

	-- Add your code here ...
	-- Clock period definitions
   constant mclk_period : time := 40ns;

begin

	-- Unit Under Test port map
	UUT : clk1k_gen
		port map (
			clk0 => clk0,
			reset => reset,
			clk1k => clk1k
		);

	-- Add your stimulus here ...
	reset_process : process
	begin
		reset <= '1';
		wait for mclk_period*10;
		reset <= '0';
		wait;
	end process;
	
	mclk_process :process
   begin
		clk0 <= '0';
		wait for mclk_period/2;
		clk0 <= '1';
		wait for mclk_period/2;
   end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_clk1k_gen of clk1k_gen_tb is
	for TB_ARCHITECTURE
		for UUT : clk1k_gen
			use entity work.clk1k_gen(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_clk1k_gen;

