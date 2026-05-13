----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2026 12:12:57
-- Design Name: 
-- Module Name: horizontal_compteur - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity horizontal_compteur is
    Port ( clock : in STD_LOGIC; -- 100 MHz
           clk_ce : in STD_LOGIC; -- Clock à 25MHz
           rst : in STD_LOGIC;
           h_compteur : out STD_LOGIC_VECTOR (9 downto 0); -- Valeur du compteur de 0 à 799
           hsync : out STD_LOGIC;
           h_active : out STD_LOGIC); -- Si h_active = 1 alors nous sommes dans la zone affichée (de 0 à 639)
end horizontal_compteur;

architecture Behavioral of horizontal_compteur is

--- Paramètres des timings Horizontaux
    constant ZONE_AFFICHE : integer := 640; -- Pixels de la zone affichée
    constant ZONE_FRONT : integer := 16; -- Front Porch
    constant ZONE_SYNC : integer := 96; -- Durée du Sync Pulse
    constant ZONE_BACK : integer := 48; -- Pour revenir à la ligne
    constant ZONE_CHECK : integer := 800; -- Total = 640 + 16 + 96 + 48
   
-- Compteur interne
    signal compteur : integer range 0 to ZONE_CHECK - 1 := 0;
    
begin

-- Le processus de comptage
    process(clock)
    begin
        if rising_edge (clock) then
            if rst = '1' then
                compteur <= 0;
            elsif clk_ce = '1' then
                if compteur = ZONE_CHECK - 1 then
                    compteur <= 0; -- On repart de 0
                else
                    compteur <= compteur + 1;
                end if;
            end if;
        end if;
    end process;
     
--- Gestion de signal Hsync
--- On vérifie ici juste si le moniteur doit continuer d'afficher ou pas
    hsync <= '0' when ( compteur >= ZONE_AFFICHE + ZONE_FRONT and
                        compteur < ZONE_AFFICHE + ZONE_FRONT + ZONE_SYNC )
        else '1';
    
-- Zone est active pour écrire quand j'ai compteur < 640
    h_active <= '1' when compteur < ZONE_AFFICHE else '0';
           
-- La sortie de mon compteur hcount prends compteur simplement
    h_compteur <= STD_LOGIC_VECTOR(TO_UNSIGNED(compteur, 10));
    
end Behavioral;