-------------------------------------------------------------------------------
--
-- Title       : extend
-- Design      : MISP32
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : extend.vhd
-- Generated   : Sat Jan 30 21:01:53 2010
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
--{entity {extend} architecture {extend}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;

entity extend is
	 port(
		 Imm : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		 SignExt : in STD_LOGIC;
		 Extended : out STD_LOGIC_VECTOR(31 DOWNTO 0)
	     );
end extend;

--}} End of automatically maintained section

architecture extend of extend is
signal upper16 : std_logic_vector(15 downto 0);
begin

	-- enter your statements here --
	upper16 <= (others => '0') when SignExt = '0' else (others => imm(15));
	Extended <= upper16 & Imm;

end extend;
