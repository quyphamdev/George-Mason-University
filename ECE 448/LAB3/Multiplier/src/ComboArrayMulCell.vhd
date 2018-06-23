-------------------------------------------------------------------------------
--
-- Title       : ComboArrayMulCell
-- Design      : Multiplier
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : ComboArrayMulCell.vhd
-- Generated   : Sat Feb 20 17:37:59 2010
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ComboArrayMulCell} architecture {ComboArrayMulCell}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ComboArrayMulCell is
	 port(
		 sin : in STD_LOGIC;
		 am : in STD_LOGIC;
		 cin : in STD_LOGIC;
		 xn : in STD_LOGIC;
		 sout : out STD_LOGIC;
		 cout : out STD_LOGIC
	     );
end ComboArrayMulCell;

--}} End of automatically maintained section

architecture ComboArrayMulCell of ComboArrayMulCell is
component FullAdder is
	 port(
		 i0 : in STD_LOGIC;
		 i1 : in STD_LOGIC;
		 ci : in STD_LOGIC;
		 s : out STD_LOGIC;
		 co : out STD_LOGIC
	     );
end component;
signal AmAndXn : std_logic;
begin
	AmAndXn <= am and xn;
	
	l1: FullAdder port map (
			i0 => sin,
			i1 => AmAndXn,
			ci => cin,
			co => cout,
			s => sout
	);

end ComboArrayMulCell;
