--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   04:21:51 04/03/2010
-- Design Name:   
-- Module Name:   D:/GMU/2010Spring/ECE448/Lab5/Spartan3E_testbench.vhd
-- Project Name:  Lab5
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Spartan3E
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY Spartan3E_testbench IS
END Spartan3E_testbench;
 
ARCHITECTURE behavior OF Spartan3E_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Spartan3E
    PORT(
         mclk : IN  std_logic;
         led : OUT  std_logic_vector(7 downto 0);
         JA : IN  std_logic_vector(3 downto 0);
         JD : OUT  std_logic_vector(3 downto 0);
         seg : OUT  std_logic_vector(7 downto 0);
         an : OUT  std_logic_vector(3 downto 0);
         sw : IN  std_logic_vector(7 downto 0);
         btn : IN  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal mclk : std_logic := '0';
   signal JA : std_logic_vector(3 downto 0) := (others => '0');
   signal sw : std_logic_vector(7 downto 0) := (others => '0');
   signal btn : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal led : std_logic_vector(7 downto 0);
   signal JD : std_logic_vector(3 downto 0);
   signal seg : std_logic_vector(7 downto 0);
   signal an : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant mclk_period : time := 40ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Spartan3E PORT MAP (
          mclk => mclk,
          led => led,
          JA => JA,
          JD => JD,
          seg => seg,
          an => an,
          sw => sw,
          btn => btn
        );

   -- Clock process definitions
   mclk_process :process
   begin
		mclk <= '0';
		wait for mclk_period/2;
		mclk <= '1';
		wait for mclk_period/2;
   end process;
 
	JA <= JD;
   -- Stimulus process
   stim_proc: process
   begin
	   btn <= x"0";
		wait for mclk_period*15;
      sw <= x"77";
	  btn <= x"F";
	  wait for mclk_period*2;
	  btn <= x"0";
	  wait for mclk_period*2;
	  btn <= x"F";
	  wait for mclk_period*30;
	  
	  btn <= x"0";
      wait;
   end process;

END;
