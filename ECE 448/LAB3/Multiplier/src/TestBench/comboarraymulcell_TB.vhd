-------------------------------------------------------------------------------
--
-- Title       : Test Bench for comboarraymulcell
-- Design      : Multiplier
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\comboarraymulcell_TB.vhd
-- Generated   : 2/22/2010, 12:19 AM
-- From        : Z:\ECE448\ece448lab3\multiplier\src\comboarraymulcell.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for comboarraymulcell_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity comboarraymulcell_tb is
end comboarraymulcell_tb;

architecture TB_ARCHITECTURE of comboarraymulcell_tb is
	-- Component declaration of the tested unit
	component comboarraymulcell
	port(
		sin : in std_logic;
		am : in std_logic;
		cin : in std_logic;
		xn : in std_logic;
		sout : out std_logic;
		cout : out std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal sin : std_logic;
	signal am : std_logic;
	signal cin : std_logic;
	signal xn : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal sout : std_logic;
	signal cout : std_logic;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : comboarraymulcell
		port map (
			sin => sin,
			am => am,
			cin => cin,
			xn => xn,
			sout => sout,
			cout => cout
		);

	-- Add your stimulus here ...
	sin <= '1';
	am <= '1';
	xn <= '1';
	cin <= '1';	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_comboarraymulcell of comboarraymulcell_tb is
	for TB_ARCHITECTURE
		for UUT : comboarraymulcell
			use entity work.comboarraymulcell(comboarraymulcell);
		end for;
	end for;
end TESTBENCH_FOR_comboarraymulcell;

