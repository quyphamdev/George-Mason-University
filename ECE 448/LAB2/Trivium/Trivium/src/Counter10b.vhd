-------------------------------------------------------------------------------
--
-- Title       : Counter10b
-- Design      : Trivium
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : Counter10b.vhd
-- Generated   : Sun Feb  7 03:51:43 2010
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
--{entity {Counter10b} architecture {Counter10b}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

entity Counter10b is
	generic	(N : integer := 10);
	 port(
		 RST : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 En : in STD_LOGIC;
		 CounterOut : out STD_LOGIC_VECTOR(N downto 0)
	     );
end Counter10b;

--}} End of automatically maintained section

architecture Counter10b of Counter10b is
signal Count : std_logic_vector	(N downto 0);
begin

	-- enter your statements here --
	process(En,RST,CLK)
	begin		
		if (RST = '1')then
			Count <= (others => '0');
		elsif rising_edge(CLK) then
			if En = '1' then
				Count <= Count + 1;
			end if;			
		end if;		
	end process;
	CounterOut <= Count;

end Counter10b;
