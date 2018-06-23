-------------------------------------------------------------------------------
--
-- Title       : Test Bench for toplevel
-- Design      : Trivium
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\toplevel_TB.vhd
-- Generated   : 2/7/2010, 11:32 PM
-- From        : $DSN\src\TopLevel.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for toplevel_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity toplevel_tb is
end toplevel_tb;

architecture TB_ARCHITECTURE of toplevel_tb is
	-- Component declaration of the tested unit
	component toplevel
	generic	(TL : integer := 1);
	port(
		RST : in std_logic;
		CLK : in std_logic;
		Key_IV : in std_logic;
		Plaintext : in std_logic_vector(TL-1 downto 0);
		Initialized : out std_logic;
		loading_iv : out std_logic;
		loading_key : out std_logic;
		Ciphertext : out std_logic_vector(TL-1 downto 0) );
	end component;
	
	-- constants
	constant LEN : integer := 1; -- generate and encrypt k bits/clk
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal RST : std_logic;
	signal CLK : std_logic;
	signal Key_IV : std_logic;
	signal Plaintext : std_logic_vector(LEN-1 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal Initialized : std_logic;
	signal loading_iv : std_logic;
	signal loading_key : std_logic;
	signal Ciphertext : std_logic_vector(LEN-1 downto 0);

	-- Add your code here ...
	signal Key : std_logic_vector (79 downto 0) := (others => '0');
	signal IV : std_logic_vector (79 downto 0) := (79 => '1', others => '0');
	signal text : std_logic_vector (127 downto 0) := (others => '0');

	signal CipherVector : std_logic_vector	(127 downto 0) := (others => '0');
	
begin

	-- Unit Under Test port map
	UUT : toplevel generic map (TL => LEN) -- generate and encrypt 2 bits/clk
		port map (
			RST => RST,
			CLK => CLK,
			Key_IV => Key_IV,
			Plaintext => Plaintext,
			Initialized => Initialized,
			loading_iv => loading_iv,
			loading_key => loading_key,
			Ciphertext => Ciphertext
		);

	-- Add your stimulus here ...
	reset: process
	begin
		RST <= '1';
		wait for 15ns;
		RST <= '0';
		wait;
	end process;	
	
	clock: process
	begin
		CLK <= '0';
		wait for 10 ns;
		CLK <= '1';
		wait for 10 ns;
	end process;
		
	testing: process(CLK, loading_key, loading_iv, Initialized, Key, IV, text)
	variable i : integer := 0;
	variable j : integer := 0;
	variable cnt : integer := 0;
	variable k : integer := 127;
	variable plain_text : std_logic_vector(LEN-1 downto 0);
	variable Cipher_Vector : std_logic_vector(127 downto 0) := (others => '0');
	begin
		if falling_edge(CLK) then
			if loading_key = '1' then
				Key_IV <= Key(i);
				i := i + 1;
			elsif loading_iv = '1' then
				if i > 79 then
					i := 0;
				end if;				
				Key_IV <= IV(i);
				i := i + 1;
			elsif Initialized = '1' then
				t1: for l in 0 to LEN-1 loop
						plain_text(l) := text(j mod 128);
						j := j + 1;
						assert j <= 129
						report "Finished"
						severity FAILURE;        
				end loop t1;
				Plaintext <= plain_text;
			end if;			
		elsif rising_edge(CLK) then
			if Initialized = '1' then
--				CipherVector(127 downto 0) <= Ciphertext & CipherVector(127 downto 1);
				v1: for m in 0 to LEN-1 loop
					Cipher_Vector(k downto 0) := Ciphertext(m) & Cipher_Vector(k downto 1);
					cnt := cnt + 1;
					if cnt > 8 then
						cnt := 1;
						if k > 7 then
							k := k - 8;
						end if;						
					end if;
				end loop v1;
				CipherVector <= Cipher_Vector;
				
--				v1: for m in LEN-1 downto 0 loop
--						if cnt <= 8 then					
--							Cipher_Vector(k downto 0) := Ciphertext(m) & Cipher_Vector(k downto 1);
--						else
--							cnt := 1;
--							if k > 8 then
--								k := k - 8;
--							end if;	
--							Cipher_Vector(k downto 0) := Ciphertext(m) & Cipher_Vector(k downto 1);
--						end if;				
--						cnt := cnt + 1;
--				end loop v1;
--				CipherVector <= Cipher_Vector;
			end if;			
		end if;		
	end process;	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_toplevel of toplevel_tb is
	for TB_ARCHITECTURE
		for UUT : toplevel
			use entity work.toplevel(toplevel);
		end for;
	end for;
end TESTBENCH_FOR_toplevel;

