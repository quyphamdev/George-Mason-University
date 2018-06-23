-------------------------------------------------------------------------------
--
-- Title       : wo_counter
-- Design      : LC3B
-- Author      : JasonVM
-- Company     : JVM
--
-------------------------------------------------------------------------------
--
-- File        : c:\downloads\mp3\mp3_start_v2\wo_counter.vhd
-- Generated   : Sat Apr 25 16:59:11 2009
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
--{entity {wo_counter} architecture {wo_counter}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use work.lc3b_types.all; 

entity wo_counter is
	 port(
		 wo_rst : in std_logic;
		 clk : in std_logic;
		 WO_EN : in std_logic;
		 WO_MAX : out std_logic;
		 word_offset : out lc3b_nibble				 		  
	     );
end wo_counter;															 

--}} End of automatically maintained section

architecture wo_counter of wo_counter is
signal counter : lc3b_nibble := "0000";
begin	
	-- enter your statements here --
	process(clk)	
	begin
		if(wo_rst = '0') then
			counter <= "0000";
		else
			if counter = "1111" then
				WO_MAX <= '1';
			else
				WO_MAX <= '0';
			end if;
			if(clk'event and clk = '1' and clk'last_value = '0') and (WO_EN = '1') then
				counter <= counter + "0001";
			end if;
		end if;		
	end process;
	word_offset <= counter;
end wo_counter;
