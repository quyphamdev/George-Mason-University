library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity Spartan3E is
	port(
		-- Clocks
		mclk		: in	std_logic;
		-- VGA signals
		HS: out std_logic;					-- horizontal synchro signal					
      VS: out std_logic;					-- verical synchro signal 
      OutRed  : out std_logic_vector(2 downto 0); -- final color
      OutGreen: out std_logic_vector(2 downto 0);	 -- outputs
      OutBlue : out std_logic_vector(2 downto 1);
		-- LEDs
		led			: out	std_logic_vector(7 downto 0); -- Active High LEDs
		-- Seven Segment Display
		seg			: out	std_logic_vector(7 downto 0);
		an			: out	std_logic_vector(3 downto 0);
		-- Rotary button and switches
		sw			: in	std_logic_vector(7 downto 0);
		btn			: in	std_logic_vector(3 downto 0));
end entity Spartan3E;

architecture RTL of Spartan3E is

	COMPONENT DCMSP_Clocks
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;
	
	-- DCM signals
	signal reset	: std_logic;
	signal clk0		: std_logic;
	signal clk1k	: std_logic;
	signal locked : std_logic;
	-- LED signals
	signal illegalMove	: std_logic;
	-- Seven Segment Signals
	signal seg_i	: std_logic_vector(15 downto 0);
	-- Other signals
	signal button	: std_logic_vector(03 downto 0);
	-- InputController signals
	signal ChangeColorEn : STD_LOGIC_VECTOR (1 downto 0);
	signal comboMoveOn : std_logic;
   signal Pieces : STD_LOGIC_VECTOR (1 downto 0);
	signal pieceCol : std_logic_vector(3 downto 0);
	signal pieceRow : std_logic_vector(3 downto 0);

begin
	----------------------------------------------------------------
	-- MAP THE OUTPUTS
	----------------------------------------------------------------
	-- I have started this for you.  This is very useful for
	--  debugging, so I hope you use it as such.
	-- Tie off LEDs
	LED	<= (7		=> illegalMove,
			6		=> clk0,
			5		=> clk1k,
			4		=> comboMoveOn,
			3		=> button(3),
			2		=> button(2),
			1		=> button(1),
			0		=> button(0));

	VGCController_inst : entity work.VGAController
      port map (
		          mclk=>clk0,
					 reset=>reset,
                HS=>HS,
                VS=>VS,
					 ChangeColorEn => ChangeColorEn,
					 pieceRow => pieceRow,
					 pieceCol => pieceCol,
					 Pieces => Pieces,
                outRed(2 downto 0)=>OutRed(2 downto 0),
                outGreen(2 downto 0)=>OutGreen(2 downto 0),
                outBlue(2 downto 1)=>OutBlue(2 downto 1)
					 );


	InputController_inst : entity work.InputController
    Port map (
				clk => clk0,
           sw => sw,
			  reset => reset,
           button => button,
			  illegalMove => illegalMove,
           ChangeColorEn => ChangeColorEn,
			  comboMoveOn => comboMoveOn,
			  pieceRow => pieceRow,
			  pieceCol => pieceCol,
           Pieces => Pieces);

	----------------------------------------------------------------
	-- Background circuitry
	----------------------------------------------------------------
	-- Clock Generation
	--  You will need to attach your clock circuit here
	DCMSP_Clocks_inst: DCMSP_Clocks PORT MAP(
		CLKIN_IN => mclk,
		--CLKIN_IBUFG_OUT => open,
		CLK0_OUT => clk0,
		LOCKED_OUT => locked
	);
	reset <= not locked;
	
	----------------------------------------------------------------
	-- Surrounding parts
	----------------------------------------------------------------
	-- Buttons and Switches debouncing
	debounce_inst : entity work.debounce
		port map(
			clk		=> clk1k,
			btn		=> btn,
			button	=> button);

	SSegInst : entity work.SSegCtrl
		port map(
			clk			=> clk1k,
			seg_i		=> seg_i,
			SSegCA		=> seg,
			SSegAN		=> an);
	
	-- show current task on the 7-segment display
	with sw(3) & sw(1 downto 0) select
		seg_i <= x"0001" when "000"|"100",
					x"0002" when "001"|"101",
					x"0003" when "010"|"110",
					x"0004" when "011",
					x"0005" when others; -- "111";
			
	-- Clk 1k generator
	clk1k_gen_inst: entity work.clk1k_gen
		port map (
			clk0 => clk0,
			reset => reset,
			clk1k => clk1k);
			
	
end architecture RTL;
