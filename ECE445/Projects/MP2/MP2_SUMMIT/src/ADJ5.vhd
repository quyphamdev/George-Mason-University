-------------------------------------------------------------------------------
--
-- Title       : ADJ5
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\ADJ5.vhd
-- Generated   : Sat Jan 24 11:21:23 2009
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
--{entity {ADJ5} architecture {ADJ5}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library LC3b;
use lc3b.lc3b_types.all;

entity ADJ5 is
	 port(
		 imm5 : in lc3b_imm5;
		 Imm5Out : out lc3b_word
	     );
end ADJ5;

--}} End of automatically maintained section

architecture ADJ5 of ADJ5 is
begin

	 -- enter your statements here --
	 
	 Imm5Out<=Imm5(4)&Imm5(4)&Imm5(4)&Imm5(4)&Imm5(4)&Imm5(4)&Imm5(4)&Imm5(4)&Imm5(4)&Imm5(4)&Imm5(4)&Imm5 after delay_MUX2;
	 
	 
end ADJ5;

