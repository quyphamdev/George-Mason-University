-------------------------------------------------------------------------------
--
-- Title       : DFFComboArrayMulCellNoN
-- Design      : Multiplier
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : DFFComboArrayMulCellNoN.vhd
-- Generated   : Tue Feb 23 02:11:09 2010
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {DFFComboArrayMulCellNoN} architecture {DFFComboArrayMulCellNoN}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DFFComboArrayMulCellNoN is
	 port(
		 x : in STD_LOGIC;
		 y : in STD_LOGIC;
		 cin : in STD_LOGIC;
		 CLK : in std_logic;
		 cout : out STD_LOGIC;
		 s : out STD_LOGIC
	     );
end DFFComboArrayMulCellNoN;

--}} End of automatically maintained section

architecture DFFComboArrayMulCellNoN of DFFComboArrayMulCellNoN is
component FullAdder is
	 port(
		 i0 : in STD_LOGIC;
		 i1 : in STD_LOGIC;
		 ci : in STD_LOGIC;
		 s : out STD_LOGIC;
		 co : out STD_LOGIC
	     );
end component;
component DFlipFlop is
	 port(
		 D : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 Q : out STD_LOGIC
	     );
end component;
signal SumDin : std_logic;
signal CarryDin : std_logic;

begin
	l1: FullAdder port	map (
			i0 => x,
			i1 => y,
			ci => cin,
			co => CarryDin,
			s => SumDin
	);
	
	l2: DFlipFlop port map (
		D => SumDin,
		CLK => CLK,
		Q => s
	);
	
	l3: DFlipFlop port map (
		D => CarryDin,
		CLK => CLK,
		Q => cout
	);

end DFFComboArrayMulCellNoN;
