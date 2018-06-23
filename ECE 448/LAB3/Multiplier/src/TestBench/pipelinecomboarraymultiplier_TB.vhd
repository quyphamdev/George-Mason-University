-------------------------------------------------------------------------------
--
-- Title       : Test Bench for pipelinecomboarraymultiplier
-- Design      : Multiplier
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\pipelinecomboarraymultiplier_TB.vhd
-- Generated   : 2/23/2010, 3:54 AM
-- From        : $DSN\src\PipelineComboArrayMultiplier.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for pipelinecomboarraymultiplier_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- Add your library and packages declaration here ...

entity pipelinecomboarraymultiplier_tb is
	-- Generic declarations of the tested unit
		generic(
		k : INTEGER := 5 );
end pipelinecomboarraymultiplier_tb;

architecture TB_ARCHITECTURE of pipelinecomboarraymultiplier_tb is
	-- Component declaration of the tested unit
	component pipelinecomboarraymultiplier
		generic(
		k : INTEGER := k );
	port(
		a : in std_logic_vector(k downto 1);
		x : in std_logic_vector(k downto 1);
		CLK : in std_logic;
		p : out std_logic_vector(k*2 downto 1) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal a : std_logic_vector(k downto 1);
	signal x : std_logic_vector(k downto 1);
	signal CLK : std_logic := '0';
	-- Observed signals - signals mapped to the output ports of tested entity
	signal p : std_logic_vector(k*2 downto 1);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : pipelinecomboarraymultiplier
		generic map (
			k => k
		)

		port map (
			a => a,
			x => x,
			CLK => CLK,
			p => p
		);

	-- Add your stimulus here ...
	clock: process
	begin
		CLK <= not CLK;
		wait for 10ns;
	end process;	
	
	testing: process(CLK)
	variable v : std_logic_vector (k downto 1) := (1 => '1', others => '0');
	variable w : std_logic_vector (k downto 1) := (1 => '1', others => '0');
--	variable v : std_logic_vector (k downto 1) := (others => '1');
--	variable w : std_logic_vector (k downto 1) := (others => '1');
	variable z : std_logic_vector (k downto 1) := (others => '1');
	variable cnt : integer := 1;
	begin
		if rising_edge(CLK) then
			a <= v;
			x <= w;
			w := std_logic_vector (unsigned(w) + 1);
			cnt := cnt + 1;
			if cnt > 15 then
				v := std_logic_vector (unsigned(v) + 1);
				cnt := 0;
			end if;				
		end if;		
	end process;	


end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_pipelinecomboarraymultiplier of pipelinecomboarraymultiplier_tb is
	for TB_ARCHITECTURE
		for UUT : pipelinecomboarraymultiplier
			use entity work.pipelinecomboarraymultiplier(pipelinecomboarraymultiplier);
		end for;
	end for;
end TESTBENCH_FOR_pipelinecomboarraymultiplier;

