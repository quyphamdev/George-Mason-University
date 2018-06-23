-------------------------------------------------------------------------------
--
-- Title       : Test Bench for fifo
-- Design      : lab5
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\fifo_TB.vhd
-- Generated   : 4/4/2010, 12:28 AM
-- From        : z:\ECE448\Lab5\ipcore_dir\FIFO.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for fifo_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity fifo_tb is
end fifo_tb;

architecture TB_ARCHITECTURE of fifo_tb is
	-- Component declaration of the tested unit
	component fifo
	port(
		din : in std_logic_vector(7 downto 0);
		rd_clk : in std_logic;
		rd_en : in std_logic;
		wr_clk : in std_logic;
		wr_en : in std_logic;
		dout : out std_logic_vector(7 downto 0);
		empty : out std_logic;
		full : out std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal din : std_logic_vector(7 downto 0);
	signal rd_clk : std_logic;
	signal rd_en : std_logic;
	signal wr_clk : std_logic;
	signal wr_en : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal dout : std_logic_vector(7 downto 0);
	signal empty : std_logic;
	signal full : std_logic;

	-- Add your code here ...
	constant clkp : time := 40ns;

begin

	-- Unit Under Test port map
	UUT : fifo
		port map (
			din => din,
			rd_clk => rd_clk,
			rd_en => rd_en,
			wr_clk => wr_clk,
			wr_en => wr_en,
			dout => dout,
			empty => empty,
			full => full
		);

	-- Add your stimulus here ...
	-- Clock process definitions
   clk_process :process
   begin
		rd_clk <= '0';
		wait for clkp*50;
		rd_clk <= '1';
		wait for clkp*50;
   end process;
   
   

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_fifo of fifo_tb is
	for TB_ARCHITECTURE
		for UUT : fifo
			use entity work.fifo(fifo_a);
		end for;
	end for;
end TESTBENCH_FOR_fifo;

