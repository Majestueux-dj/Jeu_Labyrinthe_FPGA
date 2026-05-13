----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2026 08:43:04
-- Design Name: 
-- Module Name: top_labyrinthe - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_labyrinthe is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           gen_done : out STD_LOGIC;
           addr_b : in  STD_LOGIC_VECTOR(7 downto 0);  -- adresse à lire pour l'affichage
           dout_b : out STD_LOGIC_VECTOR(3 downto 0);
           addr_c : in STD_LOGIC_VECTOR(7 downto 0); -- adresse à lire Joueur
           dout_c : out STD_LOGIC_VECTOR(3 downto 0)); 
           
end top_labyrinthe;

architecture Behavioral of top_labyrinthe is

    -- Déclaration des composants
    
    -- Ifsr generator
    component ifsr_generator
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               avance_pas : in STD_LOGIC;
               sortie_aleatoire : out STD_LOGIC_VECTOR(15 downto 0));
    end component;
    
    
    -- Labyrinthe_bram
    component labyrinthe_bram
        Port ( clk : in STD_LOGIC;
               we_a : in STD_LOGIC;
               addr_a : in STD_LOGIC_VECTOR (7 downto 0);
               din_a : in STD_LOGIC_VECTOR (3 downto 0);
               addr_b : in STD_LOGIC_VECTOR (7 downto 0);
               dout_b : out STD_LOGIC_VECTOR (3 downto 0);
               addr_c : in STD_LOGIC_VECTOR (7 downto 0);
               dout_c : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    -- Generateur de labyrinthe
    component labyrinthe_generator
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               start : in STD_LOGIC;
               lfsr_val : in STD_LOGIC_VECTOR (15 downto 0);
               lfsr_next : out STD_LOGIC;
               we_a : out STD_LOGIC;
               addr_wr : out STD_LOGIC_VECTOR (7 downto 0);
               din_a : out STD_LOGIC_VECTOR (3 downto 0);
               addr_rd : out STD_LOGIC_VECTOR (7 downto 0);
               data_rd : in STD_LOGIC_VECTOR (3 downto 0);
               gen_done : out STD_LOGIC);
    end component;
    
    --- Définition des signaux internes pour la connexion
    --- signux ifsr
    signal lfsr_val : STD_LOGIC_VECTOR (15 downto 0);
    signal lfsr_next : STD_LOGIC;
    
    -- signaux pour le labyrinthe_bram
    signal we_a : STD_LOGIC;
    signal addr_wr : STD_LOGIC_VECTOR (7 downto 0);
    signal din_a : STD_LOGIC_VECTOR (3 downto 0);
    signal addr_rd : STD_LOGIC_VECTOR (7 downto 0);
    signal data_rd : STD_LOGIC_VECTOR (3 downto 0);
    signal gen_done_int : STD_LOGIC;
    signal addr_b_mux : STD_LOGIC_VECTOR (7 downto 0);
    signal dout_b_int : STD_LOGIC_VECTOR (3 downto 0);
    
begin
    --  MUX :
    addr_b_mux <= addr_rd when gen_done_int = '0' else addr_b;
    gen_done <= gen_done_int;
    
    data_rd <= dout_b_int;
    dout_b <= dout_b_int;
    -- Instanciation du module ifsr_generator
    ifsr_inst: ifsr_generator
        port map ( clk => clk,
                   rst => rst,
                   avance_pas => lfsr_next,
                   sortie_aleatoire => lfsr_val);
     
     -- Instanciation du module labyrinthe_bram
     bram_inst : labyrinthe_bram
        port map ( clk => clk,
                   we_a => we_a,
                   addr_a => addr_wr,
                   din_a => din_a,
                   addr_b => addr_b_mux,
                   dout_b => dout_b_int,
                   addr_c => addr_c,
                   dout_c => dout_c );
      
     -- Instanciation du générateur
        laby_inst : labyrinthe_generator
            port map ( clk => clk,
                       rst => rst,
                       start => start,
                       lfsr_val => lfsr_val,
                       lfsr_next => lfsr_next,
                       we_a => we_a,
                       addr_wr => addr_wr,
                       din_a => din_a,
                       addr_rd => addr_rd,
                       data_rd => data_rd,
                       gen_done => gen_done_int);

end Behavioral;
