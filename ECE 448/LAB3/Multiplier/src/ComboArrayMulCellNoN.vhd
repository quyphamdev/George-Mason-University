-------------------------------------------------------------------------------
--
-- Title       : ComboArrayMulCellNoN
-- Design      : Multiplier
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : ComboArrayMulCellNoN.vhd
-- Generated   : Sat Feb 20 18:02:01 2010
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
--{entity {ComboArrayMulCellNoN} architecture {ComboArrayMulCellNoN}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ComboArrayMulCellNoN is
	 port(
		 x : in STD_LOGIC;
		 y : in STD_LOGIC;
		 cin : in STD_LOGIC;
		 cout : out STD_LOGIC;
		 s : out STD_LOGIC
	     );
end ComboArrayMulCellNoN;

--}} End of automatically maintained section

architecture ComboArrayMulCellNoN of ComboArrayMulCellNoN is
component FullAdder is
	 port(
		 i0 : in STD_LOGIC;
		 i1 : in STD_LOGIC;
		 ci : in STD_LOGIC;
		 s : out STD_LOGIC;
		 co : out STD_LOGIC
	     );
end component;
begin
	l1: FullAdder port	map (
			i0 => x,
			i1 => y,
			ci => cin,
			co => cout,
			s => s
	);

end ComboArrayMulCellNoN;
