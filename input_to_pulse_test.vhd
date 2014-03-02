--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:49:15 02/24/2014
-- Design Name:   
-- Module Name:   C:/Users/C15Tramaine.Barnett/WorkSpace/fontlab/input_to_pulse_test.vhd
-- Project Name:  fontlab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: input_to_pulse
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
USE ieee.numeric_std.ALL;
 
ENTITY input_to_pulse_test IS
END input_to_pulse_test;
 
ARCHITECTURE behavior OF input_to_pulse_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT input_to_pulse
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         input : IN  std_logic;
         pulse : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal input : std_logic := '0';
   signal pulse : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: input_to_pulse PORT MAP (
          clk => clk,
          reset => reset,
          input => input,
          pulse => pulse
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

    -- Stimulus process
   stim_proc: process
   begin		
		reset <= '1';
		input <= '0';
      wait for 100 ns;	
		reset <= '0';
      wait for clk_period*10;
		wait for clk_period*(3/4);
      input <= '1';
		wait for clk_period*190000;
		input <= '0';
		wait for clk_period*1000;
		input <= '1';
		wait for clk_period*1000;
		input <= '0';
		wait for clk_period*1000;
		input <= '1';
		wait for clk_period*1000;
		input <= '0';
		wait for clk_period*7000;
		input <='1';
		wait for clk_period*7000;
		input <='0';
      wait;
   end process;

END;
