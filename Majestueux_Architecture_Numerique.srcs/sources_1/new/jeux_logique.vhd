----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2026 15:57:27
-- Design Name: 
-- Module Name: jeux_logique - Behavioral
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

entity jeux_logique is
    Port ( clock : in STD_LOGIC;
           rst : in STD_LOGIC;
           gen_done : in STD_LOGIC;
           btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnL : in STD_LOGIC;
           murs : in STD_LOGIC_VECTOR (3 downto 0);
           pos_x : out STD_LOGIC_VECTOR (3 downto 0);
           pos_y : out STD_LOGIC_VECTOR (3 downto 0);
           addr_joueur : out STD_LOGIC_VECTOR (7 downto 0);
           win : out STD_LOGIC);
end jeux_logique;

architecture Behavioral of jeux_logique is

    -- Position interne du joueur
    signal pos_x_int : unsigned(3 downto 0) := (others => '0');
    signal pos_y_int : unsigned(3 downto 0) := (others => '0');
    
    -- On utilise un compteur pour pouvoir mémoriser les appuies multiples
    -- Je contrôle ainsi la vitesse de déplacement du joueur
    signal btn_mem : unsigned(24 downto 0):= (others => '0');
    signal btn_start : STD_LOGIC := '1';

begin
    
    -- Calcul de l'adresse du mémoire (adresse du joueur)
    addr_joueur <= STD_LOGIC_VECTOR(pos_y_int & pos_x_int);
    
    -- Sortie de la position
    pos_x <= STD_LOGIC_VECTOR(pos_x_int);
    pos_y <= STD_LOGIC_VECTOR(pos_y_int);
    
    -- Process
    process(clock)
    begin
        if rising_edge(clock) then
            if rst = '1' then
                pos_x_int <= (others => '0');
                pos_y_int <= (others => '0');
                btn_mem <= (others => '0');
                btn_start <= '1';
                win <= '0';
         
            elsif gen_done = '1' then
            
                -- Gestion anti-rebond
                if btn_start = '0' then
                    if btn_mem = 0 then
                        btn_start <= '1';
                    else
                        btn_mem <= btn_mem - 1;
                    end if; 
                elsif btn_start = '1' then
                    
                -- Déplacement vers le haut (Nord)
                    if btnU = '1' and murs(3)='0' and pos_y_int > 0 then
                        pos_y_int <= pos_y_int - 1;
                        btn_start <= '0';
                        btn_mem <= (others => '1');
                        
                -- Déplacement vers le bas (Sud)
                    elsif btnD = '1' and murs(2)='0' and pos_y_int < 15 then
                          pos_y_int <= pos_y_int + 1;
                          btn_start <= '0';
                          btn_mem <= (others => '1');
                          -- On teste maintenant si on était à la position (15, 14) et qu'on devrait arriver à la position (15,15)
                          if pos_x_int = 15 and pos_y_int = 14 then
                            win <= '1';
                          end if;
                    
                -- Déplacement vers l'EST (à droite)
                    elsif btnR = '1' and murs(1)='0' and pos_x_int < 15 then
                            pos_x_int <= pos_x_int + 1;
                            btn_start <= '0';
                            btn_mem <= (others => '1');
                            -- On test maintenant si on était à la position (14, 15) et qu'on devrait arriver à la position (15, 15)
                            if pos_x_int = 14 and pos_y_int = 15 then
                                win <= '1';
                            end if;
                                                     
                -- Déplacement vers l'Ouest (à gauche)
                    elsif btnL = '1' and murs(0)='0' and pos_x_int > 0 then
                            pos_x_int <= pos_x_int - 1;
                            btn_start <= '0';
                            btn_mem <= (others => '1');
                    end if;
                    
                 end if;                    
                end if;
             end if;
          end process;       
end Behavioral;