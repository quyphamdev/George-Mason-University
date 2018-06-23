-------------------------------------------------------------------------------
--
-- Title       : IR
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\IR.vhd
-- Generated   : Sat Jan 24 11:20:34 2009
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
--{entity {IR} architecture {IR}}

library IEEE;
use IEEE.STD_LOGIC_1164.all; 

library LC3b;
use lc3b.lc3b_types.all;

entity IR is
	 port(
		   LoadIR : in STD_LOGIC;
	       MDRout : in LC3b_word;
	       clk : in STD_LOGIC;
	       Dest : out lc3b_reg;
	       Opcode : out lc3b_opcode;
	       SrcA : out lc3b_reg;
	       SrcB : out lc3b_reg;
	       bit5 : out STD_LOGIC;
	       imm5 : out lc3b_imm5;
	       offset11 : out lc3b_offset11;
	       offset9 : out lc3b_offset9
	     );
end IR;

--}} End of automatically maintained section


ARCHITECTURE untitled OF IR IS
  signal val_ir : LC3b_word;
BEGIN
  ------------------------------
  vhdl_Reg_IR : PROCESS (clk, LoadIR, MDRout)
    ------------------------------
  BEGIN
    if (clk'event and (clk = '1') and (clk'last_value = '0')) then
      if (LoadIR = '1') then
        val_ir <= MDRout after delay_reg;
      end if;
    end if;
  END PROCESS vhdl_Reg_IR;

  Opcode <= val_ir(15 downto 12);
  SrcA <= val_ir(8 downto 6);
  SrcB <= val_ir(2 downto 0);
  Dest <= val_ir(11 downto 9);
  offset9 <= val_ir(8 downto 0);
  offset11 <= val_ir(10 downto 0);
  imm5 <= val_ir(4 downto 0);
  Bit5 <= val_ir(5);

END untitled;

