----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2026 10:51:33
-- Design Name: 
-- Module Name: rendu_affichage - Behavioral
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

entity rendu_affichage is
    Port ( 
           h_compteur : in STD_LOGIC_VECTOR (9 downto 0);
           v_compteur : in STD_LOGIC_VECTOR (9 downto 0);
           h_active : in STD_LOGIC;
           v_active : in STD_LOGIC;
           dout_b : in STD_LOGIC_VECTOR (3 downto 0);
           gen_done : in STD_LOGIC;
           pos_x : in STD_LOGIC_VECTOR (3 downto 0);
           pos_y : in STD_LOGIC_VECTOR (3 downto 0);
           addr_b : out STD_LOGIC_VECTOR (7 downto 0);
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0));
end rendu_affichage;

architecture Behavioral of rendu_affichage is

    -- Signaux position dans la grille
    signal cellule_x : integer range 0 to 15;
    signal cellule_y : integer range 0 to 15;
    
    -- Signaux pour les positions de la cellule
    signal pixel_x_case : integer range 0 to 39;
    signal pixel_y_case : integer range 0 to 29;
    
    -- Signaux pour la zone active
    signal active : STD_LOGIC; 

begin
    
    -- Zone active
    active <= h_active and v_active;
    
    -- On calcule la position dans la cellule
    pixel_x_case <= to_integer(unsigned(h_compteur)) mod 40;
    pixel_y_case <= to_integer(unsigned(v_compteur)) mod 30;
    
    -- On calcule la position de la cellule courante
    cellule_x <= 15 when to_integer(unsigned(h_compteur)) >= 640 else
                 to_integer(unsigned(h_compteur)) / 40;
    
    cellule_y <= 15 when to_integer(unsigned(v_compteur)) >= 480 else
                 to_integer(unsigned(v_compteur)) / 30;
                 
    -- Adresse BRAM depuis les position pixels
    addr_b <= STD_logic_vector(to_unsigned(cellule_y * 16 + cellule_x, 8));
    
    -- Process RGB
    process(active, dout_b, gen_done, cellule_x, cellule_y, pixel_x_case, pixel_y_case, pos_x, pos_y)
    begin
        -- Valeurs par défaut
        vgaRed <= "0000";
        vgaGreen <= "0000";
        vgaBlue <= "0000";
        
        if active = '1' then
        
                -- Entrée du labyrinthe (0,0) : On met de vert sur la cellule
                if cellule_x = 0 and cellule_y = 0 then
                    vgaRed <= "0000";
                    vgaGreen <= "1111";
                    vgaBlue <= "0000";
                    
                -- Sortie du labyrinthe (15,15) : On met du Rouge
                elsif cellule_x = 15 and cellule_y = 15 then
                    vgaRed <= "1111";
                    vgaGreen <= "0000";
                    vgaBlue <= "0000";
                    
                -- Murs pierre avec 3px d'épaisseur
                elsif (pixel_y_case <= 2 and dout_b(3) = '1') or -- Mur Nord
                      (pixel_y_case >= 27 and dout_b(2) = '1') or -- Mur Sud
                      (pixel_x_case >= 37 and dout_b(1) = '1') or -- Mur Est
                      (pixel_x_case <= 2 and dout_b(0) = '1') then -- Mur Ouest
                          -- Gris beige pour le mûrs, pierre
                          vgaRed <= "0111";
                          vgaGreen <= "0110";
                          vgaBlue <= "0110";
                else
                    -- Sol couleur noir
                    vgaRed <= "0001";
                    vgaGreen<= "0001";
                    vgaBlue <= "0001";
                    
                end if;
                
                -- Le joueur est représenté en une boule Jaune
                if cellule_x = to_integer(unsigned(pos_x)) and cellule_y = to_integer(unsigned(pos_y)) then
                    if((pixel_x_case - 20) * (pixel_x_case - 20) + (pixel_y_case -15) * (pixel_y_case - 15)) < 64 then
                        -- Cercle Jaune
                        vgaRed <= "1111";
                        vgaGreen <= "1100";
                        vgaBlue <= "0000";
                        -- Pour le reflet Blanc
                        if((pixel_x_case -15) * (pixel_x_case - 15) + (pixel_y_case - 10) * (pixel_y_case - 10)) < 8 then
                            vgaRed <= "1111";
                            vgaGreen <= "1111";
                            vgaBlue <= "1111";
                        end if;  
                    end if;              
                end if;
            end if;       
    end process;                        
end Behavioral;
