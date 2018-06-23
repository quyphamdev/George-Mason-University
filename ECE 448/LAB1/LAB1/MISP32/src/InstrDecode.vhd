-------------------------------------------------------------------------------
--
-- Title       : InstrDecode
-- Design      : MISP32
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : InstrDecode.vhd
-- Generated   : Sat Jan 30 20:46:46 2010
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
--{entity {InstrDecode} architecture {InstrDecode}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity InstrDecode is
	 port(
		 Instruction : in STD_LOGIC_VECTOR(31 downto 0);
		 Rs_addr : out STD_LOGIC_VECTOR(4 downto 0);
		 Rt_addr : out STD_LOGIC_VECTOR(4 downto 0);
		 Rd_addr : out STD_LOGIC_VECTOR(4 downto 0);
		 opcode : out STD_LOGIC_VECTOR(5 downto 0);
		 Funct : out STD_LOGIC_VECTOR(5 downto 0);
		 Imm : out STD_LOGIC_VECTOR(15 downto 0)
	     );
end InstrDecode;

--}} End of automatically maintained section

architecture InstrDecode of InstrDecode is
begin

	-- enter your statements here --
	opcode <= Instruction(31 downto 26);
	Rs_addr <= Instruction(25 downto 21);
	Rt_addr <= Instruction(20 downto 16);
	Rd_addr <= Instruction(15 downto 11);
	Funct <= Instruction(5 downto 0);
	Imm <= Instruction(15 downto 0);

end InstrDecode;
