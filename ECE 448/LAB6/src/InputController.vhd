----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:08:49 04/09/2010 
-- Design Name: 
-- Module Name:    InputController - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InputController is
    Port ( clk : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (7 downto 0);
			  reset : in std_logic;
           button : in  STD_LOGIC_VECTOR (3 downto 0);
			  illegalMove : out std_logic;
			  comboMoveOn : out std_logic;
           ChangeColorEn : out  STD_LOGIC_VECTOR (1 downto 0);
			  -- current position of the chess piece
			  pieceRow : out std_logic_vector(3 downto 0);
			  pieceCol : out std_logic_vector(3 downto 0);
			  -- piece is bishop, rook or knight
           Pieces : out  STD_LOGIC_VECTOR (1 downto 0));
end InputController;

architecture Behavioral of InputController is
	signal btn : std_logic_vector(3 downto 0);
	--signal row,col,t_row,t_col : std_logic_vector(3 downto 0);
	--signal curPiece : std_logic_vector(1 downto 0);
	--signal task : std_logic_vector(1 downto 0);
	signal combo_btn : std_logic_vector(3 downto 0);
begin
	-- Rising Edge Detector for all 4 buttons
	red0_inst: entity work.RED
		port map(
			clk => clk,
			button => button(0),
			reset => reset,
			en => btn(0));
			
	red1_inst: entity work.RED
		port map(
			clk => clk,
			button => button(1),
			reset => reset,
			en => btn(1));
			
	red2_inst: entity work.RED
		port map(
			clk => clk,
			button => button(2),
			reset => reset,
			en => btn(2));
			
	red3_inst: entity work.RED
		port map(
			clk => clk,
			button => button(3),
			reset => reset,
			en => btn(3));

	process(clk)
	variable step : integer;--std_logic_vector(2 downto 0);
	variable task : std_logic_vector(1 downto 0);
	variable row,col,t_row,t_col : std_logic_vector(3 downto 0);
	variable curPiece : std_logic_vector(1 downto 0);
	begin
		if reset = '1' then
			ChangeColorEn <= (others => '0'); -- default, change black square color
			-- init position of piece
			row := x"4";
			col := x"3";
			t_row := row;
			t_col := col;
			pieceRow <= row;
			pieceCol <= col;
			curPiece := "00"; -- no chess piece
			Pieces <= curPiece; 
			task := "00";
			combo_btn <= x"0";
			
		elsif rising_edge(clk) then
			task := sw(1 downto 0); -- switch 1 & 0 indicate current task
			if sw(7) = '0' then -- change color (all tasks)
				if btn(0) = '1' then -- change color for chess square, color 1
					ChangeColorEn <= "01";
				elsif btn(1) = '1' then -- change color for chess square, color 2
					ChangeColorEn <= "10";
				elsif btn(2) = '1' and task /= "00" then -- change color for pieces
					ChangeColorEn <= "11";
				else
					ChangeColorEn <= (others => '0');
				end if;
			elsif sw(7) = '1' and task >= 2 then -- move enable from task 3 -> 5
				if task >= 3 and sw(3) = '0' then -- multiple space move, enable after task 4->5 and only for bishop & rook
					step := conv_integer(unsigned(sw(6 downto 4))); -- amount of step to move pieces to
				else
					if sw(6 downto 3) = 0 then -- task 3, move by 1 space. switch 3->6 are off
						step := 1; -- default, one step by one move
					else
						step := 0;
					end if;
				end if;
				if curPiece = "01" then -- move for bishop
					if btn(0) = '1' then -- move to upper left
						t_row := row - step;
						t_col := col - step;
					elsif btn(1) = '1' then -- move to upper right
						t_row := row - step;
						t_col := col + step;
					elsif btn(2) = '1' then -- move to lower left
						t_row := row + step;
						t_col := col - step;
					elsif btn(3) = '1' then -- move to lower right
						t_row := row + step;
						t_col := col + step;
					end if;
				elsif curPiece = "10" then -- move for rook
					if btn(0) = '1' then -- move to upper
						t_row := row - step;
					elsif btn(1) = '1' then -- move to lower
						t_row := row + step;
					elsif btn(2) = '1' then -- move to left
						t_col := col - step;
					elsif btn(3) = '1' then -- move to right
						t_col := col + step;
					end if;
				elsif curPiece = "11" then -- move for knight
					-- combo button presses for knight's 8 moves
					-- 1st combo button presses
					if btn /= x"0" and combo_btn = x"0" then
						combo_btn <= btn;
						comboMoveOn <= '1';
					elsif btn /= x"0" and combo_btn /= x"0" then
						comboMoveOn <= '0';
						combo_btn <= x"0";
						if combo_btn(0) = '1' then -- move up...
							-- 2nd combo button presses
							if btn(2) = '1' then -- ...to the left
								t_row := row - 2;
								t_col := col - 1;
							elsif btn(3) = '1' then -- ...to the right
								t_row := row - 2;
								t_col := col + 1;
							end if;
						elsif combo_btn(1) = '1' then -- move down...
							-- 2nd combo button presses
							if btn(2) = '1' then -- ...to the left
								t_row := row + 2;
								t_col := col - 1;
							elsif btn(3) = '1' then -- ...to the right
								t_row := row + 2;
								t_col := col + 1;
							end if;
						elsif combo_btn(2) = '1' then -- move left...
							-- 2nd combo button presses
							if btn(0) = '1' then -- ...then up
								t_row := row - 1;
								t_col := col - 2;
							elsif btn(1) = '1' then -- ...then down
								t_row := row + 1;
								t_col := col - 2;
							end if;
						elsif combo_btn(3) = '1' then -- move right...
							-- 2nd combo button presses
							if btn(0) = '1' then -- ...then up
								t_row := row - 1;
								t_col := col + 2;
							elsif btn(1) = '1' then -- ...then down
								t_row := row + 1;
								t_col := col + 2;
							end if;
						end if;
					end if;
				end if;
				
				-- check legal moves, chess board is 8x8, row & col start with 0
				if (t_row >= 0) and (t_row <= 7) and (t_col >= 0) and (t_col <= 7) then
					row := t_row;
					col := t_col;
					illegalMove <= '0';
				else
					-- illegal move, enable error signal
					illegalMove <= '1';
					t_row := row;
					t_col := col;
				end if;
				pieceRow <= row;
				pieceCol <= col;
				
			end if;
			
			if task /= "00" then
				if sw(3) = '1' and task = 3 then -- task 5, add in a knight
					curPiece := "11"; -- piece is knight
				else
					if sw(2) = '1' then -- piece is rook
						curPiece := "10";
					elsif sw(2) = '0' then -- piece is bishop
						curPiece := "01";
					end if;
				end if;
			else
				curPiece := "00"; -- no chess piece
			end if;
			Pieces <= curPiece;
			
		end if;
	end process;

end Behavioral;

