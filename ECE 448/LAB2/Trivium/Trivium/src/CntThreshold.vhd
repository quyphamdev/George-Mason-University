-------------------------------------------------------------------------------
--
-- Title       : CntThreshold
-- Design      : Trivium
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : CntThreshold.vhd
-- Generated   : Sat Feb  6 23:16:08 2010
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
--{entity {CntThreshold} architecture {CntThreshold}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

entity CntThreshold is
	generic	(T : integer := 79);
	 port(
		 Counter : in STD_LOGIC_VECTOR(10 downto 0);
		 lte : out STD_LOGIC
	     );
end CntThreshold;

--}} End of automatically maintained section

architecture CntThreshold of CntThreshold is
begin

	-- enter your statements here --
	lte <= '1' when Counter <= T else '0';

end CntThreshold;
