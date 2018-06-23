----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:54:26 03/31/2010 
-- Design Name: 
-- Module Name:    tx - Behavioral 
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

entity tx is
    Port ( clk0 : in  STD_LOGIC;
           tx_en : in  STD_LOGIC;
			  reset : in std_logic;
           data8 : in  STD_LOGIC_VECTOR (7 downto 0);
           txd : out  STD_LOGIC;
           clk0_180 : out  STD_LOGIC);
end tx;

architecture Behavioral of tx is

begin
	process(clk0, tx_en)
	variable flag : std_logic_vector(7 downto 0);
	variable dat8 : std_logic_vector(7 downto 0);
	variable count : std_logic_vector(3 downto 0);
	variable count_one : std_logic_vector(2 downto 0);
	variable flag_done : std_logic;
	variable during_tx : std_logic;
	variable txbit : std_logic;
	begin
		clk0_180 <= not clk0;
		
		if reset = '1' then
			during_tx := '0';
			txbit := '0'; -- transmission start with low
			txd <= txbit; 
			count := (others => '0');
			count_one := (others => '0');
			flag := x"7E";
			flag_done := '0';
			
		elsif falling_edge(clk0) then
			if tx_en = '1' and during_tx = '0' then -- tx button pressed and not in middle of data tx
				dat8 := data8; -- copy data to transmit			
				during_tx := '1';
			end if;
			
			if during_tx = '1' and flag_done = '1' then -- button pressed and not in middle of sending flag
					-- transmit data
					if count <= 7 then
						-- if 5 of 1's in a row, add '0'
						if count_one = 5 then
							txbit := not txbit; -- 0's denote by a transition
							txd <= txbit;
							count_one := (others => '0');
						else
							-- 0's denote by a transition
							if dat8(7) = '0' then
								txbit := not txbit;
							end if;
							txd <= txbit;
							count := count + 1;
							-- count for 1's
							if dat8(7) = '1' then
								count_one := count_one + 1;
							else
								count_one := (others => '0');
							end if;
							
							dat8 := dat8(6 downto 0) & '0';
						end if;
						-- done with transmitting data
						if count = 8 then
							during_tx := '0';
							flag_done := '0';
							flag := x"7E";
							count := (others => '0');
						end if;
					end if;
					
			else -- idle state, keep transmitting flag
				if count <= 7 then
					-- 0's denote by a transition
					if flag(7) = '0' then
						txbit := not txbit;
					end if;
					txd <= txbit;
					count := count + 1;
					flag := flag(6 downto 0) & '0';
					
					-- done transmitting flag
					if count = 8 then
						count := (others => '0');
						count_one := (others => '0');
						flag := x"7E";
						flag_done := '1';						
					else
						flag_done := '0';
					end if;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

