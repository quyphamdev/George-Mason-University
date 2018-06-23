-------------------------------------------------------------------------------
--
-- Title       : TopLevel
-- Design      : Trivium
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : TopLevel.vhd
-- Generated   : Sun Feb  7 20:02:24 2010
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
--{entity {TopLevel} architecture {TopLevel}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity TopLevel is
	generic	(TL : integer := 1);
	 port(
		 RST : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 Key_IV : in STD_LOGIC;
		 Plaintext : in STD_LOGIC_vector(TL-1 downto 0);
		 Initialized : out std_logic;
		 loading_iv : out std_logic;
		 loading_key : out std_logic ;		 		 
		 Ciphertext : out STD_LOGIC_vector(TL-1 downto 0)
	     );
end TopLevel;

--}} End of automatically maintained section

architecture TopLevel of TopLevel is
component Counter10b is
	generic	(N : integer := 10);
	 port(
		 RST : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 En : in STD_LOGIC;
		 CounterOut : out STD_LOGIC_VECTOR(N downto 0)
	     );
end component;
component CntThreshold is
	generic	(T : integer := 79);
	 port(
		 Counter : in STD_LOGIC_VECTOR(10 downto 0);
		 lte : out STD_LOGIC
	     );
end component;
component KeystreamGen is
	generic	(KG : integer := 1);
	 port(
		 ld_key : in STD_LOGIC;
		 loaded : in STD_LOGIC;
		 ld_iv : in STD_LOGIC;
		 Key_IV : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 RST : in std_logic;
		 Keystream : out STD_LOGIC_vector (KG-1 downto 0)
	     );
end component;

signal Counter : std_logic_vector (10 downto 0);
signal lte79 : std_logic ;
signal lte159 : std_logic ;
signal lte1311 : std_logic ;
--signal En : std_logic ;
signal ld_key : std_logic ;
signal loaded : std_logic ;
signal ld_iv : std_logic ;
signal Keystream : std_logic_vector(TL-1 downto 0);

begin

	-- enter your statements here --
	Start: Counter10b port map (
							RST => RST,
							CLK => CLK,
							En => lte1311,
							CounterOut => Counter
	);
	LTE_79: CntThreshold port map (
							Counter => Counter,
							lte => lte79
	);
	LTE_159: CntThreshold generic map (T => 159)
						port map (
							Counter => Counter,
							lte => lte159
	);
	LTE_1311: CntThreshold generic map (T => (159 + 4*288/TL))
						port map (
							Counter => Counter,
							lte => lte1311
	);
	GenKeystream: KeystreamGen generic map (KG => TL)
						port map (
							ld_key => lte79,
							loaded => loaded,
							ld_iv => ld_iv,
							Key_IV => Key_IV,
							CLK => CLK,
							RST => RST,
							Keystream => Keystream
	);
	
	loaded <= not lte159;
	ld_iv <= lte159 and (not lte79);
	loading_iv <= ld_iv;
	loading_key <= lte79;
	Initialized <= not lte1311;
	
	Ciphertext <= Plaintext xor Keystream;
	
end TopLevel;
