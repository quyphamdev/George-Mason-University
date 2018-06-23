-------------------------------------------------------------------------------
--
-- Title       : NZP
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\NZP.vhd
-- Generated   : Sat Jan 24 11:24:05 2009
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
--{entity {NZP} architecture {NZP}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library LC3b;
use lc3b.lc3b_types.all;

entity NZP is
	 port(
		 GenCCout : in lc3b_cc;
		 clk : in STD_LOGIC;
		 LoadNZP : in STD_LOGIC;
		 N : out STD_LOGIC;
		 Z : out STD_LOGIC;
		 P : out STD_LOGIC
	     );
end NZP;

--}} End of automatically maintained section


ARCHITECTURE untitled OF NZP IS
  signal pre_NZP : std_logic_vector (2 downto 0);
BEGIN
  ------------------------------
  vhdl_NZP : PROCESS (clk, GenCCout)
    ------------------------------
  BEGIN
    if (clk'event and (clk = '1') and (clk'last_value = '0')) then
      if (LoadNZP = '1') then
        pre_NZP <= GenCCout;
      end if;
    end if;
  END PROCESS vhdl_NZP;
  
  n <= pre_NZP(2) after delay_reg;
  z <= pre_NZP(1) after delay_reg;
  p <= pre_NZP(0) after delay_reg;

END untitled;
