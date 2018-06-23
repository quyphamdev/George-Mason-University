-------------------------------------------------------------------------------
--
-- Title       : GenCC
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\GenCC.vhd
-- Generated   : Sat Jan 24 11:23:55 2009
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
--{entity {GenCC} architecture {GenCC}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library LC3b;
use lc3b.lc3b_types.all;

entity GenCC is
	 port(
		 RFMuxOut : in lc3b_word;
		 GenCCout : out lc3b_cc
	     );
end GenCC;

--}} End of automatically maintained section

architecture GenCC of GenCC is
begin
  vhdl_GenCC : process (RFMuxout)
  begin    
	IF (RFMuxout = "0000000000000000") then
          GenCCout <= "010" after 6 ns;
        ELSIF (RFMuxout(15) = '1') then
          GenCCout <= "100" after 6 ns;
	ELSE
          GenCCout <= "001" after 6 ns;
        end IF;
  end process vhdl_GenCC;
end GenCC;
