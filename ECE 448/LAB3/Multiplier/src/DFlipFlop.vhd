-------------------------------------------------------------------------------
--
-- Title       : DFlipFlop
-- Design      : Multiplier
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : DFlipFlop.vhd
-- Generated   : Tue Feb 23 01:36:38 2010
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
--{entity {DFlipFlop} architecture {DFlipFlop}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DFlipFlop is
	 port(
		 D : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 Q : out STD_LOGIC
	     );
end DFlipFlop;

--}} End of automatically maintained section

architecture DFlipFlop of DFlipFlop is
begin
	Q <= D when rising_edge(CLK);

end DFlipFlop;
