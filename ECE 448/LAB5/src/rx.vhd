----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:22:24 03/30/2010 
-- Design Name: 
-- Module Name:    rx - Behavioral 
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

entity rx is
    Port ( rxd : in  STD_LOGIC;
           rx_clk : in  STD_LOGIC;
			  reset : in std_logic;
           data8 : out  STD_LOGIC_VECTOR (7 downto 0);
           wr_en : out  STD_LOGIC);
end rx;

architecture Behavioral of rx is
signal DataReady : std_logic;
begin
	process(rx_clk, reset)
	
		variable rxbit : std_logic;
		variable last_rx : std_logic;
		variable skip : std_logic;
		variable SkipFirstBit : std_logic;
		variable FlagDetected : std_logic;
		variable CountByte,Count1 : integer;
		variable DataNFlag : std_logic;
		variable rx8 : std_logic_vector	(7 downto 0);
		
	begin
		
		if reset = '1' then										   
			skip := '0';
			CountByte := 0;
			Count1 := 0;
			if rxd = '0' then
				last_rx := '0';
			else
				last_rx := '1';	
			end if;
			SkipFirstBit := '0';
			FlagDetected := '0';
			DataNFlag := '0';
			rx8 := (others => '0');
			wr_en <= '0';
			DataReady <= '0';
			
		elsif rising_edge(rx_clk) then -- clk0_180 for align with transition (from tx)
			if SkipFirstBit = '0' then
				SkipFirstBit := '1';
				if rxd = '0' then
					last_rx := '0';
				else
					last_rx := '1';
				end if;
			else
				if FlagDetected = '0' then
					if rxd /= last_rx then -- a transition -> denote a '0'
						rxbit := '0';
						last_rx := not last_rx;
					else
						rxbit := '1';
					end if;
					if Count1 = 6 then -- 6 of 1's in a row, this is a flag (x7E = "0111 1110")
						if rxbit = '0' then -- next bit is bit 7 of flag, it should be '0'
							FlagDetected := '1';
							Count1 := 0;
							CountByte := 0;
						else -- if this 7 bit is '1', there is something wrong
							-- reset Count1, start over with detecting flag
							Count1 := 0;
							-- do something here
						end if;
					else
						if rxbit = '1' then
							Count1 := Count1 + 1;
						else
							Count1 := 0;
						end if;
					end if;
					
				else -- flag (x7E) detected, start extracting data (8bits) if there is any					
					if rxd /= last_rx then -- a transition -> denote a '0'
						rxbit := '0';
						last_rx := not last_rx;
					else
						rxbit := '1';
					end if;
					
					if Count1 = 5 then -- 5 of 1's in a row
						if rxbit = '0' then -- if in data, there is 5 of 1's, tx will add 0 after. rx need to discard it
							skip := '1'; -- skip this bit
							DataNFlag := '1'; -- the recieving bits are the data bits, currently at bit 6th (start from 0..7)
						end if;
					elsif Count1 = 6 then -- 6 of 1's in a row, this is a flag (x7E = "0111 1110")
						if rxbit = '0' then -- next bit is bit 7 of flag, it should be '0'
							DataNFlag := '0';
							CountByte := -1;
						else -- if this 7 bit is '1', there is something wrong
							-- reset Count1, start over with detecting flag
							Count1 := 0;
							-- do something here
						end if;
					else
						DataNFlag := '1';
					end if;
					
					-- count for the number of 1's appears consecutively in rx stream
					if rxbit = '1' then
						Count1 := Count1 + 1;
					else -- reset counter
						Count1 := 0;
					end if;
					
					if skip = '1' then -- in data transfer, if 5 of 1's in a row, 0 will be added, rx should discard this bit
						skip := '0';
					else
						rx8 := rx8(6 downto 0) & rxbit; -- shift in from LSB
						CountByte := CountByte + 1;
						if DataNFlag = '1' and CountByte = 8 then -- recieved full 8-bits data
							CountByte := 0;
							data8 <= rx8; -- send out to fifo
							wr_en <= '1'; -- let fifo know data is ready
						else
							wr_en <= '0';
							DataNFlag := '0';
						end if;
					end if;
					
				end if;
			end if;
		end if;
	end process;

end Behavioral;

