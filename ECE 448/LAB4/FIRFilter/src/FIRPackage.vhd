-------------------------------------------------------------------------------
--
-- Title       : FIRPackage
-- Design      : FIRFilter
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : FIRPackage.vhd
-- Generated   : Sun Feb 28 11:28:07 2010
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
--{entity {FIRPackage} architecture {FIRPackage}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package	FIRPackage is
	constant taps_size : integer := 32;
	type word_vector is array (natural range <>) of signed(15 downto 0);
	
	-- ramp
--	constant taps : word_vector(0 to taps_size-1) := (
--	x"0001",x"0002",x"0003",x"0004",x"0005",x"0006",x"0007",x"0008",
--	x"0009",x"000A",x"000B",x"000C",x"000D",x"000E",x"000F",x"0010",
--	x"0011",x"0012",x"0013",x"0014",x"0015",x"0016",x"0017",x"0018",
--	x"0019",x"001A",x"001B",x"001C",x"001D",x"001E",x"001F",x"0020");

	-- sinc
	constant taps : word_vector(0 to taps_size-1) := (
	x"0000",x"FA91",x"0000",x"0645",x"0000",x"F898",x"0000",x"090E",
	x"0000",x"F45C",x"0000",x"104C",x"0000",x"E4D6",x"0000",x"517D",
	x"7FFF",x"517D",x"0000",x"E4D6",x"0000",x"104C",x"0000",x"F45C",
	x"0000",x"090E",x"0000",x"F898",x"0000",x"0645",x"0000",x"FA91");
	
end package;

