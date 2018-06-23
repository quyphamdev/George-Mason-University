-------------------------------------------------------------------------------
--
-- Title       : SerialFIRFilter
-- Design      : FIRFilter
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : SerialFIRFilter.vhd
-- Generated   : Sun Feb 28 18:35:48 2010
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
--{entity {SerialFIRFilter} architecture {SerialFIRFilter}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.FIRPackage.all;

entity SerialFIRFilter is
	generic	(N : integer := 16);
	 port(
		 CLK : in STD_LOGIC;
		 Reset : in STD_LOGIC;
		 samp_i : in STD_LOGIC;
		 data_i : in STD_LOGIC_vector(N-1 downto 0);
		 samp_o : out STD_LOGIC;
		 data_o : out STD_LOGIC_vector(N-1 downto 0)
	     );
end SerialFIRFilter;

--}} End of automatically maintained section

architecture SerialFIRFilter of SerialFIRFilter is

type x_array is array (0 to taps_size-1) of std_logic_vector(N-1 downto 0);

begin
	
	serial: process(CLK, Reset, samp_i)
	variable x_arr : x_array;
	variable xh : std_logic_vector(N*2-1 downto 0);
	variable idx : integer;
	variable prev_sum : std_logic_vector(N*2-1 downto 0);
	variable cur_sum : std_logic_vector(N*2-1 downto 0);
	variable f_samp_o : std_logic;
	begin
		if Reset = '1' then
			x_arr := ( x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
					x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
					x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",
					x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
			xh := (others => '0');
			idx := 0;
			prev_sum := (others => '0');
			f_samp_o := '1';
			samp_o <= '1';
			
		elsif rising_edge(CLK) then
			if samp_i = '1' then
				x_arr := data_i & x_arr(0 to taps_size-2);
				prev_sum := (others => '0');
			end if;
			
			xh := std_logic_vector( signed(x_arr(idx)) * signed(taps(idx)) );
			cur_sum := std_logic_vector( signed(xh) + signed(prev_sum) );
			prev_sum := cur_sum;			
			if idx = taps_size-1 then -- complete one full calculation
				data_o <= cur_sum(N-1 downto 0);
				idx := 0;				
				-- data is ready, set samp_o flag for 1 clk cycle
				samp_o <= '1';
				f_samp_o := '1';
			else
				idx := idx + 1;
				-- set samp_o for only 1 clk cycle
				if f_samp_o = '1' then
					f_samp_o := '0';
					samp_o <= '0';
				end if;
			end if;				
		end if;
	end process;				 

end SerialFIRFilter;
