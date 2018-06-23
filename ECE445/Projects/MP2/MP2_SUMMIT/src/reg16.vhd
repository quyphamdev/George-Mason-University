-------------------------------------------------------------------------------
--
-- Title       : reg16
-- Design      : LC3b
-- Author      : Lab01
-- Company     : Lab
--
-------------------------------------------------------------------------------
--
-- File        : reg16.vhd
-- Generated   : Sat Feb 14 23:58:07 2009
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
--{entity {reg16} architecture {reg16}}

library IEEE;
use IEEE.std_logic_1164.all;
library LC3b;
use LC3b.LC3b_types.all;

entity reg16 is
  port(
       CLK : in STD_LOGIC;
       Input : in LC3b_word;
       LOAD : in STD_LOGIC;
       Reset : in STD_LOGIC;
       Output : out LC3b_word
  );
end reg16;

ARCHITECTURE reg16 OF reg16 IS
Signal pre_out :LC3b_word;
begin
process (clk, reset )
begin
if reset = '0' then
pre_out <= (others => '0');
elsif clk'event and clk ='1' then
if (load = '1') then
pre_out <= input;
end if;
end if;
end process;
output <= pre_out after delay_reg;
END reg16;