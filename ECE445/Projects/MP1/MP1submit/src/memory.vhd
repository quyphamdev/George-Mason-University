-------------------------------------------------------------------------------
--
-- Title       : Memory
-- Design      : BD
-- Author      : chethan ananth
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : c:\VHDL_Designs\445\BD\src\Memory.vhd
-- Generated   : Sat Feb 10 13:28:00 2007
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
--{entity {Memory} architecture {Memory}}

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


library LC3b;
use LC3b.lc3b_types.all;

entity Memory is
	 port(
		 RESET_L : in STD_LOGIC;
		 MWRITE_L : in STD_LOGIC;
		 MREAD_L : in STD_LOGIC;
		 ADDRESS : in LC3b_word;
		 DATAOUT : in LC3b_word;
		 clk : in STD_LOGIC;
		 MRESP_H : out STD_LOGIC;
		 DATAIN : out LC3b_word
	     );
end Memory;

--}} End of automatically maintained section

ARCHITECTURE untitled OF Memory IS

BEGIN
   -------------------------------------------------------------------
   vhdl_memory : PROCESS (RESET_L, MREAD_L, MWRITE_L) 
   -------------------------------------------------------------------
     TYPE memory_array IS	array (0 to 4096) of LC3b_byte;
     VARIABLE mem : memory_array;
     VARIABLE int_address : integer;
     VARIABLE temp : string(1 to 10);
     VARIABLE temp_int : integer;
   BEGIN
     int_address := To_integer(unsigned('0' & ADDRESS(11 downto 0)));
     IF RESET_L = '0' then
    MRESP_H <= '0';
	   
-- Example: mem(0) := To_stdlogicvector(8#00#, 0);
mem(0) := X"25";
mem(1) := X"1B";
mem(2) := X"05";
mem(3) := X"19";
mem(4) := X"60";
mem(5) := X"1D";
mem(6) := X"3F";
mem(7) := X"19";
mem(8) := X"20";
mem(9) := X"11";
mem(10) := X"3F";
mem(11) := X"10";
mem(12) := X"07";
mem(13) := X"04";
mem(14) := X"20";
mem(15) := X"13";
mem(16) := X"01";
mem(17):= X"48";
mem(18) := X"FF";
mem(19) := X"0F";
mem(20) := X"7F";
mem(21) := X"12" ;
mem(22) := X"F6" ;
mem(23) := X"05" ;
mem(24) := X"46" ;
mem(25) := X"1B" ;
mem(26) := X"FC" ;
mem(27) := X"0F" ;
mem(28) := X"C0" ;
mem(29) := X"C1" ;
mem(30) := X"F4" ;
mem(31) := X"F4" ;
-- Stop.

     ELSE
       IF ((int_address >= 0) and (int_address <= 4096)) THEN
         IF (MREAD_L = '0' and MWRITE_L = '1') THEN
           DATAIN(7 downto 0) <= mem(int_address) after 50 ns;
           DATAIN(15 downto 8) <= mem(int_address + 1) after 50 ns;
           MRESP_H <= '1' after 50 ns, '0' after 80 ns;
         ELSIF (MWRITE_L = '0' and MREAD_L = '1') THEN
           mem(int_address) := DATAOUT(7 downto 0);
           mem(int_address + 1) := DATAOUT(15 downto 8);
           MRESP_H <= '1' after 2 ns, '0' after 30 ns;
         ELSE
           ASSERT false 
             REPORT "Memory Write"
             SEVERITY note;
         END IF;
       ELSE
         ASSERT false
           REPORT "Invalid address"
           SEVERITY warning;
       END IF;
     END IF;
   END PROCESS vhdl_memory;
END untitled;














