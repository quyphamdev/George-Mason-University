----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2019 09:11:12 PM
-- Design Name: 
-- Module Name: LFSR_rand_gen_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LFSR_rand_gen_tb is
--  Port ( );
end LFSR_rand_gen_tb;

architecture Behavioral of LFSR_rand_gen_tb is
    signal clk      : std_logic;
    signal reset    : std_logic;
    signal sw       : std_logic_vector(7 downto 0);
    signal rand     : std_logic_vector(7 downto 0);
begin

    clock: process
    begin
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
    end process;
    
    rst: process
    begin
        reset <= '1';
        sw <= "10111011";
        wait for 15 ns;
        reset <= '0';
        wait;
    end process;

	LFSR_rand_gen_inst: entity work.LFSR_rand_gen
    port map(
        clk => clk,
        reset => reset,
        sw  => sw(7 downto 0),  -- switches 0..7 
        -- output
        current_lfsr => rand); -- random number    


end Behavioral;
