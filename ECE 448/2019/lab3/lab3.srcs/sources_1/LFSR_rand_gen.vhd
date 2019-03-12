----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2019 11:02:35 AM
-- Design Name: 
-- Module Name: LFSR_rand_gen - Behavioral
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


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

---- Uncomment the following library declaration if using
---- arithmetic functions with Signed or Unsigned values
----use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx leaf cells in this code.
----library UNISIM;
----use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LFSR_rand_gen is
   port(
        sw: in std_logic_vector(7 downto 0);
        reset:  in std_logic;
        clk:  in std_logic;
        
        current_lfsr: out std_logic_vector(7 downto 0)
    );
end LFSR_rand_gen;

architecture Behavioral of LFSR_rand_gen is
    signal default_lfsr: std_logic_vector(7 downto 0);
    signal new_lfsr: std_logic_vector(7 downto 0);
    
begin
    process(clk, reset)
        variable nSW7 : std_logic;
    begin
        if reset = '1' then
            new_lfsr    <= sw;
        elsif rising_edge(clk) then
            nSW7        := (new_lfsr(6) XOR new_lfsr(5) XOR new_lfsr(4) XOR new_lfsr(0));
            new_lfsr    <= nSW7 & new_lfsr(7 downto 1);
            nSW7        := (new_lfsr(6) XOR new_lfsr(5) XOR new_lfsr(4) XOR new_lfsr(0));
            current_lfsr <= nSW7 & new_lfsr(7 downto 1);        
        end if;
    end process;

end Behavioral;
