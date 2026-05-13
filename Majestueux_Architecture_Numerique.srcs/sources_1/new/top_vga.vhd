----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2026 10:13:31
-- Design Name: 
-- Module Name: top_vga - Behavioral
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

entity top_vga is
    Port ( clk : in STD_LOGIC;
           btnC : in STD_LOGIC; -- Bouton de reset
           sw0 : in STD_LOGIC; -- Pour démarrer la génération
           sw : in STD_LOGIC_VECTOR(2 downto 1); --Niveau de difficulté
           seg : out STD_LOGIC_VECTOR(6 downto 0); -- Pour l'afficheur 7 segments
           an : out STD_LOGIC_VECTOr (3 downto 0); -- Activation des digits
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           led0 : out STD_LOGIC;
           btnU : in STD_LOGIC; -- Joueur Nord (Vers le Haut)
           btnD : in STD_LOGIC; -- Joueur Sud (Vers le Bas)
           btnR : in STD_LOGIC; -- Joueur Est (Vers la droite)
           btnL : in STD_LOGIC -- Joueur Ouest (Vers la gauche)
           ); -- Génération termine
end top_vga;

architecture Behavioral of top_vga is
    
    -- Composant du Vga controller
    component vga_controller is
        Port ( clk_carte : in STD_LOGIC;
               rst : in STD_LOGIC;
               hsync : out STD_LOGIC;
               vsync : out STD_LOGIC;
               h_compteur : out STD_LOGIC_VECTOR (9 downto 0);
               v_compteur : out STD_LOGIC_VECTOR (9 downto 0);
               h_active : out STD_LOGIC;
               v_active : out STD_LOGIC);
    end component;
    
    -- Composant du top_labyrinthe
    component top_labyrinthe is
        Port ( clk : in STD_LOGIC;                           
               rst : in STD_LOGIC;                           
               start : in STD_LOGIC;                         
               gen_done : out STD_LOGIC;                     
               addr_b : in  STD_LOGIC_VECTOR(7 downto 0);  
               dout_b : out STD_LOGIC_VECTOR(3 downto 0);
               addr_c : in STD_LOGIC_VECTOR(7 downto 0);
               dout_c : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    -- Composant déplacement Joueur
    component jeux_logique is
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
    end component;
    
    -- Composant pour l'affichage
    component rendu_affichage is
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
    end component;
    
   -- Composants pour le timer
    component timer is
        Port ( clk : in STD_LOGIC;                             
               rst : in STD_LOGIC;                         
               gen_done : in STD_LOGIC;
               win : in STD_LOGIC;        
               niveau : in STD_LOGIC_VECTOR (1 downto 0);
               game_over : out STD_LOGIC;     
               seg : out STD_LOGIC_VECTOR (6 downto 0);       
               an : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    -- Composants pour ecran win
    component ecran_win is
        Port ( h_compteur : in STD_LOGIC_VECTOR(9 downto 0);
               v_compteur : in STD_LOGIC_VECTOR(9 downto 0);
               h_active : in STD_LOGIC;
               v_active : in STD_LOGIC;
               win : in STD_LOGIC;
               vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
               vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
               vgaBlue : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    -- Composants pour ecran over
    component ecran_over is
        Port ( h_compteur : in STD_LOGIC_VECTOR(9 downto 0);
               v_compteur : in STD_LOGIC_VECTOR(9 downto 0);
               h_active : in STD_LOGIC;
               v_active : in STD_LOGIC;
               game_over : in STD_LOGIC;
               vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
               vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
               vgaBlue : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    -- Composants pour ecran load
    component ecran_load is
        Port ( h_compteur : in STD_LOGIC_VECTOR(9 downto 0);
               v_compteur : in STD_LOGIC_VECTOR(9 downto 0);
               h_active : in STD_LOGIC;
               v_active : in STD_LOGIC;
               gen_done : in STD_LOGIC;
               vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
               vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
               vgaBlue : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
--- Définition des signaux VGA
    signal h_compteur : STD_LOGIC_VECTOR (9 downto 0);
    signal v_compteur : STD_LOGIC_VECTOR (9 downto 0);
    signal h_active : STD_LOGIC;
    signal v_active : STD_LOGIC;
    
--- Définition des signaux du labyrinthe
    signal gen_done : STD_LOGIC;
    signal addr_b : STD_LOGIC_VECTOR (7 downto 0);
    signal dout_b : STD_LOGIC_VECTOR (3 downto 0);
    
--- Définition des signaux joueurs
    signal pos_x : STD_LOGIC_VECTOR(3 downto 0);
    signal pos_y : STD_LOGIC_VECTOR(3 downto 0);
    signal addr_joueur : STD_LOGIC_VECTOR(7 downto 0);
    signal murs_joueur : STD_LOGIC_VECTOR(3 downto 0);
    signal win : STD_LOGIC;
    
--- Signal game_over
    signal game_over : STD_LOGIC;
    
--- Signaux RGB de chaque module
    signal red_rendu : STD_LOGIC_VECTOR(3 downto 0);
    signal green_rendu : STD_LOGIC_VECTOR(3 downto 0);
    signal blue_rendu : STD_LOGIC_VECTOR(3 downto 0);
    
    signal red_win : STD_LOGIC_VECTOR(3 downto 0);
    signal green_win : STD_LOGIC_VECTOR(3 downto 0);
    signal blue_win : STD_LOGIC_VECTOR(3 downto 0);
    
    signal red_over : STD_LOGIC_VECTOR(3 downto 0);
    signal green_over : STD_LOGIC_VECTOR(3 downto 0);
    signal blue_over : STD_LOGIC_VECTOR(3 downto 0);
    
    signal red_load : STD_LOGIC_VECTOR(3 downto 0);
    signal green_load : STD_LOGIC_VECTOR(3 downto 0);
    signal blue_load : STD_LOGIC_VECTOR(3 downto 0);
begin
    
    led0 <= gen_done;
    
--- Instanciation du controlleur Vga
    vga_inst : vga_controller port map(
        clk_carte => clk,
        rst => btnC,
        hsync => Hsync,
        vsync => Vsync,
        h_compteur => h_compteur,
        v_compteur => v_compteur,
        h_active => h_active,
        v_active => v_active);

--- Instanciation du Top_labyrinthe
    laby_top : top_labyrinthe port map( 
        clk => clk,
        rst => btnC,
        start => sw0,
        gen_done => gen_done,
        addr_b => addr_b,
        dout_b => dout_b,
        addr_c => addr_joueur,
        dout_c => murs_joueur);

--- Instanciation du Jeux logique
    joueur_inst : jeux_logique port map(
        clock => clk,
        rst => btnC,
        gen_done => gen_done,
        btnU => btnU,
        btnD => btnD,
        btnR => btnR,
        btnL => btnL,
        murs => murs_joueur,
        pos_x => pos_x,
        pos_y => pos_y,
        addr_joueur => addr_joueur,
        win => win);  
 
 --- Instanciation du composant d'affichage
    render_inst : rendu_affichage port map(
        h_compteur => h_compteur,
        v_compteur => v_compteur,
        h_active => h_active,
        v_active => v_active,
        dout_b => dout_b,
        gen_done => gen_done,
        pos_x => pos_x,
        pos_y => pos_y,
        addr_b => addr_b,
        vgaRed => red_rendu,
        vgaGreen => green_rendu,
        vgaBlue => blue_rendu);
        
--- Instanciation du timer
    timer_inst : timer port map(
        clk => clk,
        rst => btnC,
        gen_done => gen_done,
        win => win,
        niveau => sw,
        game_over => game_over,
        seg => seg,
        an => an);
        
--- Instanciation ecran_win
    win_inst : ecran_win port map(
        h_compteur => h_compteur,
        v_compteur => v_compteur,
        h_active => h_active,
        v_active => v_active,
        win => win,
        vgaRed => red_win,
        vgaGreen => green_win,
        vgaBlue => blue_win);
        
 --- Instanciation ecran_over
    over_inst : ecran_over port map(
        h_compteur => h_compteur,
        v_compteur => v_compteur,
        h_active => h_active,
        v_active => v_active,
        game_over => game_over,
        vgaRed => red_over,
        vgaGreen => green_over,
        vgaBlue => blue_over);
        
--- Instanciation ecran load
    load_inst : ecran_load port map(
        h_compteur => h_compteur,
        v_compteur => v_compteur,
        h_active => h_active,
        v_active => v_active,
        gen_done => gen_done,
        vgaRed => red_load,
        vgaGreen => green_load,
        vgaBlue => blue_load);
        
--- Multiplexeur RGB pour les trois rendus
    vgaRed <= red_over when game_over = '1' else
              red_win when win = '1' else
              red_load when gen_done = '0' else
              red_rendu;
         
    vgaGreen <= green_over when game_over = '1' else
               green_win when win = '1' else
               green_load when gen_done = '0' else
               green_rendu;
               
    vgaBlue <= blue_over when game_over = '1' else
               blue_win when win = '1' else
               blue_load when gen_done = '0' else
               blue_rendu;
               
end Behavioral;
