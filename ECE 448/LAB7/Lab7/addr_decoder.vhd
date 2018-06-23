----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:33:51 05/10/2010 
-- Design Name: 
-- Module Name:    addr_decoder - Behavioral 
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

entity addr_decoder is
    Port ( A9 : in  STD_LOGIC_VECTOR (8 downto 0);
           read_strobe : in  STD_LOGIC;
           write_strobe : in  STD_LOGIC;
			  clk : in std_logic;
			  reset : in std_logic;
			  en_regs : out std_logic_vector(8 downto 0);
           in_port_sel : out  STD_LOGIC_VECTOR (1 downto 0));
end addr_decoder;

architecture Behavioral of addr_decoder is
signal mem_bank : std_logic;
signal port_id : std_logic_vector(7 downto 0);
begin
	mem_bank <= A9(8);
	port_id <= A9(7 downto 0);
	
	with read_strobe & write_strobe & mem_bank & port_id select
						-- write to regs
		en_regs <= 	(0 => '1', others => '0') 		when "01100000001", -- SSD3_en
						(1 => '1', others => '0') 		when "01100000010", -- SSD2_en
						(2 => '1', others => '0') 		when "01100000011", -- SSD1_en
						(3 => '1', others => '0') 		when "01100000100", -- SSD0_en
						(4 => '1', others => '0') 		when "01100000111", -- PRNG_CTRL_en
						(5 => '1',6 => '1', others => '0') 	when "01111111111", -- MEM_BANK_en, RAM_wen
						(8 => '1', others => '0') 		when "01100001001", -- init_en
						(others => '0') 					when "01100000000", -- other
						-- write to ram
						(5 => '1',6 => '1', others => '0')	when "010--------", -- MEM_BANK_en, RAM_wen
						-- in read op
						(7 => '1', others => '0')		when "100--------", -- enable RAM_ren to read ram
						(others => '0')					when others;
						
	with read_strobe & mem_bank & port_id select
							-- read regs
		in_port_sel <= "00" when "1100000000", -- button
							"11" when "1100000110", -- PRNG_status
							"10" when "1100001000", -- switch
							-- read ram
							"01" when "10--------", -- ram
							"00" when others;
						

--	
--	-- write operations
--	process(clk, write_strobe, read_strobe)
--		variable v_en_regs : std_logic_vector(8 downto 0);
--		variable v_sel : std_logic_vector(1 downto 0);
--	begin
--		if reset = '1' then
--			v_en_regs := (others => '0');
--			v_sel := "00";
--		elsif rising_edge(clk) then
--			if write_strobe = '1' then
--				if mem_bank = '1' then -- write to upper addresses (registers)
--					case port_id is
--						when x"01" => v_en_regs := (0 => '1', others => '0'); -- SSD3_en
--						when x"02" => v_en_regs := (1 => '1', others => '0'); -- SSD2_en
--						when x"03" => v_en_regs := (2 => '1', others => '0'); -- SSD1_en
--						when x"04" => v_en_regs := (3 => '1', others => '0'); -- SSD0_en
--						when x"07" => v_en_regs := (4 => '1', others => '0'); -- PRNG_CTRL_en
--						when x"FF" => v_en_regs := (5 => '1', others => '0'); -- MEM_BANK_en
--						when x"09" => v_en_regs := (8 => '1', others => '0'); -- init_en
--						when others => v_en_regs := (others => '0');
--					end case;
--					-- when write to mem_bank, need to write to both mem_bank reg and mem_bank in ram
--					if port_id = x"FF" then
--						v_en_regs(6) := '1'; -- RAM_wen
--					end if;
--				else -- write to lower addresses (data ram)
--					v_en_regs := (6 => '1', others => '0'); -- RAM_wen
--					-- when write to mem_bank, need to write to both mem_bank reg and mem_bank in ram
--					if port_id = x"FF" then
--						v_en_regs(5) := '1'; -- MEM_BANK_en
--					end if;
--				end if;
--				en_regs <= v_en_regs;
--			elsif read_strobe = '1' then
--				if mem_bank = '1' then -- read registers' data (higher address)
--					case port_id is
--						when x"00" => v_sel := "00"; -- button
--						when x"06" => v_sel := "11"; -- PRNG_STATUS
--						when x"08" => v_sel := "10"; -- switch
--						when others => v_sel := "XX"; -- unknown
--					end case;
--					en_regs <= (others => '0');
--				else -- read block ram's data (lower address)
--					v_sel := "01"; -- ram
--					en_regs <= (7 => '1', others => '0'); -- RAM_ren, enable ram read
--				end if;
--				in_port_sel <= v_sel;
--			end if;
--		end if;
--	end process;

end Behavioral;

