-------------------------------------------------------------------------------
--
-- Title       : ComboArrayMultiplier
-- Design      : Multiplier
-- Author      : ECE
-- Company     : George Mason University
--
-------------------------------------------------------------------------------
--
-- File        : ComboArrayMultiplier.vhd
-- Generated   : Sat Feb 20 17:48:15 2010
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ComboArrayMultiplier} architecture {ComboArrayMultiplier}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ComboArrayMultiplier is
	generic (k : integer := 4);
	 port(
		 a : in STD_LOGIC_vector(k downto 1);
		 x : in STD_LOGIC_vector(k downto 1);
		 p : out STD_LOGIC_vector(k*2 downto 1)
	     );
end ComboArrayMultiplier;

--}} End of automatically maintained section

architecture ComboArrayMultiplier of ComboArrayMultiplier is

component ComboArrayMulCell is
	 port(
		 sin : in STD_LOGIC;
		 am : in STD_LOGIC;
		 cin : in STD_LOGIC;
		 xn : in STD_LOGIC;
		 sout : out STD_LOGIC;
		 cout : out STD_LOGIC
	     );
end component;
component ComboArrayMulCellNoN is
	 port(
		 x : in STD_LOGIC;
		 y : in STD_LOGIC;
		 cin : in STD_LOGIC;
		 cout : out STD_LOGIC;
		 s : out STD_LOGIC
	     );
end component;


type c_array is array (0 to k) of std_logic_vector(k downto 1);
type s_array is array (0 to k) of std_logic_vector(k downto 0);
signal c_arr : c_array;
signal c_bus : std_logic_vector(k downto 0);
signal s_arr : s_array;
signal sin_bus : s_array;

begin
	s_arr(0) <= (others	=> '0');	
	c_arr(0) <= (others	=> '0');
			
	G1: for row in 0 to k-1 generate
		G2: for col in 1 to k generate
				sin_bus(row)(col) <= s_arr(row)(col) when col < k else '0';
				C1: ComboArrayMulCell port map (
						sin => sin_bus(row)(col),
						am => a(col),
						cin => c_arr(row)(col),
						xn => x(row+1),
						sout => s_arr(row+1)(col-1),
						cout => c_arr(row+1)(col)
				);									
		end generate;
	end generate;
	
	G3: for row in 1 to k generate
		p(row) <= s_arr(row)(0);
	end generate;	
	
	c_bus(0) <= '0';	
	G4: for col in 1 to k-1 generate
		C2: ComboArrayMulCellNoN port map (
				 x => s_arr(k)(col), 
				 y => c_bus(col-1),
				 cin => c_arr(k)(col),
				 cout => c_bus(col),
				 s => p(k+col)
		);
	end generate;
	p(2*k) <= c_bus(k-1);

end ComboArrayMultiplier;
