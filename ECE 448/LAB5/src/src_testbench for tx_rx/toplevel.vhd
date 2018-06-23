-------------------------------------------------------------------------------
--
-- Title       : toplevel
-- Design      : lab5
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : toplevel.vhd
-- Generated   : Sat Apr  3 03:21:52 2010
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
--{entity {toplevel} architecture {toplevel}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity toplevel is
	 port(
		 clk : in STD_LOGIC;
		 data_in : in STD_LOGIC_vector(7 downto 0);
		 reset : in STD_LOGIC;
		 tx_en : in STD_LOGIC;
		 data_out : out STD_LOGIC_vector(7 downto 0);
		 wr_en : out STD_LOGIC
	     );
end toplevel;

--}} End of automatically maintained section

architecture toplevel of toplevel is
signal txd : std_logic;
signal clk_180 : std_logic ;
begin

	-- enter your statements here --
	tx_inst: entity	work.tx
		port map (
			clk0 => clk,
           tx_en => tx_en,
			  reset => reset,
           data8 => data_in,
           txd => txd);
	
	clk_180 <= not clk;
		   
	rx_inst: entity	work.rx
		port map (
			rxd => txd,
           rx_clk => clk_180,
			  reset => reset,
           data8 => data_out,
           wr_en => wr_en);

end toplevel;
