-------------------------------------------------------------------------------
--
-- Title       : Test Bench for rx
-- Design      : lab5
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\rx_TB.vhd
-- Generated   : 4/2/2010, 1:49 AM
-- From        : Z:\ECE448\Lab5\rx.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for rx_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

	-- Add your library and packages declaration here ...

entity rx_tb is
end rx_tb;

architecture TB_ARCHITECTURE of rx_tb is
	-- Component declaration of the tested unit
	component rx
	port(
		rxd : in std_logic;
		rx_clk : in std_logic;
		reset : in std_logic;
		data8 : out std_logic_vector(7 downto 0);
		wr_en : out std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal rxd : std_logic;
	signal rx_clk : std_logic;
	signal reset : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal data8 : std_logic_vector(7 downto 0);
	signal wr_en : std_logic;

	-- Add your code here ...
	signal data : std_logic_vector(47 downto 0) := x"7E777E7E777E";
	signal clk : std_logic := '0';
	signal clk_180 : std_logic := '1';

begin

	-- Unit Under Test port map
	UUT : rx
		port map (
			rxd => rxd,
			rx_clk => rx_clk,
			reset => reset,
			data8 => data8,
			wr_en => wr_en
		);

	-- Add your stimulus here ...
	-- Clock process definitions
   clk0_process :process
   begin
	   clk <= '0';
	   rx_clk <= '1';
		wait for 10ns;
		clk <= '1';
		rx_clk <= '0';
		wait for 10ns;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
		reset <= '1';
      wait for 100ns;	
		reset <= '0';

      wait;
   end process;
	
   tx_test: process(clk,reset)
   variable	i : integer := 47;
   variable	txbit : std_logic := '0';
   begin
	   if reset = '1' then
		   rxd <= '0';
		elsif rising_edge(clk) and reset = '0' then
			if data(i) = '0' then
				txbit := not txbit;
			end if;
			rxd <= txbit;
			i := i - 1;
			if i < 0 then
				i := 47;
			end if;
		end if;
	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_rx of rx_tb is
	for TB_ARCHITECTURE
		for UUT : rx
			use entity work.rx(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_rx;

