-------------------------------------------------------------------------------
--
-- Title       : Test Bench for lc3b_bd
-- Design      : LC3b
-- Author      : JasonVM
-- Company     : JVM
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\lc3b_bd_TB.vhd
-- Generated   : 2/19/2009, 3:15 AM
-- From        : $DSN\compile\lc3b_bd.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for lc3b_bd_tb
--
-------------------------------------------------------------------------------

library LC3b;
use LC3b.lc3b_types.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity lc3b_bd_tb is
end lc3b_bd_tb;

architecture TB_ARCHITECTURE of lc3b_bd_tb is
	-- Component declaration of the tested unit
	component lc3b_bd
	port(
		CLK : in std_logic;
		RESET_L : in std_logic;
		START_H : in std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : std_logic := '0';
	signal RESET_L : std_logic := '0';
	signal START_H : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : lc3b_bd
		port map (
			CLK => CLK,
			RESET_L => RESET_L,
			START_H => START_H
		);

	-- Add your stimulus here ...
	process
	begin 
		wait for 60 ns;
		reset_L <= '0';
		wait for 60 ns;
		reset_l <= '1';
		start_h <= '1';
		wait;   
	end process;
	CLK <= not CLK after 30ns;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_lc3b_bd of lc3b_bd_tb is
	for TB_ARCHITECTURE
		for UUT : lc3b_bd
			use entity work.lc3b_bd(lc3b_bd);
		end for;
	end for;
end TESTBENCH_FOR_lc3b_bd;

