-------------------------------------------------------------------------------
--
-- Title       : ADJ11
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\ADJ11.vhd
-- Generated   : Sat Jan 24 14:06:27 2009
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
--{entity {ADJ11} architecture {ADJ11}}

library IEEE;
use IEEE.STD_LOGIC_1164.all; 

library lc3b;
use lc3b.lc3b_types.all;

entity ADJ11 is
	 port(
		 offset11 : in lc3b_offset11;
		 ADJ11out : out LC3b_word
	     );
end ADJ11;

--}} End of automatically maintained section

architecture ADJ11 of ADJ11 is
begin

	ADJ11out <= offset11(10) & offset11(10) & offset11(10) & offset11(10) & offset11 & '0' after delay_Mux2;

end ADJ11;
