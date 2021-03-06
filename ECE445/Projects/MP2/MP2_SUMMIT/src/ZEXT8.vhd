-------------------------------------------------------------------------------
--
-- Title       : ADJ9
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\ADJ9.vhd
-- Generated   : Sat Jan 24 11:22:28 2009
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
--{entity {ADJ9} architecture {ADJ9}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library LC3b;
use lc3b.lc3b_types.all;

entity ZEXT8 is
	 port(
		 offset9 : in lc3b_offset9;
		 Zext8Out : out lc3b_word
	     );
end ZEXT8;

--}} End of automatically maintained section

architecture ZEXT8 of ZEXT8 is
begin

	   Zext8Out <= "0000000" & offset9(7 downto 0) & '0' after delay_MUX2;


end ZEXT8;
