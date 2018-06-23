-------------------------------------------------------------------------------
--
-- Title       : JSRMux
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\JSRMux.vhd
-- Generated   : Sat Jan 24 13:34:28 2009
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
--{entity {JSRMux} architecture {JSRMux}}

library IEEE;
use IEEE.STD_LOGIC_1164.all; 

library LC3b;
use lc3b.lc3b_types.all;

entity JSRMux is
	 port(
		 onesout : in lc3b_reg;
		 Dest : in lc3b_reg;
		 JumpSR : in STD_LOGIC;
		 JSRMuxOut : out LC3b_reg
	     );
end JSRMux;

--}} End of automatically maintained section

architecture JSRMux of JSRMux is
begin
	 JSRMuxOut <= onesout when JumpSR = '1' else Dest after delay_MUX2;

end JSRMux;
