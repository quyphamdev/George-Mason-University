-------------------------------------------------------------------------------
--
-- Title       : Test Bench for toplevel
-- Design      : lab5
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\toplevel_TB.vhd
-- Generated   : 4/3/2010, 3:28 AM
-- From        : $DSN\src\toplevel.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for toplevel_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

	-- Add your library and packages declaration here ...

entity toplevel_tb is
end toplevel_tb;

architecture TB_ARCHITECTURE of toplevel_tb is
	-- Component declaration of the tested unit
	component toplevel
	port(
		clk : in std_logic;
		data_in : in std_logic_vector(7 downto 0);
		reset : in std_logic;
		tx_en : in std_logic;
		data_out : out std_logic_vector(7 downto 0);
		wr_en : out std_logic );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : std_logic := '0';
	signal data_in : std_logic_vector(7 downto 0);
	signal reset : std_logic := '0';
	signal tx_en : std_logic;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal data_out : std_logic_vector(7 downto 0);
	signal wr_en : std_logic;

	-- Add your code here ...
	signal data : std_logic_vector(47 downto 0) := x"772233997799";

begin

	-- Unit Under Test port map
	UUT : toplevel
		port map (
			clk => clk,
			data_in => data_in,
			reset => reset,
			tx_en => tx_en,
			data_out => data_out,
			wr_en => wr_en
		);

	-- Add your stimulus here ...
	-- Clock process definitions
   clk0_process :process
   begin
		clk <= '0';
		wait for 10ns;
		clk <= '1';
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
   
   ts: process
   begin
	   wait for 200ns;
	   data_in <= x"7E";
	   tx_en <= '1';
	   wait for 20ns;
	   tx_en <= '0';
	   wait for 300ns;
	   data_in <= x"7F";
	   tx_en <= '1';
	   wait for 20ns;
	   tx_en <= '0';
	   wait;
	end process;
   
--   tx_test: process(reset,clk)
--   variable	i : integer;
--   variable	v : std_logic_vector(7 downto 0);
--	begin
--		if reset = '1' then
--			i := 0;
--			tx_en <= '0';
--			v := x"77";
--		elsif rising_edge(clk) then
--			if wr_en = '1' or i = 0 then
--				data_in <= v + i;
--				tx_en <= '1';
--				i := i + 1;
--			else
--				tx_en <= '0';
--			end if;
--		end if;
--	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_toplevel of toplevel_tb is
	for TB_ARCHITECTURE
		for UUT : toplevel
			use entity work.toplevel(toplevel);
		end for;
	end for;
end TESTBENCH_FOR_toplevel;

