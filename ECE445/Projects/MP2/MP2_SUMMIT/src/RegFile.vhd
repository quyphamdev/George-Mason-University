-------------------------------------------------------------------------------
--
-- Title       : RegFile
-- Design      : LC3b
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : H:\LC3alpha_v2\LC3b\src\RegFile.vhd
-- Generated   : Sat Jan 24 11:28:32 2009
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
--{entity {RegFile} architecture {RegFile}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
library LC3b;
use lc3b.lc3b_types.all;
entity RegFile is
	 port(
		 SrcB : in lc3b_reg;
		 SrcA : in lc3b_reg;
		 JSRMuxOut : in lc3b_reg;
		 clk : in STD_LOGIC;
		 RESET_L : in STD_LOGIC;
		 RegWrite : in STD_LOGIC;
		 RFMuxOut : in lc3b_word;
		 RFAout : out lc3b_word;
		 RFBout : out LC3b_word
	     );
end RegFile;

--}} End of automatically maintained section


ARCHITECTURE untitled OF RegFile IS
  type rammemory is array (7 downto 0) of LC3b_word;
  signal ram : rammemory;
BEGIN
   -------------------------------------------------------------------
  vhdl_regfile_read : PROCESS (ram, SrcA, SrcB)
  -------------------------------------------------------------------
  variable raddr1 : integer range 0 to 7;
  variable raddr2 : integer range 0 to 7;
  BEGIN
    -- Read regfile Process.
    -- convert addresses to integers to use as an index into the array.
    raddr1 := to_Integer(unsigned('0' & SrcA));
    raddr2 := to_Integer(unsigned('0' & SrcB));
    RFAout <= ram(raddr1) after delay_regfile_read;
    RFBout <= ram(raddr2) after delay_regfile_read;
  END PROCESS vhdl_regfile_read;

  -------------------------------------------------------------------
  vhdl_regfile_write: process(clk, RFMuxout, RegWrite, JSRMuxOut, RESET_L)
  -------------------------------------------------------------------
  variable waddr : integer range 0 to 7;
  BEGIN
    if (RESET_L = '0') then
      ram(0) <= "0000000000000000";
      ram(1) <= "0000000000000000";
      ram(2) <= "0000000000000000";
      ram(3) <= "0000000000000000";
      ram(4) <= "0000000000000000";
      ram(5) <= "0000000000000000";
      ram(6) <= "0000000000000000";
      ram(7) <= "0000000000000000";
    end if;
    -- convert address to integer
    waddr := to_Integer(unsigned('0' & JSRMuxOut));
    if (clk'event and (clk = '1') and (clk'last_value = '0')) then
      if (RegWrite = '1') then
        ram(waddr) <= RFMuxout;
      end if;
    end if;
  END PROCESS vhdl_regfile_write;

END untitled;

