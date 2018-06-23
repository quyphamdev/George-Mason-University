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

entity ldbyte is
	 port(
	 	b16 : in lc3b_word;
	 	LDBSel : in std_logic;
		 w8 : out lc3b_word
	     );
end ldbyte;

--}} End of automatically maintained section

architecture ldbyte of ldbyte is
begin
	process(LDBSel,b16)
	begin
		if(LDBSel = '1') then
		   w8 <= "00000000" & b16(7 downto 0) after delay_MUX2;
		else
			w8 <= b16 after delay_MUX2;
		end if;
	end process;		
end ldbyte;
