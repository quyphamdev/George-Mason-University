library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity SSegCtrl is
	port(
		Clk			: in	std_logic;
		-- Inputs
		seg_i		: in	std_logic_vector(15 downto 0);
		-- Outputs
		SSegCA		: out	std_logic_vector(7 downto 0);
		SSegAN		: out	std_logic_vector(3 downto 0));
end entity SSegCtrl;

architecture BEHAVIOR of SSegCtrl is
	--------------------------------
	-- CONSTANTS AND TYPES
	--------------------------------
	type StateType is (
		SSeg0,	-- Display Input0
		SSeg1,	-- Display Input1
		SSeg2,	-- Display Input2
		SSeg3);	-- Display Input3
	type SSegRamType is array (0 to 15) of std_logic_vector(7 downto 0);
	constant SSegRam	: SSegRamType	:= (
		x"C0",	-- 0
		x"F9",	-- 1
		x"A4",	-- 2
		x"B0",	-- 3
		x"99",	-- 4
		x"92",	-- 5
		x"82",	-- 6
		x"F8",	-- 7
		x"80",	-- 8
		x"90",	-- 9
		x"88",	-- A
		x"83",	-- B
		x"C6",	-- C
		x"A1",	-- D
		x"86",	-- E
		x"8E"		-- F
		--x"AF",	-- r
		--x"A3"	-- o
		);
	--------------------------------
	-- SIGNALS
	--------------------------------
	signal State	: StateType							:= SSeg0;
begin
	--------------------------------
	-- STATE MACHINE
	--------------------------------
	StateProc : process(clk)
	begin
		if rising_edge(clk) then
			case State is
				when SSeg0 =>
					State	<= SSeg1;
					SSegCA	<= SSegRam(to_integer(unsigned(seg_i(15 downto 12))));
					SSegAN	<= "0111";
				when SSeg1 =>
					State	<= SSeg2;
					SSegCA	<= SSegRam(to_integer(unsigned(seg_i(11 downto  8))));
					SSegAN	<= "1011";
				when SSeg2 =>
					State	<= SSeg3;
					SSegCA	<= SSegRam(to_integer(unsigned(seg_i( 7 downto  4))));
					SSegAN	<= "1101";
				when SSeg3 =>
					State	<= SSeg0;
					SSegCA	<= SSegRam(to_integer(unsigned(seg_i( 3 downto  0))));
					SSegAN	<= "1110";
			end case;
		end if;
	end process StateProc;

end architecture BEHAVIOR;