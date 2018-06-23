-------------------------------------------------------------------------------
--
-- Title       : NZPSplit
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\NZPSplit.vhd
-- Generated   : Sat Jan 24 11:24:16 2009
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
--{entity {NZPSplit} architecture {NZPSplit}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library LC3b;
use lc3b.lc3b_types.all;

entity NZPSplit is
	 port(
		 JSRMuxOut : in lc3b_reg;
		 CheckN : out STD_LOGIC;
		 CheckP : out STD_LOGIC;
		 CheckZ : out STD_LOGIC
	     );
end NZPSplit;

--}} End of automatically maintained section


ARCHITECTURE untitled OF NZPsplit IS
BEGIN
   CheckN <= JSRMuxOut(2);
   CheckZ <= JSRMuxOut(1);
   CheckP <= JSRMuxOut(0);
END untitled;
