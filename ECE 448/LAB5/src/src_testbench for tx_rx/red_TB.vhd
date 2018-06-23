-------------------------------------------------------------------------------
--
-- Title       : Test Bench for red
-- Design      : lab5
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\red_TB.vhd
-- Generated   : 4/3/2010, 7:20 PM
-- From        : z:\ECE448\lab5\red.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for red_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

	-- Add your library and packages declaration here ...

entity red_tb is
end red_tb;

architecture TB_ARCHITECTURE of red_tb is
	-- Component declaration of the tested unit
	component red
	port(
		clk : in std_logic;
		button : in std_logic;
		reset : in std_logic;
		en : out std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : std_logic;
	signal button : std_logic;
	signal reset : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal en : std_logic;

	-- Add your code here ...
	-- Clock period definitions
   constant mclk_period : time := 40ns;
   
	

begin

	-- Unit Under Test port map
	UUT : red
		port map (
			clk => clk,
			button => button,
			reset => reset,
			en => en
		);

	-- Add your stimulus here ...
	reset_process : process
	begin
		reset <= '1';
		wait for mclk_period*10;
		reset <= '0';
		wait;
	end process;
	
	-- Add your stimulus here ...
	btn_process : process
	begin
		button <= '1';
		wait for mclk_period*2;
		button <= '0';
		wait for mclk_period*5;
	end process;
	
	mclk_process :process
   begin
		clk <= '0';
		wait for mclk_period/2;
		clk <= '1';
		wait for mclk_period/2;
   end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_red of red_tb is
	for TB_ARCHITECTURE
		for UUT : red
			use entity work.red(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_red;

