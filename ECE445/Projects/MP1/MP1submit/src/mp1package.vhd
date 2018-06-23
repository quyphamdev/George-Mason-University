-- Package file for MP1, ECE-445 Spring 2009
-- George Mason University
-- Version 3.1
--
-- Contains : LC3b_types, instruction definitions, and time delays for simulation
--
-- based on LC3 imlementation by Seth Herstad and Greg Muthler 
-- at the University of Illinois
--
-- 2007.09.09

LIBRARY ieee ;
USE ieee.std_logic_1164.all;

PACKAGE LC3b_types IS
-- Signal widths
	SUBTYPE LC3b_nibble  	IS std_logic_vector( 3 downto 0);
	SUBTYPE LC3b_byte 		IS std_logic_vector( 7 downto 0);
	SUBTYPE LC3b_word 		IS std_logic_vector(15 downto 0);
	SUBTYPE LC3b_aluop 		IS std_logic_vector( 2 downto 0);
	SUBTYPE LC3b_reg 		IS std_logic_vector( 2 downto 0);
	SUBTYPE LC3b_imm5 		is std_logic_vector( 4 downto 0);
	SUBTYPE LC3b_offset9 	IS std_logic_vector( 8 downto 0);
	SUBTYPE LC3b_offset11	IS std_logic_vector( 10 downto 0);
	SUBTYPE LC3b_index6 	IS std_logic_vector( 5 downto 0);
	SUBTYPE LC3b_trapvect8 	IS std_logic_vector( 7 downto 0);
	SUBTYPE LC3b_opcode 	IS std_logic_vector( 3 downto 0);
    subtype LC3b_cc 		is std_logic_vector( 2 downto 0);

-- Instruction definitions
	constant op_br        : LC3b_opcode := "0000";
	constant op_add       : LC3b_opcode := "0001";
	constant op_jsr       : LC3b_opcode := "0100";
	constant op_and       : LC3b_opcode := "0101";	
	constant op_jmp       : LC3b_opcode := "1100";
		
	constant alu_add      : LC3b_aluop := "000";
	constant alu_and      : LC3b_aluop := "001";
	constant alu_not      : LC3b_aluop := "010";
	constant alu_pass     : LC3b_aluop := "011";

-- Time delays (added for ease of use)
	constant delay_ALU 			: time := 15 ns;
	constant delay_ALU_ctrl 	: time := 5 ns;
	constant delay_adder 		: time := 5 ns;
	constant delay_regfile_read : time := 8 ns;
	constant delay_reg 			: time := 4 ns;
	constant delay_MUX2 		: time := 2 ns;

END LC3b_types ;
