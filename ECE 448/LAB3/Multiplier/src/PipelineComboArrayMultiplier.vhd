-------------------------------------------------------------------------------
--
-- Title       : PipelineComboArrayMultiplier
-- Design      : Multiplier
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : PipelineComboArrayMultiplier.vhd
-- Generated   : Tue Feb 23 02:20:39 2010
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
--{entity {PipelineComboArrayMultiplier} architecture {PipelineComboArrayMultiplier}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity PipelineComboArrayMultiplier is
	generic (k : integer := 4);
	 port(
		 a : in STD_LOGIC_vector(k downto 1);
		 x : in STD_LOGIC_vector(k downto 1);
		 CLK : in std_logic;
		 p : out STD_LOGIC_vector(k*2 downto 1)
	     );
end PipelineComboArrayMultiplier;

--}} End of automatically maintained section

architecture PipelineComboArrayMultiplier of PipelineComboArrayMultiplier is
component DFFComboArrayMulCell is
	 port(
		 sin : in STD_LOGIC;
		 cin : in STD_LOGIC;
		 am : in STD_LOGIC;
		 xn : in STD_LOGIC;
		 CLK : in std_logic;
		 amout : out std_logic;
		 cout : out STD_LOGIC;
		 sout : out STD_LOGIC
	     );
end component;
component DFFComboArrayMulCellNoN is
	 port(
		 x : in STD_LOGIC;
		 y : in STD_LOGIC;
		 cin : in STD_LOGIC;
		 CLK : in std_logic;
		 cout : out STD_LOGIC;
		 s : out STD_LOGIC
	     );
end component;
component DFlipFlop is
	 port(
		 D : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 Q : out STD_LOGIC
	     );
end component;

type c_array is array (0 to k) of std_logic_vector(k downto 1);
type s_array is array (0 to k) of std_logic_vector(k downto 0);
type x_array is array (1 to k) of std_logic_vector(k downto 1);
type pl_array is array (1 to k*2-1) of std_logic_vector(k downto 1);
type ph_array is array (1 to k) of std_logic_vector(k-1 downto 1);
signal c_arr : c_array;
signal a_arr : c_array;
signal x_arr : x_array;
signal pl_arr : pl_array;
signal c_bus : std_logic_vector(k downto 0);
signal x_bus : std_logic_vector(k-1 downto 0);
signal s_arr : s_array;
signal ph_arr : ph_array;
signal yh_arr : ph_array;
signal sin_bus : s_array;

begin
	s_arr(0) <= (others	=> '0');	
	c_arr(0) <= (others	=> '0');
	a_arr(0) <= a;
	x_arr(1) <= x;
		
	G1: for row in 0 to k-1 generate
		G2: for col in 1 to k generate
				sin_bus(row)(col) <= s_arr(row)(col) when col < k else '0';
				C1: DFFComboArrayMulCell port map (
						sin => sin_bus(row)(col),
						am => a_arr(row)(col), --a(col),
						cin => c_arr(row)(col),
						xn => x_bus(row), --x_arr(row)(col-1), --x(row+1),
						CLK => CLK,
						amout => a_arr(row+1)(col),
						sout => s_arr(row+1)(col-1),
						cout => c_arr(row+1)(col)
				);								
		end generate;
	end generate;
	
	-- x's pipeline
	lx1: for row in 1 to k generate
		lx2: for col in 1 to k generate
			x1: if col <= row and row < k generate
				x_arr(row+1)(col) <= x_arr(row)(col);
			end generate;
			x2: if col > row generate
					F1: DFlipFlop port map (
						D => x_arr(row)(col),
						CLK => CLK,
						Q => x_arr(row+1)(col)
					);
			end generate;			
		end generate;
	end generate;
	lx3: for row in 0 to k-1 generate
		x_bus(row) <= x_arr(k)(row+1);
	end generate;
		
	-- pipeline for p (lower k bits) 
	G4: for row in 1 to k*2-1 generate
		G5: for col in 1 to k generate			
			P1: if row < k*2-col generate
				F1: DFlipFlop port map (
					D => pl_arr(row)(col),
					CLK => CLK,
					Q => pl_arr(row+1)(col)
				);
			end generate;
			P3: if row >= k*2-col and row < k*2-1 generate
				pl_arr(row+1)(col) <= pl_arr(row)(col);
			end generate;
		end generate;
	end generate;
	G5: for col in 1 to k generate
		pl_arr(1)(col) <= s_arr(col)(0);
		p(col) <= pl_arr(k*2-1)(col);
	end generate;
	
	
	-- upper k bits
	N3: for col in 1 to k-1 generate
		ph_arr(1)(col) <= s_arr(k)(col);
		yh_arr(1)(col) <= c_arr(k)(col);
	end generate;
	
	c_bus(0) <= '0';
	N1: for row in 1 to k-1 generate
		N2: for col in 1 to k-1 generate
--			N3: if row = 1 generate
--				ph_arr(1)(col) <= s_arr(k)(col);
--				yh_arr(1)(col) <= c_arr(k)(col);
--			end generate;			
			N4: if col = row generate
				NC4: DFFComboArrayMulCellNoN port map (
					 x => ph_arr(row)(col),
					 y => yh_arr(row)(col),
					 cin => c_bus(col-1),
					 CLK => CLK,
					 cout => c_bus(col),
					 s => ph_arr(row+1)(col)
				);
			end generate;
			N5: if (col > row or col < row) generate
				NF5: DFlipFlop port	map (
						 D => ph_arr(row)(col),
						 CLK => CLK,
						 Q => ph_arr(row+1)(col)
				);
				NF6: DFlipFlop port	map (
						 D => yh_arr(row)(col),
						 CLK => CLK,
						 Q => yh_arr(row+1)(col)
				);

			end generate;			
		end generate;
	end generate;
	PH: for col in 1 to k-1 generate
		p(k+col) <= ph_arr(k)(col);
	end generate;
	p(k*2) <= c_bus(k-1);

end PipelineComboArrayMultiplier;
