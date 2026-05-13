------------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2026 15:07:19
-- Design Name: 
-- Module Name: sim_horizontal_compteur - Behavioral
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

entity sim_horizontal_compteur is
--  Port ( );
end sim_horizontal_compteur;

architecture Behavioral of sim_horizontal_compteur is

    --  Déclaration du composant à utiliser
    component horizontal_compteur
            Port ( clock : in STD_LOGIC;
                   clk_ce : in STD_LOGIC;
                   rst : in STD_LOGIC;
                   h_compteur : out STD_LOGIC_VECTOR (9 downto 0); -- Valeur du compteur de 0 à 799
                   hsync : out STD_LOGIC;
                   h_active : out STD_LOGIC );
    end component;
    
    -- Signaux pour connecter au composant
    signal clock_test : STD_LOGIC := '0';
    signal clk_ce_test : STD_LOGIC := '0';
    signal rst_test : STD_LOGIC := '0';
    signal h_compteur_test: STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
    signal hsync_test : STD_LOGIC := '0';
    signal h_active_test : STD_LOGIC := '0';
    
    -- On configure la période de la clock (Ici 25 Mhz)
    constant clk_period : time := 40 ns;
    
begin
    -- Instanciation du composant
    uut : horizontal_compteur port map (
        clock => clock_test,
        clk_ce => clk_ce_test,
        rst => rst_test,
        h_compteur => h_compteur_test,
        hsync => hsync_test,
        h_active => h_active_test );

    -- Génération de la clock pour la simulation
    clock_test <= not clock_test after clk_period/2;
    
    process
    begin
    
    -- Test 1 : On test le reset initial
    rst_test <= '1';
    wait for 80 ns;
    
    -- Test 2 : On test et on laisse tourner sur 2 lignes
    rst_test <= '0';
    wait for 64000ns;

    wait;
    
    end process;
    
end Behavioral;
