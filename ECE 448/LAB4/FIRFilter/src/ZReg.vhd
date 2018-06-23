-------------------------------------------------------------------------------
--
-- Title       : ZReg
-- Design      : FIRFilter
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : ZReg.vhd
-- Generated   : Sun Feb 28 11:19:22 2010
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
--{entity {ZReg} architecture {ZReg}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ZReg is
	generic	(N : integer := 32);
	 port(
		 xhy : in STD_LOGIC_vector(N-1 downto 0);
		 CLK : in STD_LOGIC;
		 Reset : in std_logic;
		 samp_i : in std_logic;
		 y : out STD_LOGIC_vector(N-1 downto 0)
	     );
end ZReg;

--}} End of automatically maintained section

architecture ZReg of ZReg is
begin
	reg: process(CLK, Reset, samp_i)
	begin
		if Reset = '1' then
			y <= (others => '0');
		elsif rising_edge(CLK) then
			if samp_i = '1' then
				y <= xhy;
			end if;			
		end if;		
	end process;

end ZReg;
