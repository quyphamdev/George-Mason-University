library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity combomultiplier_tb is
	-- Generic declarations of the tested unit
		generic(
		k : INTEGER := 4 );
end combomultiplier_tb;

architecture TB_ARCHITECTURE of combomultiplier_tb is
-- Component declaration of the tested unit
	constant N : integer := 4;
	
	component combomultiplier
		generic(
		k : INTEGER := N );
	port(
		A : in STD_LOGIC_VECTOR(k-1 downto 0);
		B : in STD_LOGIC_VECTOR(k-1 downto 0);
		Z : out STD_LOGIC_VECTOR(k*2-1 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal A : STD_LOGIC_VECTOR(k-1 downto 0);
	signal B : STD_LOGIC_VECTOR(k-1 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal Z : STD_LOGIC_VECTOR(k*2-1 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : combomultiplier
		generic map (
			k => N
		)

		port map (
			A => A,
			B => B,
			Z => Z
		);

	-- Add your stimulus here ...
	testing: process(A, B)
	begin
		A <= "0010";
		B <= "0100";		
	end process;
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_combomultiplier of combomultiplier_tb is
	for TB_ARCHITECTURE
		for UUT : combomultiplier
			use entity work.combomultiplier(combomultiplier);
		end for;
	end for;
end TESTBENCH_FOR_combomultiplier;

