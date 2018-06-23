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
use ieee.numeric_std.all;

entity shift is
	 port(
		 A : in std_logic;
		 imm5 : in lc3b_imm5;
		 RFAout : in lc3b_word;
		 SHFout : out LC3b_word
	     );
end shift;

--}} End of automatically maintained section

architecture shift of shift is
begin
	process(A,imm5,RFAout)
		variable temp : lc3b_word;
		variable zeros, arith : lc3b_word;
		variable D : std_logic;
		variable shamt : integer;
		variable b15 : std_logic;
	begin		
		zeros := "0000000000000000";
		b15 := RFAout(15); -- save bit sign for arithmetic shift
		arith := b15 & b15 & b15 & b15 & b15 & b15 & b15 & b15 & b15 & b15 & b15 & b15 & b15 & b15 & b15 & b15;
		D := imm5(4);
		shamt := to_Integer(unsigned('0' & imm5(3 downto 0)));
		if((D = '0')and(shamt /= 0)) then -- shift left
			temp := RFAout((15-shamt) downto 0) & zeros((shamt-1) downto 0);
		elsif((D = '1')and(shamt /= 0)) then
			-- shift right					
			if(A = '0') then -- shift right logical
				temp := zeros((shamt-1) downto 0) & RFAout(15 downto shamt);
			else -- shift right arithmetic
				temp := arith((shamt-1) downto 0) & RFAout(15 downto shamt);
			end if;
		else
			temp := RFAout;
		end if;
		SHFout <= temp after delay_MUX2;	
	end process;	

end shift;
