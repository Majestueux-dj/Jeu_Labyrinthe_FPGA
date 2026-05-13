----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2026
-- Module Name: ecran_win - Behavioral
-- Description: 
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

entity ecran_win is
    Port ( 
           h_compteur : in STD_LOGIC_VECTOR(9 downto 0);
           v_compteur : in STD_LOGIC_VECTOR(9 downto 0);
           h_active : in STD_LOGIC;
           v_active : in STD_LOGIC;
           win : in STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0)
    );
end ecran_win;

architecture Behavioral of ecran_win is
    
    signal active : STD_LOGIC;
    
begin

    active <= h_active and v_active;
    
    process(active, win, h_compteur, v_compteur)
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
        
        if active = '1' and win = '1' then
        
            x := to_integer(unsigned(h_compteur));
            y := to_integer(unsigned(v_compteur));
            
            -- position globale du texte
            x_offset := 120;
            y_offset := 180;
            
            pixel_on := false;
            
            if y > y_offset and y < y_offset + 120 then
            
                -- On affiche Y
                if ((x > x_offset and x < x_offset + 10 and y < y_offset + 60)) or
                   ((x > x_offset + 40 and x < x_offset + 50 and y < y_offset + 60)) or
                   (x > x_offset + 20 and x < x_offset + 30 and y > y_offset + 60) then
                    pixel_on := true;
                end if;
                
                -- On affiche O
                if (x > x_offset + 70 and x < x_offset + 110 and
                   ((y > y_offset and y < y_offset + 10) or (y > y_offset + 110 and y < y_offset + 120))) or
                   ((y > y_offset and y < y_offset + 120) and 
                   ((x > x_offset + 70 and x < x_offset + 80) or (x > x_offset + 100 and x < x_offset + 110))) then
                    pixel_on := true;
                end if;
                
                -- On affiche U
                if (x > x_offset + 130 and x < x_offset + 140) or
                   (x > x_offset + 170 and x < x_offset + 180) or
                   (y > y_offset + 100 and y < y_offset + 120 and x > x_offset + 130 and x < x_offset + 180) then
                    pixel_on := true;
                end if;
                
                -- espace

                -- On affiche W
                if (x > x_offset + 210 and x < x_offset + 220) or
                   (x > x_offset + 230 and x < x_offset + 240 and y > y_offset + 70) or
                   (x > x_offset + 250 and x < x_offset + 260 and y > y_offset + 70) or
                   (x > x_offset + 270 and x < x_offset + 280) then
                    pixel_on := true;
                end if;
                
                -- On affiche I
                if (x > x_offset + 300 and x < x_offset + 310) then
                    pixel_on := true;
                end if;
                
                -- On affiche N
                if (x > x_offset + 330 and x < x_offset + 340) or
                   (x > x_offset + 370 and x < x_offset + 380) or
                   ((x - (x_offset + 330) >= y - y_offset - 2) and
                    (x - (x_offset + 330) <= y - y_offset + 2) and
                    x > x_offset + 330 and x < x_offset + 380 and
                    y > y_offset and y < y_offset + 120) then
                    pixel_on := true;
                end if;

            end if;
            
            -- affichage en vert
            if pixel_on then
                vgaRed   <= "0000";
                vgaGreen <= "1111";
                vgaBlue  <= "0000";
            end if;
            
        end if;
        
    end process;
        
end Behavioral;