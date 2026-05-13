----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2026 12:08:24
-- Design Name: 
-- Module Name: ecran_load - Behavioral
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

entity ecran_load is
    Port ( h_compteur : in STD_LOGIC_VECTOR(9 downto 0); -- Position Pixel horizontal
           v_compteur : in STD_LOGIC_VECTOR(9 downto 0); -- Position Pixel Vertical
           h_active : in STD_LOGIC;
           v_active : in STD_LOGIC;
           gen_done : in STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0));
end ecran_load;

architecture Behavioral of ecran_load is
    signal active : STD_LOGIC;
    
begin
    
    -- Zone active
    active <= h_active and v_active;
    
    process(active, gen_done, h_compteur, v_compteur)
        variable x: integer; --Coordonnées X du pixel courant
        variable y: integer; -- Coordonnées Y du pixel courant
        variable pixel_on : boolean; -- si vrai on allule le pixel
        variable x_offset : integer;
        variable y_offset : integer;
        
    begin
        -- Par défaut : On mets un fond noir
        vgaRed <= "0000";
        vgaGreen <= "0000";
        vgaBlue <= "0000";
        
        -- On l'affiche uniquement lorsque zone active et generation pas encore terminé
        if active = '1' and gen_done = '0' then
            -- Conversion des compteurs en entier
            x:= to_integer(unsigned(h_compteur));
            y:= to_integer(unsigned(v_compteur));
            x_offset := 0;  -- décale le texte vers la droite
            y_offset := 0; -- décale le texte vers le haut
            
            pixel_on := false; -- Par défaut le pixel est éteints.
            
            if y > 200 and y < 300 then
            
                -- On affiche la lettre L
                if (x > 120 + x_offset and x < 130 + x_offset) or
                   (x > 120 + x_offset and x < 170 + x_offset and y > 280 + y_offset) then
                        pixel_on := true;
                end if;
                
                -- On affiche la lettre O
                if (x > 180 + x_offset and x < 220 + x_offset and (y < 210 + y_offset or y > 290 + y_offset)) or
                   (y > 200 + y_offset and y < 300 + y_offset and ((x > 180 + x_offset and x < 190 + x_offset) or (x > 210 + x_offset and x < 220 + x_offset))) then
                    pixel_on := true;
                end if;
                
                -- On affiche la lettre A
                if (x > 240 + x_offset and x < 250 + x_offset and y > 200 + y_offset) or
                   (x > 280 + x_offset and x < 290 + x_offset and y > 200 + y_offset) or
                   (y > 200 + y_offset and y < 210 + y_offset and x > 240 + x_offset and x < 290 + x_offset) or
                   (y > 240 + y_offset and y < 250 + y_offset and x > 240 + x_offset and x < 290 + x_offset) then
                    pixel_on := true;
                end if;
                
                -- On affiche la lettre D
                if (x > 310 + x_offset and x < 320 + x_offset) or
                   (y > 200 + y_offset and y < 210 + y_offset and x > 310 + x_offset and x < 350 + x_offset) or
                   (y > 290 + y_offset and y < 300 + y_offset and x > 310 + x_offset and x < 350 + x_offset) or
                   (x > 340 + x_offset and x < 350 + x_offset and y > 210 + y_offset and y < 290 + y_offset) then
                    pixel_on := true;
                end if;
                
                -- On affiche la lettre I
                if (x > 370 + x_offset and x < 380 + x_offset) then
                    pixel_on := true;
                end if;
                
                -- On affiche la lettre N
                if (x > 400 + x_offset and x < 410 + x_offset) or
                   (x > 440 + x_offset and x < 450 + x_offset) or
                   ((x - 400 + x_offset >= y - 202 + y_offset) and (x - 400 + x_offset <= y - 198 + y_offset) and x > 400 + x_offset and x < 450 + x_offset and y > 200 + y_offset and y < 300 + y_offset) then
                    pixel_on := true;
                end if;
                
                -- On affiche la lettre G
                if (x > 470 + x_offset and x < 510 + x_offset and (y > 200 + y_offset and y < 210 + y_offset)) or
                   (x > 470 + x_offset and x < 510 + x_offset and (y > 290 + y_offset and y < 300 + y_offset)) or
                   (x > 470 + x_offset and x < 480 + x_offset and y > 200 + y_offset and y < 300 + y_offset) or
                   (x > 500 + x_offset and x < 510 + x_offset and y > 250 + y_offset and y < 300 + y_offset) or
                   (x > 490 + x_offset and x < 510 + x_offset and y > 245 + y_offset and y < 255 + y_offset) then
                     pixel_on := true;
                end if;
                
                -- On affiche les 3 points
                if (x > 530 + x_offset and x < 540 + x_offset and y > 290 + y_offset) or
                   (x > 550 + x_offset and x < 560 + x_offset and y > 290 + y_offset) or
                   (x > 570 + x_offset and x < 580 + x_offset and y > 290 + y_offset) then
                    pixel_on := true;
                end if;
             end if;
             
            if pixel_on then
                vgaRed   <= "1111";
                vgaGreen <= "1111";
                vgaBlue  <= "1111";
            end if;
          end if;
    end process;
end Behavioral;
