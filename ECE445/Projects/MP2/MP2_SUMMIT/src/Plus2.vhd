-------------------------------------------------------------------------------
--
-- Title       : Plus2
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\Plus2.vhd
-- Generated   : Sat Jan 24 11:25:12 2009
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
--{entity {Plus2} architecture {Plus2}}

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
library LC3b;
use lc3b.lc3b_types.all;
entity Plus2 is
	 port(
		 PCout : in lc3b_word;
		 PCplus2out : out lc3b_word
	     );
end Plus2;

--}} End of automatically maintained section


ARCHITECTURE untitled OF Plus2 IS
BEGIN
  vhdl_ADD_2 : process (PCout)
  begin  -- process

    PCPlus2out <= std_logic_vector(unsigned(PCout) + 2 ) after delay_adder;
  
  end process;
  
END untitled;
