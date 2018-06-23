-------------------------------------------------------------------------------
--
-- Title       : alu
-- Design      : MISP32
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : alu.vhd
-- Generated   : Sat Jan 30 21:54:57 2010
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
--{entity {alu} architecture {alu}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.misp32_package.all;

entity alu is
	 port(
		 ALU_OP : in STD_LOGIC_VECTOR(3 DOWNTO 0);
		 A : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 B : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Result : out STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Zero : out STD_LOGIC
	     );
end alu;

--}} End of automatically maintained section

architecture alu of alu is

signal r_add : std_logic_vector(31 downto 0);
signal r_and : std_logic_vector(31 downto 0);
signal r_or : std_logic_vector(31 downto 0);
signal r_sub : std_logic_vector(31 downto 0);
signal r_xor : std_logic_vector(31 downto 0);
signal r_slt : std_logic_vector(31 downto 0);
signal r_sltu : std_logic_vector(31 downto 0);
signal r_addi : std_logic_vector(31 downto 0);
signal r_andi : std_logic_vector(31 downto 0);
signal r_ori : std_logic_vector(31 downto 0);
signal r_sll : std_logic_vector(31 downto 0);
signal r_srl : std_logic_vector(31 downto 0);
signal r_sllv : std_logic_vector(31 downto 0);
signal r_srlv : std_logic_vector(31 downto 0);
signal shamt : std_logic_vector(4 downto 0);
signal tmp_out : std_logic_vector(31 downto 0);
signal zeros : std_logic_vector (31 downto 0) := (others => '0');
begin

	-- enter your statements here --
	r_add <= std_logic_vector(signed(A) + signed(B));
	r_and <= A and B;
	r_or	<= A or B;
	r_sub <= std_logic_vector(signed(A) - signed(B));
	r_xor <= A xor B;
	r_slt <= (others => '1') when signed(A) < signed(B) else (others => '0');
	r_sltu <= (others => '1') when unsigned(A) < unsigned(B) else (others => '0');
	r_addi <= r_add;
	r_andi <= r_and;
	r_ori <= r_or;
	shamt <= B(10 downto 6);
	r_sll <= A((31 - to_Integer(unsigned(shamt))) downto 0) & zeros((to_Integer(unsigned(shamt)) - 1) downto 0);
	r_srl <= zeros((to_Integer(unsigned(shamt)) - 1) downto 0) & A(31 downto to_Integer(unsigned(shamt)));
	r_sllv <= A((31 - to_Integer(unsigned(B))) downto 0) & zeros((to_Integer(unsigned(B)) - 1) downto 0) when unsigned(B) < 33 else (others => '0');
	r_srlv <= zeros((to_Integer(unsigned(B)) - 1) downto 0) & A(31 downto to_Integer(unsigned(B))) when unsigned(B) < 33 else (others => '0');
	
	with ALU_OP select
		tmp_out <= 	r_add when alu_add, -- or alu_addi. because (alu_add = alu_addi)
					r_and when alu_and, -- or alu_andi
					r_or when alu_or, -- or alu_ori
					r_sub when alu_sub,
					r_xor when alu_xor,
					r_slt when alu_slt,
					r_sltu when alu_sltu,
					r_sll when alu_sll,
					r_srl when alu_srl,
					r_sllv when alu_sllv,
					r_srlv when alu_srlv,
					A when others;
	
	Zero <= '1' when unsigned(tmp_out) = 0 else '0';
	Result <= tmp_out;
	
end alu;
