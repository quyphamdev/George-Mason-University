-------------------------------------------------------------------------------
--
-- Title       : Ones
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\Ones.vhd
-- Generated   : Sat Jan 24 13:31:37 2009
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
--{entity {Ones} architecture {Ones}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library LC3b;
use LC3b.lc3b_types.all;

entity Ones is
	 port(
		 JumpSR : in STD_LOGIC;
		 onesout : out lc3b_reg
	     );
end Ones;

--}} End of automatically maintained section

architecture Ones of Ones is
begin
	 onesout <= JumpSR & JumpSR & JumpSR after delay_MUX2;
	 -- enter your statements here --

end Ones;
