-------------------------------------------------------------------------------
--
-- Title       : wordmux2
-- Design      : LC3b
-- Author      : Lab01
-- Company     : Lab
--
-------------------------------------------------------------------------------
--
-- File        : wordmux2.vhd
-- Generated   : Sat Feb 14 23:55:00 2009
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
--{entity {wordmux2} architecture {wordmux2}}

-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;
library LC3b;
use LC3b.LC3b_types.all;

entity wordmux2 is
  port(
       A : in LC3b_word;
       B : in LC3b_word;
       SEL : in STD_LOGIC;
       F : out LC3b_word
  );
end wordmux2;

ARCHITECTURE wordmux2 OF wordmux2 IS
BEGIN
	PROCESS (A, B, sel)
variable state : LC3b_word;
BEGIN
case sel IS
when '0' =>
state := A;
when '1' =>
state := B;
when others =>
state := (OTHERS => 'X');
end case;
F <= state after delay_MUX2;
	END PROCESS;
END wordmux2;
