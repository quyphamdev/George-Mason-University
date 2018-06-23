----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:34:45 05/10/2010 
-- Design Name: 
-- Module Name:    PRNG - Behavioral 
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

entity PRNG is
    Port ( clk : in  STD_LOGIC;
           PRNG_ctrl : in  STD_LOGIC;
			  reset : in std_logic;
			  soft_reset : in std_logic;
			  init : in std_logic;
			  RD : out  STD_LOGIC_VECTOR (7 downto 0);
			  RA : out  STD_LOGIC_VECTOR (7 downto 0);
			  PRNG_status : out std_logic;
           R_wen : out  STD_LOGIC;
           rinit : out  STD_LOGIC);
end PRNG;

architecture Behavioral of PRNG is
signal R : std_logic_vector(7 downto 0);
signal x : std_logic;
signal set : std_logic_vector(7 downto 0);
signal en : std_logic;
signal addr : std_logic_vector(8 downto 0);
--signal soft_reset : std_logic;
signal done_gen : std_logic;
begin
	-- at configuration, init ram data same as their addresses
	process(clk, reset, init, PRNG_ctrl, en)
		variable counter : integer;
	begin
		if reset = '1' then
			addr <= (others => '0');
			--soft_reset <= '0';
			RD <= (others => '0');
			RA <= (others => '0');
			PRNG_status <= '1';
			R_wen <= '0';
			rinit <= '0';
			--en <= '0';
			counter := 0;
			done_gen <= '0';
		elsif rising_edge(clk) then
			if init = '1' then -- configuration
				if addr < 256 then
					PRNG_status <= '0'; -- during initialization
					-- data with value same as its address
					RD <= addr(7 downto 0);
					RA <= addr(7 downto 0);
					-- write to ram block
					R_wen <= '1';
					rinit <= '1';
					addr <= addr + 1; -- next ram address
				else -- filled up 256 ram locations
					PRNG_status <= '1'; -- done with init
					addr <= (others => '0'); -- reset to addr 0
					-- stop write to ram
					R_wen <= '0';
					rinit <= '0';
				end if;
			else -- in middle of program running
				if en = '1' then -- PRNG_ctrl is set
					PRNG_status <= '0'; -- during random gen for ram
					counter := counter + 1; -- count to 8
					if counter = 8 then -- output random num every 8 clk cycles
						counter := 0;
						-- write random num to ram at addr address
						RA <= addr(7 downto 0);
						RD <= R;
						-- enable signal to write to ram
						R_wen <= '1';
						rinit <= '1';
						if addr < 256 then -- 0..255
							addr <= addr + 1;
							done_gen <= '0'; -- need to generate 256 nums
						else
							addr <= (others => '0');
							done_gen <= '1';
							--en <= '0'; -- disable to keep current random num for next generation
						end if;
					else
						-- only enable to write to ram every 8 clk cycles
						R_wen <= '0';
						rinit <= '0';
					end if;
				else
					PRNG_status <= '1';
				end if;
			end if;
		end if;
	end process;
	
	-- clear status when ctrl is set
	--PRNG_status <= '0' when PRNG_ctrl = '1';
	en <= '1' when PRNG_ctrl = '1' else '0' when done_gen = '1' else '0';
	-- soft reset, init with 0x25
	set <= x"25" when soft_reset = '1' else (others => '0');
	-- xor
	x <= R(0) xor R(2) xor R(3) xor R(7);
	
	d7_inst: entity work.D_FF
		port map (
			clk => clk,
			set => set(7),
			en => en,
			D => x,
			Q => R(7));
	d6_inst: entity work.D_FF
		port map (
			clk => clk,
			set => set(6),
			en => en,
			D => R(7),
			Q => R(6));
	d5_inst: entity work.D_FF
		port map (
			clk => clk,
			set => set(5),
			en => en,
			D => R(6),
			Q => R(5));
	d4_inst: entity work.D_FF
		port map (
			clk => clk,
			set => set(4),
			en => en,
			D => R(5),
			Q => R(4));
	d3_inst: entity work.D_FF
		port map (
			clk => clk,
			set => set(3),
			en => en,
			D => R(4),
			Q => R(3));
	d2_inst: entity work.D_FF
		port map (
			clk => clk,
			set => set(2),
			en => en,
			D => R(3),
			Q => R(2));
	d1_inst: entity work.D_FF
		port map (
			clk => clk,
			set => set(1),
			en => en,
			D => R(2),
			Q => R(1));
	d0_inst: entity work.D_FF
		port map (
			clk => clk,
			set => set(0),
			en => en,
			D => R(1),
			Q => R(0));
	

end Behavioral;

