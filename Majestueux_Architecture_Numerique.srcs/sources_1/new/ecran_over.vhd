----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2026 17:00:19
-- Design Name: 
-- Module Name: ecran_over - Behavioral
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

entity ecran_over is
    Port (
           h_compteur : in STD_LOGIC_VECTOR(9 downto 0);
           v_compteur : in STD_LOGIC_VECTOR(9 downto 0);
           h_active : in STD_LOGIC;
           v_active : in STD_LOGIC;
           game_over : in STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0));
end ecran_over;

architecture Behavioral of ecran_over is
    signal active : STD_LOGIC;
begin

    active <= h_active and v_active;
    
    process(active, game_over, h_compteur, v_compteur)
        variable x : integer;
        variable y : integer;
        variable pixel_on : boolean;
        variable x_offset : integer;
        variable y_offset : integer;
    begin
        -- fond noir
        vgaRed   <= "0000";
        vgaGreen <= "0000";
        vgaBlue  <= "0000";
        
        if active = '1' and game_over = '1' then
        
            x := to_integer(unsigned(h_compteur));
            y := to_integer(unsigned(v_compteur));
            
            -- position globale du texte
            x_offset := 60;
            y_offset := 180;
            
            pixel_on := false;
            
            if y > y_offset and y < y_offset + 120 then

                -- On affiche la lettre G
                if (x > x_offset and x < x_offset + 40 and
                   ((y > y_offset and y < y_offset + 10) or
                    (y > y_offset + 110 and y < y_offset + 120))) or
                   (x > x_offset and x < x_offset + 10 and y > y_offset and y < y_offset + 120) or
                   (x > x_offset + 30 and x < x_offset + 40 and y > y_offset + 60 and y < y_offset + 120) or
                   (x > x_offset + 20 and x < x_offset + 40 and y > y_offset + 55 and y < y_offset + 65) then
                    pixel_on := true;
                end if;

                -- On affiche la lettre A
                if (x > x_offset + 60 and x < x_offset + 70 and y > y_offset and y < y_offset + 120) or
                   (x > x_offset + 100 and x < x_offset + 110 and y > y_offset and y < y_offset + 120) or
                   (x > x_offset + 60 and x < x_offset + 110 and y > y_offset and y < y_offset + 10) or
                   (x > x_offset + 60 and x < x_offset + 110 and y > y_offset + 50 and y < y_offset + 60) then
                    pixel_on := true;
                end if;

                -- On affiche la lettre M
                if (x > x_offset + 130 and x < x_offset + 140 and y > y_offset and y < y_offset + 120) or
                   (x > x_offset + 170 and x < x_offset + 180 and y > y_offset and y < y_offset + 120) or
                   (x > x_offset + 145 and x < x_offset + 155 and y > y_offset and y < y_offset + 60) or
                   (x > x_offset + 155 and x < x_offset + 165 and y > y_offset and y < y_offset + 60) then
                    pixel_on := true;
                end if;

                -- On affiche la lettre E
                if (x > x_offset + 200 and x < x_offset + 210 and y > y_offset and y < y_offset + 120) or
                   (x > x_offset + 200 and x < x_offset + 240 and y > y_offset and y < y_offset + 10) or
                   (x > x_offset + 200 and x < x_offset + 230 and y > y_offset + 55 and y < y_offset + 65) or
                   (x > x_offset + 200 and x < x_offset + 240 and y > y_offset + 110 and y < y_offset + 120) then
                    pixel_on := true;
                end if;

                -- espace

                -- On affiche la lettre O
                if (x > x_offset + 260 and x < x_offset + 300 and
                   ((y > y_offset and y < y_offset + 10) or
                    (y > y_offset + 110 and y < y_offset + 120))) or
                   ((y > y_offset and y < y_offset + 120) and
                   ((x > x_offset + 260 and x < x_offset + 270) or
                    (x > x_offset + 290 and x < x_offset + 300))) then
                    pixel_on := true;
                end if;

                -- On affiche la lettre V
                if (x > x_offset + 320 and x < x_offset + 330 and y > y_offset and y < y_offset + 100) or
                   (x > x_offset + 360 and x < x_offset + 370 and y > y_offset and y < y_offset + 100) or
                   (x > x_offset + 338 and x < x_offset + 352 and y > y_offset + 100 and y < y_offset + 120) then
                    pixel_on := true;
                end if;

                -- On affiche la lettre E
                if (x > x_offset + 390 and x < x_offset + 400 and y > y_offset and y < y_offset + 120) or
                   (x > x_offset + 390 and x < x_offset + 430 and y > y_offset and y < y_offset + 10) or
                   (x > x_offset + 390 and x < x_offset + 420 and y > y_offset + 55 and y < y_offset + 65) or
                   (x > x_offset + 390 and x < x_offset + 430 and y > y_offset + 110 and y < y_offset + 120) then
                    pixel_on := true;
                end if;

                -- On affiche la lettre R
                if (x > x_offset + 450 and x < x_offset + 460 and y > y_offset and y < y_offset + 120) or
                   (x > x_offset + 450 and x < x_offset + 490 and y > y_offset and y < y_offset + 10) or
                   (x > x_offset + 450 and x < x_offset + 490 and y > y_offset + 50 and y < y_offset + 60) or
                   (x > x_offset + 480 and x < x_offset + 490 and y > y_offset and y < y_offset + 50) or
                   (x > x_offset + 460 and x < x_offset + 470 and y > y_offset + 60 and y < y_offset + 80) or
                   (x > x_offset + 470 and x < x_offset + 480 and y > y_offset + 80 and y < y_offset + 100) or
                   (x > x_offset + 480 and x < x_offset + 490 and y > y_offset + 100 and y < y_offset + 120) then
                    pixel_on := true;
                end if;

            end if;
            
            -- affichage en rouge
            if pixel_on then
                vgaRed   <= "1111";
                vgaGreen <= "0000";
                vgaBlue  <= "0000";
            end if;
            
        end if;
      
    end process;    

end Behavioral;