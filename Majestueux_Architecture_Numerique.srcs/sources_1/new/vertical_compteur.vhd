----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2026 17:24:24
-- Design Name: 
-- Module Name: vertical_compteur - Behavioral
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

entity vertical_compteur is
    Port ( clock : in STD_LOGIC; -- 100 MHz
           clk_ce : in STD_LOGIC; -- Clock à 25MHz
           rst : in STD_LOGIC;
           hsync : in STD_LOGIC;
           v_compteur : out STD_LOGIC_VECTOR (9 downto 0);
           vsync : out STD_LOGIC;
           v_active : out STD_LOGIC);
end vertical_compteur;

architecture Behavioral of vertical_compteur is

--- Paramètres des timings Horizontaux
    constant ZONE_AFFICHE : integer := 480; -- Pixels de la zone affichée
    constant ZONE_FRONT : integer := 10; -- Front Porch
    constant ZONE_SYNC : integer := 2; -- Durée du Sync Pulse
    constant ZONE_BACK : integer := 33; -- Pour revenir à la ligne
    constant ZONE_CHECK : integer := 525; -- Total = 480 + 10 + 2 + 33
    
-- Compteur interne
    signal compteur : integer range 0 to ZONE_CHECK - 1 := 0;
    
-- Signal pour mémoriser l'ancienne valeur de hsync
    signal hsync_old : STD_LOGIC := '1';
    
begin

-- Le processus de comptage
    process(clock)
    begin
        if rising_edge (clock) then
            if rst = '1' then
                compteur <= 0;
                hsync_old <= '1';
            elsif clk_ce = '1' then
                hsync_old <= hsync;
                if hsync_old = '0' and hsync = '1' then
                    if compteur = ZONE_CHECK - 1 then
                        compteur <= 0; -- On repart de 0
                    else
                        compteur <= compteur + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

--- Gestion de signal Hsync
--- On vérifie ici juste si le moniteur doit continuer d'afficher ou pas
    vsync <= '0' when ( compteur >= ZONE_AFFICHE + ZONE_FRONT and
                        compteur < ZONE_AFFICHE + ZONE_FRONT + ZONE_SYNC )
        else '1';
    
-- Zone est active pour écrire quand j'ai compteur < 480
    v_active <= '1' when compteur < ZONE_AFFICHE
           else '0';
           
-- La sortie de mon compteur hcount prends compteur simplement
    v_compteur <= STD_LOGIC_VECTOR(TO_UNSIGNED(compteur, 10));
    
end Behavioral;
