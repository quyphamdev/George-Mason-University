-------------------------------------------------------------------------------
--
-- Title       : Test Bench for comboarraymultiplier
-- Design      : Multiplier
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\comboarraymultiplier_TB.vhd
-- Generated   : 2/22/2010, 10:43 PM
-- From        : Z:\ECE448\ECE448Lab3\Multiplier\src\ComboArrayMultiplier.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for comboarraymultiplier_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- Add your library and packages declaration here ...

entity comboarraymultiplier_tb is
	-- Generic declarations of the tested unit
		generic(
		k : INTEGER := 5 );
end comboarraymultiplier_tb;

architecture TB_ARCHITECTURE of comboarraymultiplier_tb is
	-- Component declaration of the tested unit
	component comboarraymultiplier
		generic(
		k : INTEGER := k );
	port(
		a : in std_logic_vector(k downto 1);
		x : in std_logic_vector(k downto 1);
		p : out std_logic_vector(k*2 downto 1) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal a : std_logic_vector(k downto 1);
	signal x : std_logic_vector(k downto 1);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal p : std_logic_vector(k*2 downto 1);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : comboarraymultiplier
		generic map (
			k => k
		)

		port map (
			a => a,
			x => x,
			p => p
		);

	-- Add your stimulus here ...
	testing: process
	variable v : std_logic_vector (k downto 1) := (others => '0');
	variable w : std_logic_vector (k downto 1) := (others => '0');
	variable z : std_logic_vector (k downto 1) := (others => '1');
	variable cnt : integer := 0;
	begin		
		a <= v;
		x <= w;
		v := std_logic_vector (unsigned(v) + 1);
		cnt := cnt + 1;
		if cnt > 32 then
			w := std_logic_vector (unsigned(w) + 1);
			cnt := 0;
		end if;		
		wait for 10ns;		
	end process;	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_comboarraymultiplier of comboarraymultiplier_tb is
	for TB_ARCHITECTURE
		for UUT : comboarraymultiplier
			use entity work.comboarraymultiplier(comboarraymultiplier);
		end for;
	end for;
end TESTBENCH_FOR_comboarraymultiplier;

