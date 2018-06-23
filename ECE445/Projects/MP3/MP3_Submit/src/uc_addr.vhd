-------------------------------------------------------------------------------
--
-- Title       : uc_addr
-- Design      : LC3B
-- Author      : JasonVM
-- Company     : JVM
--
-------------------------------------------------------------------------------
--
-- File        : c:\downloads\mp3\mp3_start_v2\uc_addr.vhd
-- Generated   : Sun May  3 20:08:34 2009
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
--{entity {uc_addr} architecture {uc_addr}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.lc3b_types.all;

entity uc_addr is
	 port(
		 word_offset : in lc3b_nibble;
		 ADDRESS : in lc3b_word;
		 CADDRESS_pre : out lc3b_word
	     );
end uc_addr;

--}} End of automatically maintained section

architecture uc_addr of uc_addr is
begin

	-- enter your statements here --
	CADDRESS_pre <= ADDRESS(15 downto 5) & word_offset & '0';

end uc_addr;
