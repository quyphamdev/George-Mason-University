-------------------------------------------------------------------------------
--
-- Title       : Test Bench for control
-- Design      : MISP32
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\control_TB.vhd
-- Generated   : 2/2/2010, 1:43 AM
-- From        : $DSN\src\Control.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for control_tb
--
-------------------------------------------------------------------------------

library MISP32;
use work.misp32_package.all;
library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity control_tb is
end control_tb;

architecture TB_ARCHITECTURE of control_tb is
	-- Component declaration of the tested unit
	component control
	port(
		opcode : in std_logic_vector(5 downto 0);
		Funct : in std_logic_vector(5 downto 0);
		SignExt : out std_logic;
		ALUSrc : out std_logic;
		RegWrite : out std_logic;
		RegDst : out std_logic;
		ALU_OP : out std_logic_vector(3 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal opcode : std_logic_vector(5 downto 0);
	signal Funct : std_logic_vector(5 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal SignExt : std_logic;
	signal ALUSrc : std_logic;
	signal RegWrite : std_logic;
	signal RegDst : std_logic;
	signal ALU_OP : std_logic_vector(3 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : control
		port map (
			opcode => opcode,
			Funct => Funct,
			SignExt => SignExt,
			ALUSrc => ALUSrc,
			RegWrite => RegWrite,
			RegDst => RegDst,
			ALU_OP => ALU_OP
		);

	-- Add your stimulus here ...
	testing: process
	begin
--		opcode <= op_add;
--		Funct <= f_add;
--		wait for 10 ns;
--		opcode <= op_and;
--		Funct <= f_and;
--		wait for 10 ns;
--		opcode <= op_or;
--		Funct <= f_or;
--		wait for 10 ns;
--		opcode <= op_sub;
--		Funct <= f_sub;
--		wait for 10 ns;
--		opcode <= op_xor;
--		Funct <= f_xor;
--		wait for 10 ns;
--		opcode <= op_slt;
--		Funct <= f_slt;
--		wait for 10 ns;
--		opcode <= op_sltu;
--		Funct <= f_sltu;
--		wait for 10 ns;
--		opcode <= op_addi;
--		wait for 10 ns;
--		opcode <= op_andi;
--		wait for 10 ns;
--		opcode <= op_ori;
--		wait for 10 ns;
		opcode <= op_sll;
		Funct <= f_sll;
		wait for 10 ns;
		opcode <= op_srl;
		Funct <= f_srl;
		wait for 10 ns;
		opcode <= op_sllv;
		Funct <= f_sllv;
		wait for 10 ns;
		opcode <= op_srlv;
		Funct <= f_srlv;
		wait for 10 ns;

	end process;
	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_control of control_tb is
	for TB_ARCHITECTURE
		for UUT : control
			use entity work.control(control);
		end for;
	end for;
end TESTBENCH_FOR_control;

