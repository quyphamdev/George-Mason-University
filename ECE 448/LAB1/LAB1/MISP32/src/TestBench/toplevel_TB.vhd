-------------------------------------------------------------------------------
--
-- Title       : Test Bench for toplevel
-- Design      : MISP32
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\toplevel_TB.vhd
-- Generated   : 2/1/2010, 4:58 AM
-- From        : $DSN\src\TopLevel.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for toplevel_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.misp32_package.all;

	-- Add your library and packages declaration here ...

entity toplevel_tb is
end toplevel_tb;

architecture TB_ARCHITECTURE of toplevel_tb is
	-- Component declaration of the tested unit
	component toplevel
	port(
		Instruction : in std_logic_vector(31 downto 0);
		Reg_B : in std_logic_vector(31 downto 0);
		Reg_A : in std_logic_vector(31 downto 0);
		Rs_addr : out std_logic_vector(4 downto 0);
		Rt_addr : out std_logic_vector(4 downto 0);
		Rd_addr : out std_logic_vector(4 downto 0);
		Result : out std_logic_vector(31 downto 0);
		Zero : out std_logic;
		RegWrite : out std_logic;
		RegDst : out std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal Instruction : std_logic_vector(31 downto 0);
	signal Reg_B : std_logic_vector(31 downto 0);
	signal Reg_A : std_logic_vector(31 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal Rs_addr : std_logic_vector(4 downto 0);
	signal Rt_addr : std_logic_vector(4 downto 0);
	signal Rd_addr : std_logic_vector(4 downto 0);
	signal Result : std_logic_vector(31 downto 0);
	signal Zero : std_logic;
	signal RegWrite : std_logic;
	signal RegDst : std_logic;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : toplevel
		port map (
			Instruction => Instruction,
			Reg_B => Reg_B,
			Reg_A => Reg_A,
			Rs_addr => Rs_addr,
			Rt_addr => Rt_addr,
			Rd_addr => Rd_addr,
			Result => Result,
			Zero => Zero,
			RegWrite => RegWrite,
			RegDst => RegDst
		);

	-- Add your stimulus here ...
	testing: process
	begin
		Reg_A <= x"00000007";
		Reg_B <= x"00000001";
		-- testing on R-type instructions
		Instruction <= "000000" & "00001" & "00010" & "00011" & "00001" & f_add;
		wait for 10 ns;
		Instruction <= "000000" & "00001" & "00010" & "00011" & "00001" & f_and;
		wait for 10 ns;
		Instruction <= "000000" & "00001" & "00010" & "00011" & "00001" & f_or;
		wait for 10 ns;
		Instruction <= "000000" & "00001" & "00010" & "00011" & "00001" & f_sub;
		wait for 10 ns;
		Instruction <= "000000" & "00001" & "00010" & "00011" & "00001" & f_xor;
		wait for 10 ns;
		Instruction <= "000000" & "00001" & "00010" & "00011" & "00001" & f_slt;
		wait for 10 ns;
		Instruction <= "000000" & "00001" & "00010" & "00011" & "00001" & f_sltu;
		wait for 10 ns;
--		Instruction <= "000000" & "00001" & "00010" & "00011" & "00011" & f_sll; -- shamt = (10 downto 6)
--		wait for 10 ns;
--		Instruction <= "000000" & "00001" & "00010" & "00011" & "00111" & f_srl; -- shamt = (10 downto 6)
--		wait for 10 ns;
--		Instruction <= "000000" & "00001" & "00010" & "00011" & "00001" & f_sllv; -- shamt in B
--		wait for 10 ns;
--		Instruction <= "000000" & "00001" & "00010" & "00011" & "00001" & f_srlv; -- shamt in B
--		wait for 10 ns;
		-- testing on I-type instructions
		Instruction <= op_addi & "00001" & "00010" & x"0007";
		wait for 10 ns;
		Instruction <= op_andi & "00001" & "00010" & x"0006";
		wait for 10 ns;
		Instruction <= op_ori & "00001" & "00010" & x"0005";
		wait for 10 ns;
		
	end process;
	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_toplevel of toplevel_tb is
	for TB_ARCHITECTURE
		for UUT : toplevel
			use entity work.toplevel(toplevel);
		end for;
	end for;
end TESTBENCH_FOR_toplevel;

