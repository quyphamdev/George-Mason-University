-------------------------------------------------------------------------------
--
-- Title       : ComboMultiplier
-- Design      : Multiplier
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : ComboMultiplier.vhd
-- Generated   : Sat Feb 20 16:18:00 2010
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ComboMultiplier} architecture {ComboMultiplier}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

entity ComboMultiplier is
	generic (k : integer := 4);
	 port(
		 A : in STD_LOGIC_vector(k-1 downto 0);
		 B : in STD_LOGIC_vector(k-1 downto 0);
		 Z : out STD_LOGIC_vector(k*2-1 downto 0)
	     );
end ComboMultiplier;

--}} End of automatically maintained section

architecture ComboMultiplier of ComboMultiplier is
signal temp : std_logic_vector(k*2-1 downto 0);
begin
	Z <= A * B;
end ComboMultiplier;
