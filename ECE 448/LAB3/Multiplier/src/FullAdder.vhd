-------------------------------------------------------------------------------
--
-- Title       : FullAdder
-- Design      : Multiplier
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : FullAdder.vhd
-- Generated   : Sat Feb 20 17:23:46 2010
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
--{entity {FullAdder} architecture {FullAdder}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FullAdder is
	 port(
		 i0 : in STD_LOGIC;
		 i1 : in STD_LOGIC;
		 ci : in STD_LOGIC;
		 s : out STD_LOGIC;
		 co : out STD_LOGIC
	     );
end FullAdder;

--}} End of automatically maintained section

architecture FullAdder of FullAdder is
begin
    --  Compute the sum.
    s <= i0 xor i1 xor ci;
    --  Compute the carry.
    co <= (i0 and i1) or (i0 and ci) or (i1 and ci);

end FullAdder;
