-------------------------------------------------------------------------------
--
-- Title       : Test Bench for parallelfirfilter
-- Design      : FIRFilter
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\parallelfirfilter_TB.vhd
-- Generated   : 2/28/2010, 2:52 PM
-- From        : $DSN\src\ParallelFIRFilter.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for parallelfirfilter_tb
--
-------------------------------------------------------------------------------

--library FIRFilter;
use work.firpackage.all;
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity parallelfirfilter_tb is
	-- Generic declarations of the tested unit
		generic(
		N : INTEGER := 16
		);
end parallelfirfilter_tb;

architecture TB_ARCHITECTURE of parallelfirfilter_tb is
	-- Component declaration of the tested unit
	component parallelfirfilter
		generic(
		N : INTEGER := 16
		);
	port(
		CLK : in std_logic;
		Reset : in std_logic;
		samp_i : in std_logic;
		data_i : in std_logic_vector(N-1 downto 0);
		samp_o : out std_logic;
		data_o : out std_logic_vector(N-1 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : std_logic := '0';
	signal Reset : std_logic := '0';
	signal samp_i : std_logic;
	signal data_i : std_logic_vector(N-1 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal samp_o : std_logic;
	signal data_o : std_logic_vector(N-1 downto 0);

	-- Add your code here ...
	constant xin : word_vector(0 to 31) := (
	x"0001",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
	x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");

	signal cnt : std_logic_vector (4 downto 0) := (others => '0');
	
begin

	-- Unit Under Test port map
	UUT : parallelfirfilter
		generic map (
			N => N
		)

		port map (
			CLK => CLK,
			Reset => Reset,
			samp_i => samp_i,
			data_i => data_i,
			samp_o => samp_o,
			data_o => data_o
		);

	-- Add your stimulus here ...
	CLK <= not CLK after 10ns;
	
	rst: process
	begin
		Reset <= '1';
		wait for 100ns;
		Reset <= '0';
		wait;
	end process;	
	
	testing: process(CLK)
	variable i : integer := 0;
	begin
		if falling_edge(CLK) then
			if samp_o = '1' then
				samp_i <= '1';
				data_i <= std_logic_vector(xin(i));
				i := (i + 1) mod taps_size;
				cnt <= std_logic_vector( unsigned(cnt) + 1);
			elsif samp_i = '1' then
				samp_i <= '0';
			end if;			
		end if;
	end process;	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_parallelfirfilter of parallelfirfilter_tb is
	for TB_ARCHITECTURE
		for UUT : parallelfirfilter
			use entity work.parallelfirfilter(parallelfirfilter);
		end for;
	end for;
end TESTBENCH_FOR_parallelfirfilter;

