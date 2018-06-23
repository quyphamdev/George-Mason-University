-------------------------------------------------------------------------------
--
-- Title       : mux2
-- Design      : MISP32
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : mux2.vhd
-- Generated   : Sun Jan 31 02:11:57 2010
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
--{entity {mux2} architecture {mux2}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux2 is
	 port(
		 Reg_B : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ExtImm : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Mux2Sel : in STD_LOGIC;
		 Mux2Out : out STD_LOGIC_VECTOR(31 DOWNTO 0)
	     );
end mux2;

--}} End of automatically maintained section

architecture mux2 of mux2 is
begin

	-- enter your statements here --
	Mux2Out <= ExtImm when Mux2Sel = '1' else Reg_B;

end mux2;
