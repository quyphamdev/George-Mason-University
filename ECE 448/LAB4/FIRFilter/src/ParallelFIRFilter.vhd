-------------------------------------------------------------------------------
--
-- Title       : ParallelFIRFilter
-- Design      : FIRFilter
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : ParallelFIRFilter.vhd
-- Generated   : Sun Feb 28 11:23:55 2010
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
--{entity {ParallelFIRFilter} architecture {ParallelFIRFilter}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.FIRPackage.all;

entity ParallelFIRFilter is
	generic	(N : integer := 16);
	 port(
		 CLK : in STD_LOGIC;
		 Reset : in STD_LOGIC;
		 samp_i : in STD_LOGIC;
		 data_i : in STD_LOGIC_vector(N-1 downto 0);
		 samp_o : out STD_LOGIC;
		 data_o : out STD_LOGIC_vector(N-1 downto 0)
	     );
end ParallelFIRFilter;

--}} End of automatically maintained section

architecture ParallelFIRFilter of ParallelFIRFilter is

component ZReg is
	generic	(N : integer := N*2);
	 port(
		 xhy : in STD_LOGIC_vector(N-1 downto 0);
		 CLK : in STD_LOGIC;
		 Reset : in std_logic;
		 samp_i : in std_logic;
		 y : out STD_LOGIC_vector(N-1 downto 0)
	     );
end component;

component QReg is
	generic	(N : integer := N*2);
	 port(
		 p2 : in STD_LOGIC_vector(N-1 downto 0);
		 CLK : in STD_LOGIC;
		 Reset : in std_logic;
		 samp_i : in std_logic;
		 p : out STD_LOGIC_vector(N/2-1 downto 0)
	     );
end component;

type xh_array is array (0 to N*2-1) of std_logic_vector(N*2-1 downto 0);
signal xh : xh_array;
signal y_bus : xh_array;
signal sum_bus : xh_array;
signal counter : std_logic_vector(5 downto 0);

begin		
	
	parallel: process(CLK, Reset, samp_i)
	variable f_samp_o : std_logic;
	begin
		if Reset = '1' then
			counter <= (others => '0');
			f_samp_o := '1';
			samp_o <= '1';
			
		elsif rising_edge(CLK) then
			if samp_i = '1' then
				f_samp_o := '1';
				samp_o <= '1';
			elsif f_samp_o = '1' then
				f_samp_o := '0';
				samp_o <= '0';
			end if;			
		end if;		
	end process;	
	
	y_bus(0) <= (others => '0');
	XH1: for i in 0 to N*2-1 generate
		xh(i) <= std_logic_vector(signed(data_i) * signed(taps(N*2-1-i)));
		sum_bus(i) <= std_logic_vector( signed(xh(i)) + signed(y_bus(i)) );
		IP1: if i < N*2-1 generate
			DFZ: ZReg port map (
				xhy => sum_bus(i),
				CLK => CLK,
				Reset => Reset,
				samp_i => samp_i,
				y => y_bus(i+1)
			);
		end generate;
		IP2: if i = N*2-1 generate
			DFQ: QReg port map (
				p2 => sum_bus(i),
				CLK => CLK,
				Reset => Reset,
				samp_i => samp_i,
				p => data_o
			);
		end generate;		
	end generate;

end ParallelFIRFilter;
