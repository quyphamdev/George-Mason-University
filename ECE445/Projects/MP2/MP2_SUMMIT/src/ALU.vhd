-------------------------------------------------------------------------------
--
-- Title       : ALU
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\ALU.vhd
-- Generated   : Sat Jan 24 11:24:48 2009
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
--{entity {ALU} architecture {ALU}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use ieee.numeric_std.all;

library LC3b;
use lc3b.lc3b_types.all;

entity ALU is
	 port(
		 RFAout : in lc3b_word;
		 ALUmuxOut : in lc3b_word;
		 ALUop : in lc3b_aluop;
		 ALUout : out lc3b_word
	     );
end ALU;

--}} End of automatically maintained section


ARCHITECTURE untitled OF ALU IS
BEGIN
  ----------------------------------------
  vhdl_ALU : PROCESS (RFAout, ALUMuxout, ALUop)
    ----------------------------------------
    variable Temp_ALUOut : LC3b_word;
  BEGIN
    
    -- check for ALU operation type, and execute
    case ALUop is
      when alu_add =>
        Temp_ALUOut := std_logic_vector(signed(RFAout) + signed(ALUMuxout));
      when alu_and =>
        Temp_ALUOut := (RFAout AND ALUMuxout);
      when alu_not =>
        Temp_ALUOut := (RFAout XOR "1111111111111111");
      when alu_pass =>
	  	Temp_ALUOut := (RFAout);
	  when alu_shf =>
	  	Temp_ALUOut := (ALUMuxout);
	  when alu_ldr =>
	  	Temp_ALUOut := std_logic_vector(unsigned(RFAout) + unsigned(ALUMuxout));
      when others =>
    end case;

    ALUout <= Temp_ALUOut after delay_ALU;

  END PROCESS vhdl_ALU;

END untitled;

