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
		 MWRITEL_L : in STD_LOGIC;
		 MWRITEH_L : in STD_LOGIC;
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
   vhdl_memory : PROCESS (RESET_L, MREAD_L, MWRITEL_L, MWRITEH_L) 
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
--mem(0) := x"22"; mem(1) := x"10";
--mem(2) := x"21"; mem(3) := x"D2";
--mem(4) := x"00"; mem(5) := x"14";
--mem(6) := x"91"; mem(7) := x"D6";
--mem(8) := x"B2"; mem(9) := x"D8";
--mem(10) := x"02"; mem(11) := x"EA";
--mem(12) := x"40"; mem(13) := x"41";
--mem(14) := x"F8"; mem(15) := x"0F";
--mem(16) := x"62"; mem(17) := x"1B";
--mem(18) := x"12"; mem(19) := x"EA";
--mem(20) := x"40"; mem(21) := x"61";
--mem(22) := x"43"; mem(23) := x"65";
--mem(24) := x"43"; mem(25) := x"71";
--mem(26) := x"40"; mem(27) := x"75";
--mem(28) := x"40"; mem(29) := x"61";
--mem(30) := x"43"; mem(31) := x"65";
--mem(32) := x"40"; mem(33) := x"21";
--mem(34) := x"40"; mem(35) := x"31";
--mem(36) := x"40"; mem(37) := x"23";
--mem(38) := x"44"; mem(39) := x"73";
--mem(40) := x"0B"; mem(41) := x"E0";
--mem(42) := x"45"; mem(43) := x"71";
--mem(44) := x"45"; mem(45) := x"A5";
--mem(46) := x"45"; mem(47) := x"BB";
--mem(48) := x"45"; mem(49) := x"A5";
--mem(50) := x"23"; mem(51) := x"F0";
--mem(52) := x"46"; mem(53) := x"65";
--mem(54) := x"41"; mem(55) := x"65";
--mem(56) := x"00"; mem(57) := x"00";
--mem(58) := x"70"; mem(59) := x"00";
--mem(60) := x"0A"; mem(61) := x"00";
--mem(62) := x"0F"; mem(63) := x"27";
--mem(64) := x"00"; mem(65) := x"00";
--mem(66) := x"00"; mem(67) := x"00";
--mem(68) := x"00"; mem(69) := x"00";
--mem(70) := x"48"; mem(71) := x"00";
--mem(72) := x"41"; mem(73) := x"65";
--mem(74) := x"BF"; mem(75) := x"94";
--mem(76) := x"C0"; mem(77) := x"C1";
--mem(78) := x"F4"; mem(79) := x"F4";

-- prof code
	mem(0) := X"6A";
	mem(1) := X"E0";
	mem(2) := X"00";
	mem(3) := X"62";
	mem(4) := X"01";
	mem(5) := X"64";
	mem(6) := X"02";
	mem(7) := X"6E";
	mem(8) := X"87";
	mem(9) := X"12";
	mem(10) := X"7C";
	mem(11) := X"16";
	mem(12) := X"43";
	mem(13) := X"12";
	mem(14) := X"41";
	mem(15) := X"12";
	mem(16) := X"0F";
	mem(17) := X"72";
	mem(18) := X"03";
	mem(19) := X"62";
	mem(20) := X"04";
	mem(21) := X"64";
	mem(22) := X"42";
	mem(23) := X"5C";
	mem(24) := X"AA";
	mem(25) := X"5B";
	mem(26) := X"10";
	mem(27) := X"7A";
	mem(28) := X"05";
	mem(29) := X"6E";
	mem(30) := X"FF";
	mem(31) := X"9F";
	mem(32) := X"11";
	mem(33) := X"7E";
	mem(34) := X"09";
	mem(35) := X"62";
	mem(36) := X"64";
	mem(37) := X"D4";
	mem(38) := X"52";
	mem(39) := X"D6";
	mem(40) := X"A1";
	mem(41) := X"D4";
	mem(42) := X"D1";
	mem(43) := X"D6";
	mem(44) := X"83";
	mem(45) := X"14";
	mem(46) := X"A1";
	mem(47) := X"14";
	mem(48) := X"73";
	mem(49) := X"D8";
	mem(50) := X"0A";
	mem(51) := X"62";
	mem(52) := X"76";
	mem(53) := X"DA";
	mem(54) := X"12";
	mem(55) := X"74";
	mem(56) := X"13";
	mem(57) := X"78";
	mem(58) := X"14";
	mem(59) := X"7A";
	mem(60) := X"61";
	mem(61) := X"E2";
	mem(62) := X"16";
	mem(63) := X"72";
	mem(64) := X"6D";
	mem(65) := X"1B";
	mem(66) := X"16";
	mem(67) := X"BA";
	mem(68) := X"07";
	mem(69) := X"62";
	mem(70) := X"06";
	mem(71) := X"64";
	mem(72) := X"E0";
	mem(73) := X"56";
	mem(74) := X"A5";
	mem(75) := X"14";
	mem(76) := X"7F";
	mem(77) := X"12";
	mem(78) := X"FD";
	mem(79) := X"03";
	mem(80) := X"67";
	mem(81) := X"12";
	mem(82) := X"BA";
	mem(83) := X"14";
	mem(84) := X"FD";
	mem(85) := X"03";
	mem(86) := X"F9";
	mem(87) := X"05";
	mem(88) := X"01";
	mem(89) := X"08";
	mem(90) := X"0D";
	mem(91) := X"64";
	mem(92) := X"81";
	mem(93) := X"14";
	mem(94) := X"16";
	mem(95) := X"74";
	mem(96) := X"00";
	mem(97) := X"6C";
	mem(98) := X"32";
	mem(99) := X"48";
	mem(100) := X"17";
	mem(101) := X"7C";
	mem(102) := X"6D";
	mem(103) := X"5B";
	mem(104) := X"02";
	mem(105) := X"E6";
	mem(106) := X"C0";
	mem(107) := X"C0";
	mem(108) := X"08";
	mem(109) := X"6A";
	mem(110) := X"18";
	mem(111) := X"7A";
	mem(112) := X"08";
	mem(113) := X"6A";
	mem(114) := X"8D";

	mem(115) := X"F0";
	mem(116) := X"19";
	mem(117) := X"7A";
	mem(118) := X"2F";
	mem(119) := X"E2";
	mem(120) := X"61";
	mem(121) := X"12";
	mem(122) := X"16";
	mem(123) := X"24";
	mem(124) := X"56";
	mem(125) := X"26";
	mem(126) := X"C2";
	mem(127) := X"18";
	mem(128) := X"1A";
	mem(129) := X"78";
	mem(130) := X"AB";
	mem(131) := X"14";
	mem(132) := X"FE";
	mem(133) := X"16";
	mem(134) := X"46";
	mem(135) := X"E2";
	mem(136) := X"79";
	mem(137) := X"34";
	mem(138) := X"78";
	mem(139) := X"36";
	mem(140) := X"1B";
	mem(141) := X"68";
	mem(142) := X"1A";
	mem(143) := X"78";
	mem(144) := X"30";
	mem(145) := X"E6";
	mem(146) := X"1D";
	mem(147) := X"76";
	mem(148) := X"1D";
	mem(149) := X"A6";
	mem(150) := X"1C";
	mem(151) := X"76";
	mem(152) := X"FF";
	mem(153) := X"E9";
	mem(154) := X"05";
	mem(155) := X"65";
	mem(156) := X"A3";
	mem(157) := X"14";
	mem(158) := X"60";
	mem(159) := X"52";
	mem(160) := X"05";
	mem(161) := X"75";
	mem(162) := X"69";
	mem(163) := X"12";
	mem(164) := X"1E";
	mem(165) := X"72";
	mem(166) := X"21";
	mem(167) := X"12";
	mem(168) := X"4B";
	mem(169) := X"66";
	mem(170) := X"34";
	mem(171) := X"EC";
	mem(172) := X"80";
	mem(173) := X"77";
	mem(174) := X"0B";
	mem(175) := X"62";
	mem(176) := X"0D";
	mem(177) := X"06";
	mem(178) := X"08";
	mem(179) := X"62";
	mem(180) := X"36";
	mem(181) := X"E4";
	mem(182) := X"80";
	mem(183) := X"40";
	mem(184) := X"81";
	mem(185) := X"73";
	mem(186) := X"22";
	mem(187) := X"12";
	mem(188) := X"A1";
	mem(189) := X"ED";
	mem(190) := X"01";
	mem(191) := X"04";
	mem(192) := X"41";
	mem(193) := X"12";
	mem(194) := X"28";
	mem(195) := X"EC";
	mem(196) := X"82";
	mem(197) := X"73";
	mem(198) := X"FF";
	mem(199) := X"0F";
	mem(200) := X"FF";
	mem(201) := X"9D";
	mem(202) := X"C0";
	mem(203) := X"C1";
	mem(204) := X"08";
	mem(205) := X"62";
	mem(206) := X"06";
	mem(207) := X"22";
	mem(208) := X"08";
	mem(209) := X"24";
	mem(210) := X"06";
	mem(211) := X"66";
	mem(212) := X"00";
	mem(213) := X"68";
	mem(214) := X"00";
	mem(215) := X"00";
	mem(216) := X"70";
	mem(217) := X"00";
	mem(218) := X"0A";
	mem(219) := X"00";
	mem(220) := X"0F";
	mem(221) := X"27";
	mem(222) := X"2A";
	mem(223) := X"00";
	mem(224) := X"C8";
	mem(225) := X"BA";
	mem(226) := X"07";
	mem(227) := X"00";
	mem(228) := X"03";
	mem(229) := X"00";
	mem(230) := X"AD";
	mem(231) := X"0B";
	mem(232) := X"0D";
	mem(233) := X"0D";
	mem(234) := X"84";
	mem(235) := X"98";
	mem(236) := X"84";
	mem(237) := X"AE";
	mem(238) := X"60";
	mem(239) := X"54";
	mem(240) := X"05";
	mem(241) := X"00";
	mem(242) := X"46";
	mem(243) := X"06";
	mem(244) := X"00";
	mem(245) := X"00";
	mem(246) := X"00";
	mem(247) := X"00";
	mem(248) := X"00";
	mem(249) := X"00";
	mem(250) := X"00";
	mem(251) := X"00";
	mem(252) := X"00";
	mem(253) := X"00";
	mem(254) := X"00";
	mem(255) := X"00";
	mem(256) := X"00";
	mem(257) := X"00";
	mem(258) := X"00";
	mem(259) := X"00";
	mem(260) := X"00";
	mem(261) := X"00";
	mem(262) := X"00";
	mem(263) := X"00";
	mem(264) := X"00";
	mem(265) := X"00";
	mem(266) := X"00";
	mem(267) := X"00";
	mem(268) := X"00";
	mem(269) := X"00";
	mem(270) := X"00";
	mem(271) := X"00";
	mem(272) := X"00";
	mem(273) := X"00";
	mem(274) := X"00";
	mem(275) := X"00";
	mem(276) := X"00";
	mem(277) := X"00";
	mem(278) := X"00";
	mem(279) := X"00";
	mem(280) := X"00";
	mem(281) := X"00";
	mem(282) := X"1C";
	mem(283) := X"01";
	mem(284) := X"0B";
	mem(285) := X"6A";
	mem(286) := X"7F";
	mem(287) := X"9B";
	mem(288) := X"C0";
	mem(289) := X"C1";
	mem(290) := X"0C";
	mem(291) := X"66";
	mem(292) := X"43";
	mem(293) := X"12";
	mem(294) := X"C0";
	mem(295) := X"C1";
	mem(296) := X"00";
	mem(297) := X"00";

-- Stop.

     ELSE
       IF ((int_address >= 0) and (int_address <= 4096)) THEN
         IF (MREAD_L = '0' and MWRITEH_L = '1' and MWRITEL_L = '1') THEN
           DATAIN(7 downto 0) <= mem(int_address) after 50 ns;
           DATAIN(15 downto 8) <= mem(int_address + 1) after 50 ns;
           MRESP_H <= '1' after 50 ns, '0' after 80 ns;
		 ELSIF (MWRITEL_L = '0' and MWRITEH_L = '0' and MREAD_L = '1') THEN
			mem(int_address) := DATAOUT(7 downto 0);
			mem(int_address + 1) := DATAOUT(15 downto 8);
			MRESP_H <= '1' after 50 ns, '0' after 80 ns;			
           --MRESP_H <= '1' after 2 ns, '0' after 30 ns;
         ELSIF (MWRITEL_L = '0' and MWRITEH_L = '1' and MREAD_L = '1') THEN --  write low byte
           mem(int_address) := DATAOUT(7 downto 0);
		   mem(int_address + 1) := "00000000";
		   --MRESP_H <= '1' after 2 ns, '0' after 30 ns;
		   MRESP_H <= '1' after 50 ns, '0' after 80 ns;
		 ELSIF (MWRITEL_L = '1' and MWRITEH_L = '0' and MREAD_L = '1') THEN	-- write high byte
			mem(int_address) := "00000000";
           mem(int_address + 1) := DATAOUT(15 downto 8);
		   MRESP_H <= '1' after 50 ns, '0' after 80 ns;
           --MRESP_H <= '1' after 2 ns, '0' after 30 ns;
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














