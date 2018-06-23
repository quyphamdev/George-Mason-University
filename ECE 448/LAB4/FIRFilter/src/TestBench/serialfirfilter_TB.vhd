-------------------------------------------------------------------------------
--
-- Title       : Test Bench for serialfirfilter
-- Design      : FIRFilter
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\serialfirfilter_TB.vhd
-- Generated   : 3/2/2010, 10:12 PM
-- From        : $DSN\src\SerialFIRFilter.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for serialfirfilter_tb
--
-------------------------------------------------------------------------------

--library FIRFilter;
use work.firpackage.all;
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity serialfirfilter_tb is
	-- Generic declarations of the tested unit
		generic(
		N : INTEGER := 16 );
end serialfirfilter_tb;

architecture TB_ARCHITECTURE of serialfirfilter_tb is
	-- Component declaration of the tested unit
	component serialfirfilter
		generic(
		N : INTEGER := 16 );
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
	UUT : serialfirfilter
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

configuration TESTBENCH_FOR_serialfirfilter of serialfirfilter_tb is
	for TB_ARCHITECTURE
		for UUT : serialfirfilter
			use entity work.serialfirfilter(serialfirfilter);
		end for;
	end for;
end TESTBENCH_FOR_serialfirfilter;

