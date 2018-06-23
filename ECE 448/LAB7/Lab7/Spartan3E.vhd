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
		-- Seven Segment Display
		seg			: out	std_logic_vector(7 downto 0);
		an			: out	std_logic_vector(3 downto 0);
		-- Rotary button and switches
		sw			: in	std_logic_vector(7 downto 0);
		btn			: in	std_logic_vector(3 downto 0));
end entity Spartan3E;

architecture RTL of Spartan3E is

	component embedded_kcpsm3
    Port (      port_id : out std_logic_vector(7 downto 0);
           write_strobe : out std_logic;
            read_strobe : out std_logic;
               out_port : out std_logic_vector(7 downto 0);
                in_port : in std_logic_vector(7 downto 0);
              interrupt : in std_logic;
          interrupt_ack : out std_logic;
                  reset : in std_logic;
                    clk : in std_logic);
	end component;

	COMPONENT DCMSP_Clocks
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		CLK180_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;
	
	component data_ram_e
	port (
		clka: IN std_logic;
		ena: IN std_logic;
		wea: IN std_logic_VECTOR(0 downto 0);
		addra: IN std_logic_VECTOR(7 downto 0);
		dina: IN std_logic_VECTOR(7 downto 0);
		douta: OUT std_logic_VECTOR(7 downto 0));
	end component;

	-- Synplicity black box declaration
	attribute syn_black_box : boolean;
	attribute syn_black_box of data_ram_e: component is true;

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
	signal btn_debounce	: std_logic_vector(3 downto 0);
	signal out_led : std_logic_vector(1 downto 0);
	-- kcpsm signals
	signal port_id : std_logic_vector(7 downto 0);
   signal write_strobe : std_logic;
	signal read_strobe : std_logic;
	signal out_port : std_logic_vector(7 downto 0);
	signal in_port : std_logic_vector(7 downto 0);
	signal interrupt : std_logic;
	signal interrupt_ack : std_logic;
	-- data ram signals
	signal RAM_wen : std_logic;	
	signal we : std_logic_vector(0 downto 0);
	signal addr : std_logic_vector(7 downto 0);
	signal din : std_logic_vector(7 downto 0);
	signal dout : std_logic_vector(7 downto 0);
	-- PRNG signals
	signal rinit : std_logic;
	signal R_wen : std_logic;
	signal RA : std_logic_vector(7 downto 0);
	signal RD : std_logic_vector(7 downto 0);
	signal init : std_logic;
	signal soft_reset : std_logic;
	-- address decoder signals
	signal en_regs : std_logic_vector(8 downto 0);
	signal in_port_sel : std_logic_vector(1 downto 0);
	signal A9 : std_logic_vector(8 downto 0);
	-- enable signals
	signal SSD3_en : std_logic;
	signal SSD2_en : std_logic;
	signal SSD1_en : std_logic;
	signal SSD0_en : std_logic;
	signal MEM_BANK_en : std_logic;
	signal PRNG_CTRL_en : std_logic;
	--signal RAM_wen : std_logic;
	signal RAM_ren : std_logic;
	signal init_en : std_logic;
	-- registers
	signal button_reg	: std_logic_vector(7 downto 0);
	signal switch_reg : std_logic_vector(7 downto 0);
	signal prng_status_reg : std_logic_vector(7 downto 0);
	signal prng_ctrl_reg : std_logic_vector(7 downto 0);
	signal ssd3_reg : std_logic_vector(7 downto 0);
	signal ssd2_reg : std_logic_vector(7 downto 0);
	signal ssd1_reg : std_logic_vector(7 downto 0);
	signal ssd0_reg : std_logic_vector(7 downto 0);
	signal mem_bank_reg : std_logic_vector(7 downto 0);
	signal init_reg : std_logic_vector(7 downto 0);

begin
	----------------------------------------------------------------
	-- KCPSM & ROM
	----------------------------------------------------------------
	Embedded_kcpsm3_inst: embedded_kcpsm3 port map (
					 port_id => port_id,
           write_strobe => write_strobe,
            read_strobe => read_strobe,
               out_port => out_port,
                in_port => in_port,
              interrupt => interrupt,
          interrupt_ack => interrupt_ack,
                  reset => reset,
                    clk => clk0);

	----------------------------------------------------------------
	-- RAM
	----------------------------------------------------------------
	data_ram_e_inst : data_ram_e
		port map (
			clka => clk0,
			ena => RAM_ren,
			wea => we,
			addra => addr,
			dina => din,
			douta => dout);
			
	we(0) <= RAM_wen or R_wen;
	with rinit select
		addr <= 	port_id when '0',
					RA when others;
	with rinit select
		din <=	out_port when '0',
					RD when others;
					
	----------------------------------------------------------------
	-- Input Interface
	----------------------------------------------------------------
	Input_Interface_inst: entity work.Input_Interface
    port map (
			  btn => btn,
           sw => sw,
           clk => clk0,
			  reset => reset,
			  interrupt_ack => interrupt_ack,
			  interrupt => interrupt,
           button => button_reg,
           switch => switch_reg);

	
	----------------------------------------------------------------
	-- ADDRESS DECODER
	----------------------------------------------------------------
	addr_decoder_inst: entity work.addr_decoder
		port map (
				A9 => A9,
           read_strobe => read_strobe,
           write_strobe => write_strobe,
			  clk => clk0,
			  reset => reset,
			  en_regs => en_regs,
           in_port_sel => in_port_sel);
			  
	A9 <= mem_bank_reg(0) & port_id;
	-- route to enable signals
	SSD3_en <= en_regs(0);
	SSD2_en <= en_regs(1);
	SSD1_en <= en_regs(2);
	SSD0_en <= en_regs(3);
	PRNG_CTRL_en <= en_regs(4);
	MEM_BANK_en <= en_regs(5);
	RAM_wen <= en_regs(6);
	RAM_ren <= en_regs(7);
	init_en <= en_regs(8);
	
	-- mem_bank reg
	mem_bank_reg_inst: entity work.reg8
		port map (
			clk => clk0,
			reset => reset,
			en => MEM_BANK_en,
			D => out_port,
			Q => mem_bank_reg);
	
	----------------------------------------------------------------
	-- Programmable Pseudorandom Number Generator - PRNG
	----------------------------------------------------------------
	PRNG_inst: entity work.PRNG
		port map ( 
				clk => clk0,
           PRNG_ctrl => prng_ctrl_reg(0),
			  reset => reset,
			  soft_reset => soft_reset, -- went thru RED
			  init => init_reg(0),
			  RD => RD,
			  RA => RA,
			  PRNG_status => prng_status_reg(0),
           R_wen => R_wen,
           rinit => rinit);
	
	-- soft reset on switch 0
	red_sw_inst: entity work.RED
		port map(
			clk => clk1k,
			button => sw(0),
			reset => reset,
			en => soft_reset);
			
	-- init reg
	init_reg_inst: entity work.reg8
		port map (
			clk => clk0,
			reset => reset,
			en => init_en,
			D => out_port,
			Q => init_reg);
	
	-- PRNG_CTRL reg
	PRNG_CTRL_reg_inst: entity work.reg8
		port map (
			clk => clk0,
			reset => reset,
			en => PRNG_CTRL_en,
			D => out_port,
			Q => prng_ctrl_reg);
	
	----------------------------------------------------------------
	-- in_port MUX
	----------------------------------------------------------------
	with in_port_sel select
		in_port <=	button_reg when "00",
						dout when "01", -- data ram
						switch_reg when "10",
						prng_status_reg when others;
							
	----------------------------------------------------------------
	-- Output interface
	----------------------------------------------------------------
	-- 7-seg display 3
	ssd3_reg_inst: entity work.reg8
		port map (
			clk => clk0,
			reset => reset,
			en => SSD3_en,
			D => out_port,
			Q => ssd3_reg);
			
	-- 7-seg display 2
	ssd2_reg_inst: entity work.reg8
		port map (
			clk => clk0,
			reset => reset,
			en => SSD2_en,
			D => out_port,
			Q => ssd2_reg);
			
	-- 7-seg display 1
	ssd1_reg_inst: entity work.reg8
		port map (
			clk => clk0,
			reset => reset,
			en => SSD1_en,
			D => out_port,
			Q => ssd1_reg);
			
	-- 7-seg display 3
	ssd0_reg_inst: entity work.reg8
		port map (
			clk => clk0,
			reset => reset,
			en => SSD0_en,
			D => out_port,
			Q => ssd0_reg);
			
	seg_i(15 downto 12) <= ssd0_reg(7 downto 4); -- ssd0
	seg_i(11 downto 8) <= ssd1_reg(3 downto 0); -- ssd1
	seg_i(7 downto 4) <= ssd2_reg(7 downto 4); -- ssd2
	seg_i(3 downto 0) <= ssd3_reg(3 downto 0); -- ssd3
	
	----------------------------------------------------------------
	-- MAP THE OUTPUTS (most of below codes are from lab 5)
	----------------------------------------------------------------
	-- I have started this for you.  This is very useful for
	--  debugging, so I hope you use it as such.
	dcm_lock	<= not reset;
	-- Tie off LEDs
	LED	<= (7		=> dcm_lock,
			6		=> clk0,
			5		=> mem_bank_reg(0),
			4		=> prng_ctrl_reg(0),
			3		=> button_reg(3),
			2		=> button_reg(2),
			1		=> button_reg(1),
			0		=> button_reg(0));
	--seg_i(15 downto 8)	<= sw;

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
			button	=> btn_debounce);

	SSegInst : entity work.SSegCtrl
		port map(
			clk			=> clk1k,
			seg_i		=> seg_i,
			SSegCA		=> seg,
			SSegAN		=> an);
			
	--seg_i(7 downto 0) <= dout;
			
	-- Clk 1k generator
	clk1k_gen_inst: entity work.clk1k_gen
		port map (
			clk0 => clk0,
			reset => reset,
			clk1k => clk1k);
	
	
end architecture RTL;
