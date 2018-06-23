-------------------------------------------------------------------------------
--
-- Title       : BRadd
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\BRadd.vhd
-- Generated   : Sat Jan 24 11:25:07 2009
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
--{entity {BRadd} architecture {BRadd}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use ieee.numeric_std.all;
library LC3b;
use lc3b.lc3b_types.all;
entity BRadd is
	 port(
		 ADJout : in lc3b_word;
		 PCout : in lc3b_word;
		 BRaddOut : out lc3b_word
	     );
end BRadd;

--}} End of automatically maintained section

architecture BRadd of BRadd is
begin
	vhdl_BRADD_2 : process (PCout, ADJout)
	begin
	BRADDOut <= std_logic_vector(unsigned(PCout) + unsigned(ADJout)) after delay_adder;
	end process;
end BRadd;
