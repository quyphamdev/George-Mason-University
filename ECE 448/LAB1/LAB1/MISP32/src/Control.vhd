-------------------------------------------------------------------------------
--
-- Title       : Control
-- Design      : MISP32
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : Control.vhd
-- Generated   : Sat Jan 30 21:32:52 2010
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
--{entity {Control} architecture {Control}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.misp32_package.all;

entity Control is
	 port(
		 opcode : in STD_LOGIC_VECTOR(5 DOWNTO 0);
		 Funct : in STD_LOGIC_VECTOR(5 DOWNTO 0);
		 SignExt : out STD_LOGIC;
		 ALUSrc : out STD_LOGIC;
		 RegWrite : out STD_LOGIC;
		 RegDst : out STD_LOGIC;
		 ALU_OP : out STD_LOGIC_VECTOR(3 DOWNTO 0)
	     );
end Control;

--}} End of automatically maintained section

architecture Control of Control is
begin

	-- enter your statements here --	
	process(opcode, Funct)
	variable s_ShfSel : integer;
	begin		
		s_ShfSel := 0;
		if(opcode = "000000") then -- R-type instructions			
			case Funct is
				when f_add => ALU_OP <= alu_add;				
				when f_and => ALU_OP <= alu_and;
				when f_or => ALU_OP <= alu_or;
				when f_sub => ALU_OP <= alu_sub;
				when f_xor => ALU_OP <= alu_xor;
				when f_slt => ALU_OP <= alu_slt;
				when f_sltu => ALU_OP <= alu_sltu;
				when f_sll => ALU_OP <= alu_sll; s_ShfSel := 1;
				when f_srl => ALU_OP <= alu_srl; s_ShfSel := 1;
				when f_sllv => ALU_OP <= alu_sllv;
				when f_srlv => ALU_OP <= alu_srlv;
				when others => ALU_OP <= alu_nop;
			end case;
			SignExt <= '0';
			if s_ShfSel = 1 then
				ALUSrc <= '1'; -- mux sel; Imm contains shift amount
			else
				ALUSrc <= '0';
			end if;			
			RegDst <= '1'; -- result is stored in Rd. '0' if result store in Rt			
		else -- I-type instructions
			case opcode is
				when op_addi => ALU_OP <= alu_addi;
				when op_andi => ALU_OP <= alu_andi;
				when op_ori => ALU_OP <= alu_ori;
				when others => ALU_OP <= alu_ori;
			end case;
			SignExt <= '1'; -- sign extend
			ALUSrc <= '1'; -- mux sel; pass immediate to ALU instead of reg_b
			RegDst <= '0'; -- result is stored in Rt
		end if;
		RegWrite <= '1'; -- result is stored in register
		
	end process;
	
	

end Control;
