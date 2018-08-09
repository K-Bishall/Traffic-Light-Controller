--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:14:06 08/09/2018
-- Design Name:   
-- Module Name:   D:/6thSemProject/embedded system/vhdl/controller_tb.vhd
-- Project Name:  trafficlight
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controller
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY controller_tb IS
END controller_tb;
 
ARCHITECTURE behavior OF controller_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controller
    PORT(
         clr : IN  std_logic;
         clk : IN  std_logic;
         mode : IN  std_logic;
         switch : IN  std_logic_vector(3 downto 0);
         green : OUT  std_logic_vector(3 downto 0);
         yellow : OUT  std_logic_vector(3 downto 0);
         red : OUT  std_logic_vector(3 downto 0);
         zebraRed : OUT  std_logic_vector(1 downto 0);
         zebraGreen : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clr : std_logic := '0';
   signal clk : std_logic := '0';
   signal mode : std_logic := '0';
   signal switch : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal green : std_logic_vector(3 downto 0);
   signal yellow : std_logic_vector(3 downto 0);
   signal red : std_logic_vector(3 downto 0);
   signal zebraRed : std_logic_vector(1 downto 0);
   signal zebraGreen : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controller PORT MAP (
          clr => clr,
          clk => clk,
          mode => mode,
          switch => switch,
          green => green,
          yellow => yellow,
          red => red,
          zebraRed => zebraRed,
          zebraGreen => zebraGreen
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   clear: process
	begin
		clr <= '1';
		wait for clk_period/2;
		clr <= '0';
		wait;
  end process;
  
  -- manual: process
  -- begin
  --   wait for clk_period * 5;
  --   mode <= '1';
  --   wait for clk_period;
  --   switch(3) <= '1';
  --   wait for clk_period * 5;
  --   switch(3) <= '0';
  --   wait for clk_period;
  --   mode <= '0';
  --   wait;
  -- end process;

END;
