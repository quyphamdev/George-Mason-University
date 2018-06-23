----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:56:09 05/09/2010 
-- Design Name: 
-- Module Name:    Input_Interface - Behavioral 
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

entity Input_Interface is
    Port ( btn : in  STD_LOGIC_VECTOR (3 downto 0);
           sw : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in std_logic;
			  reset : in std_logic;
			  interrupt_ack : in  STD_LOGIC;
			  interrupt : out  STD_LOGIC;
           button : out  STD_LOGIC_VECTOR (7 downto 0);
           switch : out  STD_LOGIC_VECTOR (7 downto 0));
end Input_Interface;

architecture Behavioral of Input_Interface is
signal b : std_logic_vector(3 downto 0);
signal s : std_logic_vector(7 downto 0);
signal A : std_logic;
begin
	-- Rising Edge detectors
	--
	red0_inst: entity work.RED
		port map(
			clk => clk,
			button => btn(0),
			reset => reset,
			en => b(0));
	-- 
	red1_inst: entity work.RED
		port map(
			clk => clk,
			button => btn(1),
			reset => reset,
			en => b(1));
	--
	red2_inst: entity work.RED
		port map(
			clk => clk,
			button => btn(2),
			reset => reset,
			en => b(2));
	-- 
	red3_inst: entity work.RED
		port map(
			clk => clk,
			button => btn(3),
			reset => reset,
			en => b(3));
			
	-- rising edge detector for switches
	-- switch 0, soft reset
	red4_inst: entity work.RED
		port map(
			clk => clk,
			button => sw(0),
			reset => reset,
			en => s(0));
	
	A <= b(0) or b(1) or b(2) or b(3);
	
	-- button register
	btn_pro: process(clk, reset, interrupt_ack)
	begin
		if reset = '1' then
			button <= (others => '0');
			switch <= (others => '0');
			interrupt <= '0';
		elsif rising_edge(clk) then
			if interrupt_ack = '0' then
				if A = '1' then
					button(7) <= A;
					button(3 downto 0) <= b;
				end if;
				if s(0) = '1' then
					switch <= s;
				end if;
				-- interrupt on buttons and switch 0 (soft reset)
				interrupt <= A;-- or s(0);
			else -- interrupt is acknowledged
				button <= (others => '0');
				switch <= (others => '0'); -- soft reset
				interrupt <= '0'; -- int ack
			end if;
		end if;
	end process;

end Behavioral;

