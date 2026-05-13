----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.03.2026 14:21:55
-- Design Name: 
-- Module Name: labyrinthe_generator - Behavioral
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

entity labyrinthe_generator is
    Port ( clk : in STD_LOGIC; -- clock
           rst : in STD_LOGIC; -- Pour le Reset
           start : in STD_LOGIC; -- Lance la génération du labyrinthe
           lfsr_val : in STD_LOGIC_VECTOR (15 downto 0); -- Nombre aléatoire veant de l'ifsr_generator
           lfsr_next : out STD_LOGIC; -- Demande d'un nouveau nombre
           we_a : out STD_LOGIC; -- Interface autorisation d'écriture venant de labyrinthe Bram
           addr_wr : out STD_LOGIC_VECTOR (7 downto 0); -- Interface labyrinthe Bram (Ecriture)
           din_a : out STD_LOGIC_VECTOR (3 downto 0); -- Interface labyrinthe Bram
           addr_rd : out STD_LOGIC_VECTOR (7 downto 0); -- Interface Bram lecture mirroir du registre write
           data_rd : in STD_LOGIC_VECTOR (3 downto 0); -- Interface Bram de la sortie (mûr à creuser)
           gen_done : out STD_LOGIC); -- Fin de la génération
end labyrinthe_generator;

architecture Behavioral of labyrinthe_generator is
    
    -- Définition des états de la machine à état
    type etat_type is(
        INIT, -- Mets tout le système de génération à 0
        INIT_BRAM, -- Mets toutes les cellules de la bram à 1
        POSE_DEPART, -- Pose la cellule (0, 0)
        AJOUT_NORD, -- Ajoute le voisin NORD dans la liste Bram
        AJOUT_SUD, -- Ajoute le voisin SUD dans la liste Bram
        AJOUT_EST, -- Ajoute le voisin EST dans la liste Bram
        AJOUT_OUEST, -- Ajoute le voisin OUEST dans la liste Bram
        AJOUT_NORD_ECRIRE,
        AJOUT_SUD_ECRIRE,
        AJOUT_EST_ECRIRE,
        AJOUT_OUEST_ECRIRE,
        PIOCHE, -- Tire un nombre au hasard depuis la ifsr_generator
        PIOCHE_LECTURE, -- Demande de lecture de la liste
        PIOCHE_CAPTURE,
        PIOCHE_DECODE,
        CAPTURE_DERNIER_IGNORE,
        CAPTURE_DERNIER_VISITE,
        VERIFICATION, -- Vérifie si la cellule voisine est visitée
        VERIFICATION_ATTENTE, -- Mets à jours cellule voisine
        IGNORER, -- Lit le dernier élement de la cellule visitée
        IGNORER_ECRIRE, -- Ecrit le dernier élement à la place du candidat ignoré
        CREUSER, -- Cellule non visité donc on abat le mûr
        LIRE_MUR_B,
        ATTENTE_MUR_B,
        ECRIRE_MUR_A, -- Ecrit les 4 bits de la cellule A dans la BRAM
        ECRIRE_MUR_A_WRITE,
        ECRIRE_MUR_B, -- Ecrit les 4 bits de la cellule B dans la BRAM
        ECRIRE_MUR_B_WRITE,
        IGNORER_ECRIRE_WRITE,
        MARQUER_VISITE, -- Marque la nouvelle cellule comme visitée
        MARQUER_VISITE_WRITE,
        ATTENTE_DERNIER_IGNORE,
        ATTENTE_DERNIER_VISITE,
        TERMINE -- Marque la fin de la génération
     );  
    signal etat : etat_type := INIT;
    
    -- Taille de la grille (16 * 16)
    constant COTE : integer := 16; -- Le côté
    
    -- component liste_bram
    component liste_bram
        Port ( clk : in STD_LOGIC;                                         
               we_a : in STD_LOGIC; -- Autorisation pour écrire ou pas     
               addr_w : in STD_LOGIC_VECTOR (8 downto 0); -- Adresse où écr
               din : in STD_LOGIC_VECTOR (9 downto 0); -- La cellule candidat
               addr_r : in STD_LOGIC_VECTOR (8 downto 0); -- Adresse à lire
               dout : out STD_LOGIC_VECTOR (9 downto 0)); -- le candidat lu
    end component;
    
    -- Signaux de la liste_bram
    signal liste_we_a : STD_LOGIC := '0';
    signal liste_addr_w : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
    signal liste_din : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
    signal liste_addr_r : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
    signal liste_dout : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
    
    -- Définition des signaux internes 
    signal taille_liste : unsigned(8 downto 0) := (others => '0'); -- Nombres d'élements dans la liste
    signal index_pioche : unsigned(8 downto 0) := (others => '0'); -- Index du prochain candidat sélectionné
    signal cellule_courante : unsigned(7 downto 0) := (others => '0'); -- Adresse de la cellule en cours de traitement
    signal cellule_voisine : unsigned(7 downto 0) := (others => '0'); -- Adresse de la cellule voisine à vérifier
    signal candidat_reg : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal dernier_reg  : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal direction_courante : STD_LOGIC_VECTOR (1 downto 0) := "00"; -- Direction du mûrs de la cellule (00=Nord 01=Sud 10=Est 11=Ouest)
    signal murs_cellule_a : STD_LOGIC_VECTOR(3 downto 0) := "1111"; --- murs lus de la cellule A avant toute modification
    signal murs_cellule_b : STD_LOGIC_VECTOR(3 downto 0) := "1111"; --- murs lus de la cellule b avant toute modification
    signal init_addr : unsigned(7 downto 0) := (others => '0');
    
    -- Tableau des cellules visités
    type visite_liste is array(0 to 255) of STD_LOGIC;
    signal visite_v_mem : visite_liste := (others => '0');
    
begin

    -- Instanciation de la liste bram
    liste_inst: liste_bram
        port map ( clk => clk,
                   we_a => liste_we_a,
                   addr_w => liste_addr_w,
                   din => liste_din,
                   addr_r => liste_addr_r,
                   dout => liste_dout);
                   
    -- Gestion de la machine à etat
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                etat <= INIT;
                gen_done <= '0';
                we_a <= '0';
                lfsr_next <= '0';
                liste_we_a <= '0';
                taille_liste <= (others => '0');
                cellule_voisine <= (others => '0');
                cellule_courante <= (others => '0');
                visite_v_mem <= (others => '0');
                addr_wr <= (others => '0');
                din_a   <= (others => '0');
                addr_rd <= (others => '0');
                index_pioche <= (others => '0');
                candidat_reg <= (others => '0');
                dernier_reg  <= (others => '0');
                init_addr <= (others => '0');

            else
                -- Valeurs par défauts au début du cycle
                we_a <= '0';
                lfsr_next <= '0';
                gen_done <= '0';
                liste_we_a <= '0';
                
                case etat is
                -- INIT remet tout à 0 sinon start démarre la machine
                    when INIT =>
                        taille_liste <= (others => '0');
                        cellule_voisine <= (others => '0');
                        cellule_courante <= (others => '0');
                        index_pioche <= (others => '0');
                        visite_v_mem <= (others => '0');
                        candidat_reg <= (others => '0');
                        dernier_reg  <= (others => '0');
                        init_addr <= (others => '0');
                        gen_done <= '0';
                        
                        if start = '1' then
                            init_addr <= (others => '0');
                            etat <= INIT_BRAM;
                        end if;
                        
                    when INIT_BRAM =>
                        -- On écrit "1111" dans toutes les 256 cellules
                        we_a <= '1';
                        addr_wr <= STD_LOGIC_VECTOR(init_addr);
                        din_a <= "1111";
                        if init_addr = 255 then
                            etat <= POSE_DEPART;
                        else
                            init_addr <= init_addr + 1;
                        end if;
                         
                    when POSE_DEPART =>
                    -- Le point de départ du labyrinthe
                        visite_v_mem(0) <= '1';
                        cellule_courante <= (others => '0');
                        etat <= AJOUT_NORD;
                        
                    when AJOUT_NORD =>
                        -- Voisin Nord (Y-1)
                        if cellule_courante(7 downto 4) /= "0000" and visite_v_mem(to_integer(cellule_courante - COTE)) = '0' then
                            liste_addr_w <= STD_LOGIC_VECTOR(taille_liste);
                            liste_din <= STD_LOGIC_VECTOR (cellule_courante) & "00";
                            etat <= AJOUT_NORD_ECRIRE;
                        else
                            etat <= AJOUT_SUD;
                        end if;
                        
                    when AJOUT_NORD_ECRIRE =>
                        liste_we_a <= '1';
                        taille_liste <= taille_liste + 1;
                        etat <= AJOUT_SUD;
                    
                    when AJOUT_SUD =>
                        -- Voisin Sud (Y+1) en réalité 15
                        if cellule_courante(7 downto 4) /= "1111" and visite_v_mem(TO_INTEGER(cellule_courante + COTE)) = '0' then
                            liste_addr_w <= STD_LOGIC_VECTOR(taille_liste);
                            liste_din <= STD_LOGIC_VECTOR(cellule_courante) & "01";
                            etat <= AJOUT_SUD_ECRIRE;
                         else
                            etat <= AJOUT_EST;
                         end if;
                         
                    when AJOUT_SUD_ECRIRE =>
                        liste_we_a <= '1';
                        taille_liste <= taille_liste + 1;
                        etat <= AJOUT_EST;
                         
                    when AJOUT_EST =>
                        -- Voisin Est (X+1)
                        if cellule_courante(3 downto 0) /= "1111" and visite_v_mem(TO_INTEGER(cellule_courante + 1)) = '0' then
                            liste_addr_w <= STD_LOGIC_VECTOR(taille_liste);
                            liste_din <= STD_LOGIC_VECTOR (cellule_courante) & "10";
                            etat <= AJOUT_EST_ECRIRE;
                        else
                            etat <= AJOUT_OUEST;
                        end if;
                        
                    when AJOUT_EST_ECRIRE =>
                        liste_we_a <= '1';
                        taille_liste <= taille_liste + 1;
                        etat <= AJOUT_OUEST;
                        
                    when AJOUT_OUEST =>
                        -- Voisin Ouest (X-1)
                        if cellule_courante(3 downto 0) /= "0000" and visite_v_mem(TO_INTEGER(cellule_courante - 1)) = '0' then
                            liste_addr_w <= STD_LOGIC_VECTOR(taille_liste);
                            liste_din <= STD_LOGIC_VECTOR(cellule_courante) & "11";
                            etat <= AJOUT_OUEST_ECRIRE;
                        else
                            etat <= PIOCHE;
                        end if;
                        
                    when AJOUT_OUEST_ECRIRE =>
                        liste_we_a <= '1';
                        taille_liste <= taille_liste + 1;
                        etat <= PIOCHE;
                        
                    when PIOCHE =>
                    -- On pioche un candidat au hasard et si la liste est vide alors toutes les cellules sont déjà visitées
                        lfsr_next <= '1';
                        if taille_liste = 0 then
                            etat <= TERMINE;
                         elsif unsigned(lfsr_val(8 downto 0)) < taille_liste then
                            index_pioche <= unsigned(lfsr_val(8 downto 0));
                            liste_addr_r <= lfsr_val(8 downto 0);
                         -- elsif (unsigned(lfsr_val)mod taille_liste) < taille_liste then
                           -- index_pioche <= unsigned(lfsr_val) mod taille_liste;
                           -- liste_addr_r <= STD_LOGIC_VECTOR(unsigned(lfsr_val) mod taille_liste);
                            etat <= PIOCHE_LECTURE;
                        else
                            etat <= PIOCHE;
                        end if;                           
                    
                    -- En attendant, on récupère cellule_courante et direction
                    when PIOCHE_LECTURE =>
                        etat <= PIOCHE_CAPTURE;
                        
                     when PIOCHE_CAPTURE =>
                        candidat_reg <= liste_dout;
                        etat <= PIOCHE_DECODE;
                     
                     when PIOCHE_DECODE =>
                        cellule_courante <= unsigned(candidat_reg(9 downto 2));
                        direction_courante <= candidat_reg(1 downto 0);
                        etat <= VERIFICATION;
                        
                    -- VERIFICATION :
                    -- On met à jours les cellules voisines
                    when VERIFICATION =>
                        case direction_courante is
                            when "00" => 
                                if cellule_courante(7 downto 4) /= "0000" then
                                    cellule_voisine <= cellule_courante - COTE; -- Direction Nord
                                    addr_rd <= STD_LOGIC_VECTOR(cellule_courante);
                                    etat <= VERIFICATION_ATTENTE;
                                else
                                    etat <= IGNORER;
                                end if; 
                                               
                            when "01" => 
                                if cellule_courante(7 downto 4) /= "1111" then
                                     cellule_voisine <= cellule_courante + COTE; -- Direction Sud
                                     addr_rd <= STD_LOGIC_VECTOR(cellule_courante);
                                     etat <= VERIFICATION_ATTENTE;
                                else
                                    etat <= IGNORER;
                                end if;
                                
                            when "10" => 
                            if cellule_courante(3 downto 0) /= "1111" then
                                 cellule_voisine <= cellule_courante + 1; -- Direction Est
                                 addr_rd <= STD_LOGIC_VECTOR(cellule_courante);
                                 etat <= VERIFICATION_ATTENTE;
                            else
                                etat <= IGNORER;
                            end if;
                            
                            when others => 
                            if cellule_courante(3 downto 0) /= "0000" then
                                cellule_voisine <= cellule_courante - 1; -- Autre Direction
                                addr_rd <= STD_LOGIC_VECTOR(cellule_courante);
                                etat <= VERIFICATION_ATTENTE;
                            else
                                etat <= IGNORER;
                            end if;
                        end case;
                    
                    when VERIFICATION_ATTENTE =>
                        if visite_v_mem(TO_INTEGER(cellule_voisine)) = '1' then
                            etat <= IGNORER;
                        else
                            etat <= CREUSER;
                        end if;
                    
                    when IGNORER =>
                        -- On retire ce candidat de la liste.
                        if taille_liste > 0 then
                            liste_addr_r <= STD_LOGIC_VECTOR(taille_liste - 1);
                            taille_liste <= taille_liste - 1;
                            etat <= ATTENTE_DERNIER_IGNORE;
                        else
                            etat <= TERMINE;
                        end if;
                    
                    when ATTENTE_DERNIER_IGNORE =>
                        etat <= CAPTURE_DERNIER_IGNORE;
                    
                    when CAPTURE_DERNIER_IGNORE =>
                        dernier_reg <= liste_dout;
                        etat <= IGNORER_ECRIRE;
                        
                    when IGNORER_ECRIRE =>
                        liste_addr_w <= STD_LOGIC_VECTOR(index_pioche);
                        liste_din <= dernier_reg;
                        etat <= IGNORER_ECRIRE_WRITE;
                    
                    when IGNORER_ECRIRE_WRITE =>
                        liste_we_a <= '1';
                        etat <= PIOCHE;
                        
                    when CREUSER =>
                        -- On abat le mûr mais avant on fait une lecture des mûrs de A
                        -- Quand la cellule n'est pas visité
                        murs_cellule_a <= data_rd;
                        addr_rd <= STD_LOGIC_VECTOR(cellule_voisine);
                        etat <= ATTENTE_MUR_B;
                        
                    when ATTENTE_MUR_B =>
                        etat <= LIRE_MUR_B;
                        
                    when LIRE_MUR_B =>
                        murs_cellule_b <= data_rd;
                        etat <= ECRIRE_MUR_A; 
                          
                   -- On abat le mûr coté cellule A
                   
                    when ECRIRE_MUR_A =>
                        addr_wr <= STD_LOGIC_VECTOR(cellule_courante);
                        
                        case direction_courante is
                            when "00" => din_a <= murs_cellule_a and "0111"; -- On abat le mûr Nord
                            when "01" => din_a <= murs_cellule_a and "1011"; -- On abat le mûr Sud
                            when "10" => din_a <= murs_cellule_a and "1101"; -- On abat le mûr Est
                            when others => din_a <= murs_cellule_a and "1110"; -- On abat le mûr Ouest
                        end case;
                        
                        etat <= ECRIRE_MUR_A_WRITE;
                    
                    when ECRIRE_MUR_A_WRITE =>
                        we_a <= '1';
                        etat <= ECRIRE_MUR_B;       
                   
                    when ECRIRE_MUR_B =>
                        addr_wr <= STD_LOGIC_VECTOR(cellule_voisine);
                        
                        case direction_courante is
                            when "00" => din_a <= murs_cellule_b and "1011"; -- Sud de B
                            when "01" => din_a <= murs_cellule_b and "0111"; -- Nord de B
                            when "10" => din_a <= murs_cellule_b and "1110"; -- Ouest de B
                            when others => din_a <= murs_cellule_b and "1101"; -- Est de B
                        end case;
                        -- On prépare la lecture du dernier élément
                        if taille_liste > 0 then
                            liste_addr_r <= STD_LOGIC_VECTOR(taille_liste - 1);
                        end if;
                        etat <= ECRIRE_MUR_B_WRITE;
                        
                    when ECRIRE_MUR_B_WRITE =>
                        we_a <= '1';
                        etat <= ATTENTE_DERNIER_VISITE;
                        
                    when ATTENTE_DERNIER_VISITE =>
                        etat <= CAPTURE_DERNIER_VISITE;
                        
                    when CAPTURE_DERNIER_VISITE =>
                        dernier_reg <= liste_dout;
                        etat <= MARQUER_VISITE;
                        
                    when MARQUER_VISITE =>
                        -- Lorsque c'est marqué visitée, on ajoute les voisins
                       visite_v_mem(TO_INTEGER(cellule_voisine)) <= '1';
                       -- On retire ensuite le candidat traité en écrivant le dernier à la place
                       if taille_liste > 0 then
                            liste_addr_w <= STD_LOGIC_VECTOR(index_pioche);
                            liste_din <= dernier_reg;
                            taille_liste <= taille_liste - 1;
                            etat <= MARQUER_VISITE_WRITE;
                       else     
                       -- La nouvelle cellule courante devient la cellule voisine
                       cellule_courante <= cellule_voisine;
                       etat <= AJOUT_NORD;
                       end if;
                       
                    when MARQUER_VISITE_WRITE =>
                        liste_we_a <= '1';
                        cellule_courante <= cellule_voisine;
                        etat <= AJOUT_NORD;
         
                    -- Labyrinthe termine    
                    when TERMINE =>
                        gen_done <= '1';
                        if start = '0' then
                            etat <= INIT;
                        end if;
                    
                    when others =>
                        etat <= INIT;
                        
                 end case;
               end if;
             end if;
         end process;
end Behavioral;
