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

entity ADJ6 is
	 port(
	 	offset9 : in lc3b_offset9;
	 	ldb1 : in std_logic;
		 ADJ6out : out lc3b_word
	     );
end ADJ6;

--}} End of automatically maintained section

architecture ADJ6 of ADJ6 is
begin
	process(ldb1,offset9)
	variable temp : lc3b_word;
	begin
		if(ldb1 = '1') then
			temp := offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5 downto 0);
		else
			temp := offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5) & offset9(5 downto 0) & '0';
		end if;		
		ADJ6out <= temp after delay_MUX2;
	end process;	   


end ADJ6;
