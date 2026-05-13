----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2026 12:54:24
-- Design Name: 
-- Module Name: sim_ifsr_generator - Behavioral
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

entity sim_ifsr_generator is
--  Port ( );
end sim_ifsr_generator;

architecture Behavioral of sim_ifsr_generator is
    
    --- Déclaration du composant à utiliser
    component ifsr_generator
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               avance_pas : in STD_LOGIC;
               sortie_aleatoire : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    --- Signaux test à connecter au composant
    signal clk_test : STD_LOGIC := '0';
    signal rst_test : STD_LOGIC := '0';
    signal avance_pas_test : STD_LOGIC := '0';
    signal sortie_aleatoire_test : STD_LOGIC_VECTOR(15 downto 0);
    
    --- On configure la période de la clock
    constant clk_period : time := 40 ns;
    
begin
    
    --- Instanciation du composant ifsr_generator
    uut : ifsr_generator port map (
        clk => clk_test,
        rst => rst_test,
        avance_pas => avance_pas_test,
        sortie_aleatoire => sortie_aleatoire_test
        );
        
    --- Génération de la clock pour la simulation
    clk_test <= not clk_test after clk_period/2;
    
    process
    begin
    
    --- Test 1 : pour tester le reset
    rst_test <= '1'; 
    avance_pas_test <= '0';
    wait for 80 ns;
    
    --- On ramène le rst_test à 0
    rst_test <= '0';
    wait for 40 ns;
    
    --- Test 2 : On fait tourner 10 fois tout simplement
    avance_pas_test <= '1';
    wait for 400 ns;
    avance_pas_test <= '0';
    wait for 40 ns; 
    
    --- Test 3 : On avance pas du tout
    avance_pas_test <= '0';
    wait for 100 ns;
    
    --- Test 4 : On vérifie si le reset fonctionne quand avance_pas_test est à 1
    avance_pas_test <= '1';
    wait for 100 ns;
    rst_test <= '1';
    wait for 100 ns;
    rst_test <= '0';
    wait for 100 ns;
    
    -- Test 5 : On fait tourner tout simplement 
    avance_pas_test <= '1';
    wait for 400 ns;
    avance_pas_test <= '0';
    
    wait;
 
    end process;
    
end Behavioral;
