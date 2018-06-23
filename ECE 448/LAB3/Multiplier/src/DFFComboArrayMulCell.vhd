-------------------------------------------------------------------------------
--
-- Title       : DFFComboArrayMulCell
-- Design      : Multiplier
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : DFFComboArrayMulCell.vhd
-- Generated   : Tue Feb 23 01:42:27 2010
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
--{entity {DFFComboArrayMulCell} architecture {DFFComboArrayMulCell}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DFFComboArrayMulCell is
	 port(
		 sin : in STD_LOGIC;
		 cin : in STD_LOGIC;
		 am : in STD_LOGIC;
		 xn : in STD_LOGIC;
		 CLK : in std_logic;
		 amout : out std_logic;
		 cout : out STD_LOGIC;
		 sout : out STD_LOGIC
	     );
end DFFComboArrayMulCell;

--}} End of automatically maintained section

architecture DFFComboArrayMulCell of DFFComboArrayMulCell is
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
signal AmAndXn : std_logic;
signal SumDin : std_logic;
signal CarryDin : std_logic;
begin
	AmAndXn <= am and xn;
	
	l1: FullAdder port map (
			i0 => sin,
			i1 => AmAndXn,
			ci => cin,
			co => CarryDin,
			s => SumDin
	);
	
	l2: DFlipFlop port map (
		D => SumDin,
		CLK => CLK,
		Q => sout
	);
	
	l3: DFlipFlop port map (
		D => CarryDin,
		CLK => CLK,
		Q => cout
	);

	l4: DFlipFlop port map (
		D => am,
		CLK => CLK,
		Q => amout
	);

end DFFComboArrayMulCell;
