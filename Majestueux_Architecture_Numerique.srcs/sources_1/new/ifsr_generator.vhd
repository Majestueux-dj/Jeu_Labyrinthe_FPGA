----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2026 14:31:34
-- Design Name: 
-- Module Name: ifsr_generator - Behavioral
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

entity ifsr_generator is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           avance_pas : in STD_LOGIC;
           sortie_aleatoire : out STD_LOGIC_VECTOR (15 downto 0));
end ifsr_generator;

architecture Behavioral of ifsr_generator is

--- Définition de mes signaux internes
--- Un registre de 16 bits de bascules D qu'on initialise avec un état non nulle
--- Selon l'algo d'initialisation il est interdit de mettre 11 dans les valeurs d'init
    signal compteur_aleatoire : STD_LOGIC_VECTOR (15 downto 0) := "1010101010101010";
--- Resultat
    signal feedback : STD_LOGIC;

begin

--- Le Pôlynome de Xilinx pour 16 bits
--- Taps : Bits 16, 15, 13, 4
    feedback <= compteur_aleatoire(15) XOR compteur_aleatoire(14) XOR compteur_aleatoire(12) XOR compteur_aleatoire(3);
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                compteur_aleatoire <= "1010101010101010";
            elsif avance_pas = '1' then
                compteur_aleatoire <= compteur_aleatoire(14 downto 0) & feedback;
            end if;
        end if;
    end process;
    
    sortie_aleatoire <= compteur_aleatoire;
    
end Behavioral;