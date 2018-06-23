-------------------------------------------------------------------------------
--
-- Title       : QReg
-- Design      : FIRFilter
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : QReg.vhd
-- Generated   : Sun Feb 28 13:47:12 2010
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
--{entity {QReg} architecture {QReg}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity QReg is
	generic	(N : integer := 32);
	 port(
		 p2 : in STD_LOGIC_vector(N-1 downto 0);
		 CLK : in STD_LOGIC;
		 Reset : in std_logic;
		 samp_i : in std_logic;
		 p : out STD_LOGIC_vector(N/2-1 downto 0)
	     );
end QReg;

--}} End of automatically maintained section

architecture QReg of QReg is
begin
	reg: process(CLK, Reset, samp_i)
	begin
		if Reset = '1' then
			p <= (others => '0');
		elsif rising_edge(CLK) then
			if samp_i = '1' then
				p <= p2(N/2-1 downto 0);
			end if;			
		end if;		
	end process;

end QReg;
