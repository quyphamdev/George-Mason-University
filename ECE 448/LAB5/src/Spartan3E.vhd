library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	--use work.MyLibrary.all;

entity Spartan3E is
	port(
		-- Clocks
		mclk		: in	std_logic;
		-- LEDs
		led			: out	std_logic_vector(7 downto 0); -- Active High LEDs
		-- Extension ports
		JA			: in	std_logic_vector(3 downto 0);	-- RX
		JD			: out	std_logic_vector(3 downto 0);	-- TX
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
		CLK180_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

	component FIFO
		port (
			din: IN std_logic_VECTOR(7 downto 0);
			rd_clk: IN std_logic;
			rd_en: IN std_logic;
			wr_clk: IN std_logic;
			wr_en: IN std_logic;
			dout: OUT std_logic_VECTOR(7 downto 0);
			empty: OUT std_logic;
			full: OUT std_logic);
	end component;
	-- Synplicity black box declaration
	attribute syn_black_box : boolean;
	attribute syn_black_box of FIFO: component is true;

	-- Some HDLC signals.  You'll need more
	signal txd		: std_logic;
	signal tx_en 	: std_logic;
	signal tx_clk0_180 : std_logic;
	signal rxd		: std_logic;
	signal rx_clk	: std_logic;
	-- DCM signals
	signal reset	: std_logic;
	signal clk0		: std_logic;
	signal clk0_180	: std_logic;
	signal clk1k	: std_logic;
	signal locked : std_logic;
	-- LED signals
	signal dcm_lock	: std_logic;
	-- Seven Segment Signals
	signal seg_i	: std_logic_vector(15 downto 0);
	-- Other signals
	signal button	: std_logic_vector(03 downto 0);
	signal out_led : std_logic_vector(1 downto 0);
	-- FIFO signals
	signal din : std_logic_vector(7 downto 0);
	signal wr_en : std_logic;
	signal wr_clk : std_logic;
	signal rd_clk : std_logic;
	signal dout : std_logic_vector(7 downto 0);
	signal rd_en : std_logic;
	signal empty : std_logic;
	signal full : std_logic;

begin
	----------------------------------------------------------------
	-- MAP THE OUTPUTS
	----------------------------------------------------------------
	-- I have started this for you.  This is very useful for
	--  debugging, so I hope you use it as such.
	dcm_lock	<= not reset;
	-- Tie off LEDs
	LED	<= (7		=> dcm_lock,
			6		=> clk0,
			5		=> out_led(1),--JA(3),
			4		=> out_led(0),--JA(2),
			3		=> empty,--button(3),
			2		=> full,--button(2),
			1		=> button(1),
			0		=> button(0));
	seg_i(15 downto 8)	<= sw;

	----------------------------------------------------------------
	-- HDLC parts
	----------------------------------------------------------------
	-- This is where you will be putting your UART.  I have done
	--  the preliminary mapping for you
	JD(0)	<= txd;
	JD(1)	<= tx_clk0_180;
	JD(2)	<= '1';
	JD(3)	<= '0';
	rxd		<= JA(0);
	rx_clk	<= JA(1);

	----------------------------------------------------------------
	-- Background circuitry
	----------------------------------------------------------------
	-- Clock Generation
	--  You will need to attach your clock circuit here
	DCMSP_Clocks_inst: DCMSP_Clocks PORT MAP(
		CLKIN_IN => mclk,
		--CLKIN_IBUFG_OUT => open,
		CLK0_OUT => clk0,
		CLK180_OUT => clk0_180,
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
			
	seg_i(7 downto 0) <= dout;

	-- reciever
	wr_clk <= rx_clk;
	rx_inst: entity work.rx
		port map(
				rxd => rxd,
           rx_clk => rx_clk,
			  reset => reset,
           data8 => din,
           wr_en => wr_en);
			  
	-- transmitter
	tx_inst: entity work.tx
		port map (
				clk0 => clk0,
           tx_en => tx_en,
			  reset => reset,
           data8 => sw,
           txd => txd,
           clk0_180 => tx_clk0_180);
			  
	-- FIFO
	fifo_inst : FIFO
		port map (
			din => din,
			rd_clk => clk1k,
			rd_en => rd_en,
			wr_clk => rx_clk,
			wr_en => wr_en,
			dout => dout,
			empty => empty,
			full => full);
			
	-- Clk 1k generator
	clk1k_gen_inst: entity work.clk1k_gen
		port map (
			clk0 => clk0,
			reset => reset,
			clk1k => clk1k);
			
	-- Rising Edge detectors
	-- for fifo
	red0_inst: entity work.RED
		port map(
			clk => clk1k,
			button => button(0),
			reset => reset,
			en => rd_en);
	-- for TX
	red1_inst: entity work.RED
		port map(
			clk => clk0,
			button => button(1),
			reset => reset,
			en => tx_en);
		
--	CheckLED0_inst: entity work.CheckLED
--		Port map (
--				clk => clk1k,
--				reset => reset,
--           red_in => rd_en,
--           out_led => out_led(0));
			  
	--CheckLED5_inst: entity work.CheckLED
--		Port map (
--				clk => clk0,
--				reset => reset,
--           red_in => tx_en,
--           out_led => out_led(1));
--			  
--	CheckLED4_inst: entity work.CheckLED
--		Port map (
--				clk => wr_clk,
--				reset => reset,
--           red_in => wr_en,
--           out_led => out_led(0));
	
end architecture RTL;
