----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:09:43 04/09/2010 
-- Design Name: 
-- Module Name:    VGAController - Behavioral 
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
--use ieee.numeric_std.all;

entity VGAController is
  Port (mclk: in std_logic;  -- 50MHz
--        Hcnt: in std_logic_vector(9 downto 0);      -- horizontal counter
--        Vcnt: in std_logic_vector(9 downto 0);      -- verical counter
        HS: out std_logic;					-- horizontal synchro signal					
        VS: out std_logic;					-- verical synchro signal 
		  
		  reset : in std_logic;
		  -- layout variable
		  ChangeColorEn : in  STD_LOGIC_VECTOR (1 downto 0);
        Pieces : in  STD_LOGIC_VECTOR (1 downto 0);
		  -- current position of the chess piece
		  pieceRow : in std_logic_vector(3 downto 0);
		  pieceCol : in std_logic_vector(3 downto 0);

        outRed  : out std_logic_vector(2 downto 0); -- final color
        outGreen: out std_logic_vector(2 downto 0);	 -- outputs
        outBlue : out std_logic_vector(2 downto 1)
		  );
end VGAController;

architecture Behavioral of VGAController is

-- constants for Synchro module
  constant PAL:integer:=640;		--Pixels/Active Line (pixels)
  constant LAF:integer:=480;		--Lines/Active Frame (lines)
  constant PLD: integer:=800;	--Pixel/Line Divider
  constant LFD: integer:=521;	--Line/Frame Divider
  constant HPW:integer:=96;		--Horizontal synchro Pulse Width (pixels)
  constant HFP:integer:=16;		--Horizontal synchro Front Porch (pixels)
--  constant HBP:integer:=48;		--Horizontal synchro Back Porch (pixels)
  constant VPW:integer:=2;		--Verical synchro Pulse Width (lines)
  constant VFP:integer:=10;		--Verical synchro Front Porch (lines)
--  constant VBP:integer:=29;		--Verical synchro Back Porch (lines)

-- constants for chess square
	constant WIDTH:integer:=80; -- pixels
	constant HEIGHT:integer:=60; -- pixels
	-- current color for squares and piece
	signal color1 : std_logic_vector(5 downto 0);
	signal color2 : std_logic_vector(5 downto 0);
	signal pieceColor : std_logic_vector(5 downto 0);
	signal intColor1 : integer range 0 to 15;
	signal intColor2 : integer range 0 to 15;
	signal intPieceColor : integer range 0 to 15;
	type color_type is array (0 to 15) of std_logic_vector(0 to 5);
	constant color16 : color_type :=
	(
		"111111",--white
		"001111",--yellow
		"110011",--fuchsia (kinda pink)
		"000011",--red
		"101010",--silver
		"010101",--gray
		"000101",--olive
		"010001",--purple
		"000001",--maroon
		"111100",--aqua
		"001100",--lime
		"010100",--teal
		"000100",--green
		"110000",--blue
		"010000",--navy
		"000000" --black
	);

	-- enable drawing piece signal
	signal DrawEn : std_logic;

-- signals for VGA Demo
  signal Hcnt: std_logic_vector(9 downto 0);      -- horizontal counter
  signal Vcnt: std_logic_vector(9 downto 0);      -- verical counter
  signal intHcnt: integer range 0 to 800-1; --PLD-1 - horizontal counter
  signal intVcnt: integer range 0 to 521-1; -- LFD-1 - verical counter

	signal ck25MHz: std_logic;		-- ck 25MHz

begin

	-- divide 50MHz clock to 25MHz
  div2: process(mclk)
  begin
    if mclk'event and mclk = '1' then
	   ck25MHz <= not ck25MHz; 
    end if;
  end process;	
  
  
  syncro: process (ck25MHz)
  begin

  if ck25MHz'event and ck25MHz='1' then
    if intHcnt=PLD-1 then
       intHcnt<=0;
      if intVcnt=LFD-1 then intVcnt<=0;
      else intVcnt<=intVcnt+1;
      end if;
    else intHcnt<=intHcnt+1;
    end if;
	
	-- Generates HS - active low
	if intHcnt=PAL-1+HFP then 
		HS<='0';
	elsif intHcnt=PAL-1+HFP+HPW then 
		HS<='1';
	end if;

	-- Generates VS - active low
	if intVcnt=LAF-1+VFP then 
		VS<='0';
	elsif intVcnt=LAF-1+VFP+VPW then
		VS<='1';
	end if;
end if;
end process; 

-- mapping itnernal integers to std_logic_vector ports
  Hcnt <= conv_std_logic_vector(intHcnt,10);
  Vcnt <= conv_std_logic_vector(intVcnt,10);
  
  -- changing color
  color1 <= color16(intColor1) when ChangeColorEn = "01" and rising_edge(ck25MHz);
  color2 <= color16(intColor2) when ChangeColorEn = "10" and rising_edge(ck25MHz);
  pieceColor <= color16(intPieceColor) when ChangeColorEn = "11" and rising_edge(ck25MHz);
  
  mixer: process(ck25MHz,intHcnt, intVcnt, reset, ChangeColorEn, DrawEn) 
	variable row,col,temp: integer;
  begin
	 if reset = '1' then
		intColor1 <= 15; -- black
		intColor2 <= 0; -- white
		intPieceColor <= 7; -- some color
		
	 elsif rising_edge(ck25MHz) then
			-- color changing
		if ChangeColorEn = "01" then -- color 1
			intColor1 <= intColor1 + 1;
		elsif ChangeColorEn = "10" then -- color 2
			intColor2 <= intColor2 + 1;
		elsif ChangeColorEn = "11" then -- piece color
			intPieceColor <= intPieceColor + 1;
		else -- not changing color
			-- do nothing for now
		end if;
		
	 end if;
	 
	 -- drawing chess board, colors, pieces
    if intHcnt < PAL and intVcnt < LAF then	-- in the active screen
		if intHcnt < WIDTH*1 then
			col := 0;
		elsif intHcnt < WIDTH*2 then
			col := 1;
		elsif intHcnt < WIDTH*3 then
			col := 2;
		elsif intHcnt < WIDTH*4 then
			col := 3;
		elsif intHcnt < WIDTH*5 then
			col := 4;
		elsif intHcnt < WIDTH*6 then
			col := 5;
		elsif intHcnt < WIDTH*7 then
			col := 6;
		elsif intHcnt < WIDTH*8 then
			col := 7;
		end if;
		
		if intVcnt < HEIGHT*1 then
			row := 0;
		elsif intVcnt < HEIGHT*2 then
			row := 1;
		elsif intVcnt < HEIGHT*3 then
			row := 2;
		elsif intVcnt < HEIGHT*4 then
			row := 3;
		elsif intVcnt < HEIGHT*5 then
			row := 4;
		elsif intVcnt < HEIGHT*6 then
			row := 5;
		elsif intVcnt < HEIGHT*7 then
			row := 6;
		elsif intVcnt < HEIGHT*8 then
			row := 7;
		end if;

		-- drawing chess board, default with black and white
		if (row mod 2) = 0 then -- even row
			if (col mod 2) = 0 then -- even column
				outRed(2 downto 1) <= color1(1 downto 0);
				outGreen(2 downto 1) <= color1(3 downto 2);
				outBlue <= color1(5 downto 4);
			else -- odd column
				outRed(2 downto 1) <= color2(1 downto 0);
				outGreen(2 downto 1) <= color2(3 downto 2);
				outBlue <= color2(5 downto 4);
			end if;
		else -- odd row
			if (col mod 2) /= 0 then -- odd column
				outRed(2 downto 1) <= color1(1 downto 0);
				outGreen(2 downto 1) <= color1(3 downto 2);
				outBlue <= color1(5 downto 4);
			else -- even column
				outRed(2 downto 1) <= color2(1 downto 0);
				outGreen(2 downto 1) <= color2(3 downto 2);
				outBlue <= color2(5 downto 4);
			end if;
		end if;
		
		--------------------------------------------------
		-- Drawing chess piece
		-- 
		-- signal DrawEn is the output from DrawPiece port map below
		--
		if DrawEn = '1' then
			outRed(2 downto 1) <= pieceColor(1 downto 0);
			outGreen(2 downto 1) <= pieceColor(3 downto 2);
			outBlue <= pieceColor(5 downto 4);
		end if;
		
    else -- outside visible screen, set all to black
         outRed <= (others => '0'); 
         outGreen <= (others => '0'); 
         outBlue <= (others => '0'); 
    end if;   
  end process;
  
  -- port map for piece drawing
  DrawPieces_inst: entity work.DrawPieces
    Port map ( clk => mclk,
           Hcnt => Hcnt,
           Vcnt => Vcnt,
			  Pieces => Pieces,
			  pieceCol => pieceCol,
			  pieceRow => pieceRow,
           DrawEn => DrawEn);

end Behavioral;
