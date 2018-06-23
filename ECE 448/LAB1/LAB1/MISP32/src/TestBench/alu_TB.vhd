-------------------------------------------------------------------------------
--
-- Title       : Test Bench for alu
-- Design      : MISP32
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\alu_TB.vhd
-- Generated   : 2/2/2010, 1:57 AM
-- From        : $DSN\src\alu.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for alu_tb
--
-------------------------------------------------------------------------------

library MISP32;
use MISP32.misp32_package.all;
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity alu_tb is
end alu_tb;

architecture TB_ARCHITECTURE of alu_tb is
	-- Component declaration of the tested unit
	component alu
	port(
		ALU_OP : in std_logic_vector(3 downto 0);
		A : in std_logic_vector(31 downto 0);
		B : in std_logic_vector(31 downto 0);
		Result : out std_logic_vector(31 downto 0);
		Zero : out std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal ALU_OP : std_logic_vector(3 downto 0);
	signal A : std_logic_vector(31 downto 0);
	signal B : std_logic_vector(31 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal Result : std_logic_vector(31 downto 0);
	signal Zero : std_logic;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : alu
		port map (
			ALU_OP => ALU_OP,
			A => A,
			B => B,
			Result => Result,
			Zero => Zero
		);

	-- Add your stimulus here ...
	testing: process
	begin
		A <= x"00000007";
		B <= x"00000232";
--		ALU_OP <= alu_add;
--		wait for 10 ns;
--		ALU_OP <= alu_and;
--		wait for 10 ns;
--		ALU_OP <= alu_or;
--		wait for 10 ns;
--		ALU_OP <= alu_sub;
--		wait for 10 ns;
--		ALU_OP <= alu_xor;
--		wait for 10 ns;
--		ALU_OP <= alu_slt;
--		wait for 10 ns;
--		ALU_OP <= alu_sltu;
--		wait for 10 ns;
--		ALU_OP <= alu_addi;
--		wait for 10 ns;
--		ALU_OP <= alu_andi;
--		wait for 10 ns;
--		ALU_OP <= alu_ori;
--		wait for 10 ns;
		ALU_OP <= alu_sll;
		wait for 10 ns;
		ALU_OP <= alu_srl;
		wait for 10 ns;
		ALU_OP <= alu_sllv;
		wait for 10 ns;
		ALU_OP <= alu_srlv;
		wait for 10 ns;
		
	end process;
	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_alu of alu_tb is
	for TB_ARCHITECTURE
		for UUT : alu
			use entity work.alu(alu);
		end for;
	end for;
end TESTBENCH_FOR_alu;

