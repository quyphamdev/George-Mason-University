----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:50:23 04/09/2010 
-- Design Name: 
-- Module Name:    DrawPieces - Behavioral 
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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DrawPieces is
    Port ( clk : in  STD_LOGIC;
           Hcnt : in  STD_LOGIC_VECTOR (9 downto 0);
           Vcnt : in  STD_LOGIC_VECTOR (9 downto 0);
			  Pieces : in std_logic_vector(1 downto 0);
			  pieceCol : in std_logic_vector(3 downto 0);
			  pieceRow : in std_logic_vector(3 downto 0);
           DrawEn : out  STD_LOGIC);
end DrawPieces;

architecture Behavioral of DrawPieces is
	-- piece image ROM
	type rom_type is array (0 to 31) of std_logic_vector(0 to 31);
	constant IMAGE_SIZE : integer := 32;
	constant WIDTH : integer := 80;
	constant HEIGHT : integer := 60;
	constant BISHOP_ROM : rom_type :=
	(
		"00000000000000011000000000000000",
		"00000000000000011000000000000000",
		"00000000000011111111000000000000",
		"00000000000000011000000000000000",
		"00000000000000011000000000000000",
		"00000000000001111110000000000000",
		"00000000000111111111000000000000",
		"00000000001111111111110000000000",
		"00000000011111111111111000000000",
		"00000000011111111111111000000000",
		"00000000001111111111110000000000",
		"00000000000011111111000000000000",
		"00000000000001111110000000000000",
		"00000000000000111100000000000000",
		"00000000001111111111110000000000",
		"00000000011111111111111000000000",
		"00000000011111111111111000000000",
		"00000000001111111111110000000000",
		"00000000000011111111000000000000",
		"00000000000011111111000000000000",
		"00000000000111111111100000000000",
		"00000000000111111111100000000000",
		"00000000001111111111110000000000",
		"00000000001111111111110000000000",
		"00000000011111111111111000000000",
		"00000000111111111111111100000000",
		"00000001111111111111111110000000",
		"00000011111111111111111111000000",
		"00111111111111111111111111111100",
		"11111111111111111111111111111111",
		"11111111111111111111111111111111",
		"00111111111111111111111111111100"
	);
	constant ROOK_ROM : rom_type :=
	(
		"11111100000111111111100000111111",
		"11111100000111111111100000111111",
		"11111100000111111111100000111111",
		"11111100000111111111100000111111",
		"11111100000111111111100000111111",
		"00111111111111111111111111111100",
		"00011111111111111111111111111000",
		"00001111111111111111111111110000",
		"00111111111111111111111111111100",
		"01111111111111111111111111111110",
		"01111111111111111111111111111110",
		"01111111111111111111111111111110",
		"00111111111111111111111111111100",
		"00000001111111111111111110000000",
		"00000001111111111111111110000000",
		"00000001111111111111111110000000",
		"00000001111111111111111110000000",
		"00000001111111111111111110000000",
		"00000001111111111111111110000000",
		"00000001111111111111111110000000",
		"00000001111111111111111110000000",
		"00001111111111111111111111110000",
		"00011111111111111111111111111000",
		"00011111111111111111111111111000",
		"00011111111111111111111111111000",
		"00011111111111111111111111111000",
		"00000111111111111111111111100000",
		"01111111111111111111111111111110",
		"11111111111111111111111111111111",
		"11111111111111111111111111111111",
		"11111111111111111111111111111111",
		"00111111111111111111111111111100"
	);
	constant KNIGHT_ROM : rom_type :=
	(
		"00000000000000011100000000000000",
		"00000000000000001111100000000000",
		"00000000000001111111111100000000",
		"00000000000111111111111111100000",
		"00000000011111111111111111111000",
		"00000000111100111111111111111100",
		"00000001111111111111111111111110",
		"00000011111111111111111111111111",
		"00000111111111111111111111111111",
		"00001111111111111111111111111111",
		"00011111111111111111111111111111",
		"00011111111111111101111111111111",
		"00011111111111100000111111111111",
		"00001111111100000001111111111111",
		"00000111111000000011111111111111",
		"00000001110000000111111111111111",
		"00000000000000001111111111111110",
		"00000000000001111111111111111100",
		"00000000000111111111111111111000",
		"00000000001111111111111111110000",
		"00000000111111111111111111100000",
		"00000011111111111111111111000000",
		"00000111111111111111111111100000",
		"00001111111111111111111111100000",
		"00001111111111111111111111100000",
		"00001111111111111111111111100000",
		"00111111111111111111111111111100",
		"01111111111111111111111111111110",
		"11111111111111111111111111111111",
		"11111111111111111111111111111111",
		"01111111111111111111111111111110",
		"00111111111111111111111111111100"
	);
	-- piece image's left, right, top, bottom boundary
	signal piece_left : std_logic_vector(9 downto 0);
	signal piece_right : std_logic_vector(9 downto 0);
	signal piece_top : std_logic_vector(9 downto 0);
	signal piece_bottom : std_logic_vector(9 downto 0);
	-- rom indexes: i, j
	signal i : unsigned(4 downto 0);
	signal j : unsigned(4 downto 0);
	signal rom_image_vector : std_logic_vector(31 downto 0);
	signal rom_image_bit : std_logic;
	-- integers
	signal temp1,temp2,temp3,temp4, col, row : integer;
	-- boolean
	signal in_boundary : std_logic;
	
begin

	-- calculate piece's image boundary
	col <= conv_integer(unsigned(pieceCol));
	row <= conv_integer(unsigned(pieceRow));
	temp1 <= col*WIDTH + (WIDTH-IMAGE_SIZE)/2;
	piece_left <= conv_std_logic_vector(temp1,10);
	temp2 <= temp1 + IMAGE_SIZE;
	piece_right <= conv_std_logic_vector(temp2,10);
	temp3 <= row*HEIGHT + (HEIGHT-IMAGE_SIZE)/2;
	piece_top <= conv_std_logic_vector(temp3,10);
	temp4 <= temp3 + IMAGE_SIZE;
	piece_bottom <= conv_std_logic_vector(temp4,10);
	
	-- 
	i <= unsigned(Hcnt(4 downto 0)) - unsigned(piece_left(4 downto 0)); -- BISHOP_ROM[i][]
	j <= unsigned(Vcnt(4 downto 0)) - unsigned(piece_top(4 downto 0)); -- BISHOP_ROM[i][j]
	-- check if current pixel is in the piece's image boundary
	in_boundary <= '1' when (piece_left <= Hcnt) and (Hcnt <= piece_right) and (piece_top <= Vcnt) and (Vcnt <= piece_bottom)
							else '0';
	with Pieces select
			rom_image_vector <= BISHOP_ROM(conv_integer(j)) when "01",
									ROOK_ROM(conv_integer(j)) when "10",
									KNIGHT_ROM(conv_integer(j)) when "11",
									(others => '0') when others;
			
	rom_image_bit <= rom_image_vector(conv_integer(i));
	DrawEn <= '1' when in_boundary = '1' and rom_image_bit = '1' else '0';
	
end Behavioral;

