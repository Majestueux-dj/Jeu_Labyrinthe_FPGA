----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2026 17:20:10
-- Design Name: 
-- Module Name: timer - Behavioral
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

entity timer is
    Port ( clk : in STD_LOGIC; -- Horloge                                 
           rst : in STD_LOGIC; -- Reset synchrone              
           gen_done : in STD_LOGIC; -- On s'appuie sur cette variable pour démérrer le timer
           win : in STD_LOGIC; -- Stop le timer en cas de victoire       
           niveau : in STD_LOGIC_VECTOR (1 downto 0); -- Niveau de difficultés
           game_over : out STD_LOGIC; -- 1 quand timer atteint 0          
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7 segments;        
           an : out STD_LOGIC_VECTOR (3 downto 0)); -- Activation 4 digits
end timer;

architecture Behavioral of timer is
    
    -- 100 Mhz : 
    constant clk_seconde : integer := 100000000;
    
    -- Les durées en secondes en fonction du niveau
    constant FACILE : integer := 120; -- Pour 2 minutes
    constant MOYEN : integer := 60; -- Pour 1 minute
    constant DIFFICILE : integer := 30; -- Pour 30 secondes
    
    -- Compteur pour diviser l'horloge en secondes
    signal clk_cnt : integer range 0 to clk_seconde - 1 := 0;
    
    -- Secondes restantes (max = 120 pour facile)
    signal secondes : integer range 0 to 120 := 0;
    
    -- Timer en cours ou terminé
    signal running :  STD_LOGIC := '0';
    signal done : STD_LOGIC := '0';
    
    -- Format de comptage : MM : SS
    signal min_unite : integer range 0 to 9 := 0;
    signal sec_dizaine : integer range 0 to 5 :=0;
    signal sec_unite : integer range 0 to 9 := 0;
    
    -- Multiplexage 1 khz : On divise 100Mhz par 100 000
    constant rafraichir : integer := 100000;
    signal ref_cnt : integer range 0 to rafraichir - 1 := 0;
    signal digit_sel : integer range 0 to 3 := 0;
    signal digit_val : integer range 0 to 9 := 0;
    
    -- Table ROM 7 segments actfis bas (a, b, c, d, e, f, g)
    type seg_mem is array(0 to 9) of STD_LOGIC_VECTOR(6 downto 0);
    constant segment_7 : seg_mem := (
        "1000000", -- 0
        "1111001", -- 1
        "0100100", -- 2
        "0110000", -- 3
        "0011001", -- 4
        "0010010", -- 5
        "0000010", -- 6
        "1111000", -- 7
        "0000000", -- 8
        "0010000" ); -- 9    
     
begin
    -- Décompteur seconde par seconde
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- RESET
                clk_cnt <= 0;
                done <= '0';
                running <= '0';
                case niveau is
                    when "00" => secondes <= FACILE;
                    when "01" => secondes <= MOYEN;
                    when others => secondes <= DIFFICILE;
                end case;
                
                --Labyrinthe prêt, pas encore gagné ni écoulé
                elsif gen_done = '1' and win = '0' and done = '0' then
                    running <= '1';
                    
                    if running = '1' then
                        if clk_cnt = clk_seconde - 1 then
                            -- 1e seconde a été écoulé
                            clk_cnt <= 0;
                            if secondes = 0 then
                                -- Timer est à 0 et donc game over
                                done <= '1';
                            else
                                secondes <= secondes - 1;
                            end if;
                        else
                            clk_cnt <= clk_cnt + 1;
                        end if;
                    end if;
                 end if;
              end if;
          end process;
          
          -- Sortie game_over
          game_over <= done;
          
          -- Décodage seconde (MM: SS)
          min_unite <=  (secondes / 60) mod 10; -- Unités de minutes
          sec_dizaine <= (secondes mod 60) / 10; -- Dizaine de secondes
          sec_unite <= secondes mod 10; --Unité de secondes
          
          -- Multiplexage des 4 digits
          process(clk)
          begin
            if rising_edge(clk) then
                if rst = '1' then
                    ref_cnt <= 0;
                    digit_sel <= 0;
                else 
                    if ref_cnt = rafraichir - 1 then
                        ref_cnt <= 0;
                        if digit_sel = 3 then
                            digit_sel <= 0;
                        else
                            digit_sel <= digit_sel + 1;
                        end if;
                    else
                        ref_cnt <= ref_cnt + 1;
                    end if;     
                 end if;
           end if;
         end process;  
          
     -- Valeur du digit courant
    -- digit 3 = dizaines minutes (gauche)
    -- digit 2 = unités minutes
    -- digit 1 = dizaines secondes
    -- digit 0 = unités secondes (droite)
    digit_val <= 0 when digit_sel = 3 else
                 min_unite   when digit_sel = 2 else
                 sec_dizaine when digit_sel = 1 else
                 sec_unite;
                 
    -- Anode actif bas : un seul digit allumé à la fois
    an <= "1110" when digit_sel = 0 else
          "1101" when digit_sel = 1 else
          "1011" when digit_sel = 2 else
          "0111";

    seg <= segment_7(digit_val);    
          
end Behavioral;
