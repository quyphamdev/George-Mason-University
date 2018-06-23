-------------------------------------------------------------------------------
--
-- Title       : KeystreamGen
-- Design      : Trivium
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : KeystreamGen.vhd
-- Generated   : Sat Feb  6 23:23:00 2010
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
--{entity {KeystreamGen} architecture {KeystreamGen}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity KeystreamGen is
	generic	(KG : integer := 1);
	 port(
		 ld_key : in STD_LOGIC;
		 loaded : in STD_LOGIC;
		 ld_iv : in STD_LOGIC;
		 Key_IV : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 RST : in std_logic;
		 Keystream : out STD_LOGIC_Vector(KG-1 downto 0)
	     );
end KeystreamGen;

--}} End of automatically maintained section

architecture KeystreamGen of KeystreamGen is
signal s1 : std_logic_vector(287 downto 0);
begin
	process(CLK, RST, ld_key, ld_iv, loaded, Key_IV)
	variable t : std_logic_vector(3 downto 1);
	variable Key_stream : std_logic_vector(KG-1 downto 0);
	variable s : std_logic_vector(288 downto 1);
	begin
		if (RST = '1') then
			s := (288 downto 286 => '1', others => '0');
		elsif rising_edge(CLK) then			
			if ld_key = '1' then -- loading 80-bit Key into the first 80 bits of 288-bit initial state vector				
				s(80 downto 1) := s(79 downto 1) & Key_IV;
			elsif ld_iv = '1' then -- loading 80-bit IV (Initial Value) into the next 80 bits of 288-bit inital state vector (start from s94)
            	s(173 downto 94) := s(172 downto 94) & Key_IV;
			elsif loaded = '1' then -- done with loading key and IV, initiating key stream bit generation
				for i in 0 to KG-1 loop
					t(1) := s(66) xor s(93);
					t(2) := s(162) xor s(177);
					t(3) := s(243) xor s(288);
					Key_stream(i) := t(1) xor t(2) xor t(3); 
					t(1) := t(1) xor (s(91) and s(92)) xor s(171);
					t(2) := t(2) xor (s(175) and s(176)) xor s(264);
					t(3) := t(3) xor (s(286) and s(287)) xor s(69);
					s := s(287 downto 178) & t(2) & s(176 downto 94) & t(1) & s(92 downto 1) & t(3);
				end loop;
				s1 <= s;
				Keystream <= Key_stream;
			end if;		
		end if;
	end process;	

end KeystreamGen;
