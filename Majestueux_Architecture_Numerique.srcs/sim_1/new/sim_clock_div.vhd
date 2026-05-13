----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2026 16:18:32
-- Design Name: 
-- Module Name: sim_clock_div - Behavioral
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

entity sim_clock_div is
--  Port ( );
end sim_clock_div;

architecture Behavioral of sim_clock_div is

--  Déclaration du composant à tester
    component clock_div
        Port ( clk_in : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk_out : out STD_LOGIC );
    end component;
    
-- Signaux pour connecter au composant
    signal clk_in_test : STD_LOGIC := '0';
    signal rst_test : STD_LOGIC := '0';
    signal clk_out_test : STD_LOGIC;
    
-- On configure la période de la Clock (100 MHz correspond à 10ns)
    constant clk_period : time := 10 ns;

begin

-- Instanciation du composant
    uut : clock_div port map (
        clk_in => clk_in_test,
        rst => rst_test,
        clk_out => clk_out_test
    );
  
-- Génération de la Clock pour ma simulation
    clk_in_test <= not clk_in_test after clk_period / 2;
    
    process
    begin
    -- Test 1 : On test le reset (reset = 1)
    rst_test <= '1';
    wait for 20ns;
    
    -- Test 2 : On test maintenant le reset quand il est inactif (reset = 0)
    rst_test <= '0';
    wait for 20ns;
    
    -- Fin de la simulation
    wait;
    
    end process;
    
end Behavioral;
