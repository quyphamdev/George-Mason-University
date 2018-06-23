-------------------------------------------------------------------------------
--
-- Title       : misp32_package
-- Design      : MISP32
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : misp32_package.vhd
-- Generated   : Sat Jan 30 21:44:29 2010
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
--{entity {misp32_package} architecture {misp32_package}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package	misp32_package is
	-- ALU constants
	constant alu_add : std_logic_vector(3 downto 0) := "0010";
	constant alu_and : std_logic_vector(3 downto 0) := "0000";
	constant alu_or : std_logic_vector(3 downto 0) := "0001";
	constant alu_sub : std_logic_vector(3 downto 0) := "0110";
	constant alu_xor : std_logic_vector(3 downto 0) := "0100";
	constant alu_slt : std_logic_vector(3 downto 0) := "0111";
	constant alu_sltu : std_logic_vector(3 downto 0) := "1110";
	constant alu_addi : std_logic_vector(3 downto 0) := "0010";
	constant alu_andi : std_logic_vector(3 downto 0) := "0000";
	constant alu_ori : std_logic_vector(3 downto 0) := "0001";	
	constant alu_sll : std_logic_vector(3 downto 0) := "1010"; -- changed, was "1110" same as sltu
	constant alu_srl : std_logic_vector(3 downto 0) := "1111";
	constant alu_sllv : std_logic_vector(3 downto 0) := "1000";
	constant alu_srlv : std_logic_vector(3 downto 0) := "1001";
	constant alu_nop : std_logic_vector(3 downto 0) := "1011";
	
	-- R-type function constants
	constant f_add : std_logic_vector(5 downto 0) := "100000";
	constant f_and : std_logic_vector(5 downto 0) := "100100";
	constant f_or : std_logic_vector(5 downto 0) := "100101";
	constant f_sub : std_logic_vector(5 downto 0) := "100010";
	constant f_xor : std_logic_vector(5 downto 0) := "100110";
	constant f_slt : std_logic_vector(5 downto 0) := "101010";
	constant f_sltu : std_logic_vector(5 downto 0) := "101011";
	constant f_sll : std_logic_vector(5 downto 0) := "000000";
	constant f_srl : std_logic_vector(5 downto 0) := "000001";
	constant f_sllv : std_logic_vector(5 downto 0) := "000100";
	constant f_srlv : std_logic_vector(5 downto 0) := "000110";
	
	-- R-type opcode
	constant op_add : std_logic_vector(5 downto 0) := "000000";
	constant op_and : std_logic_vector(5 downto 0) := "000000";
	constant op_or : std_logic_vector(5 downto 0) := "000000";
	constant op_sub : std_logic_vector(5 downto 0) := "000000";
	constant op_xor : std_logic_vector(5 downto 0) := "000000";
	constant op_slt : std_logic_vector(5 downto 0) := "000000";
	constant op_sltu : std_logic_vector(5 downto 0) := "000000";
	constant op_sll : std_logic_vector(5 downto 0) := "000000";
	constant op_srl : std_logic_vector(5 downto 0) := "000000";
	constant op_sllv : std_logic_vector(5 downto 0) := "000000";
	constant op_srlv : std_logic_vector(5 downto 0) := "000000";
	
	-- I-type opcode
	constant op_addi : std_logic_vector(5 downto 0) := "001000";
	constant op_andi : std_logic_vector(5 downto 0) := "001100";
	constant op_ori : std_logic_vector(5 downto 0) := "001101";
	
end package;	
