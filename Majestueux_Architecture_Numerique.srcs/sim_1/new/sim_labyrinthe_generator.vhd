----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.03.2026 17:16:42
-- Design Name: 
-- Module Name: sim_labyrinthe_generator - Behavioral
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

entity sim_labyrinthe_generator is
--  Port ( );
end sim_labyrinthe_generator;

architecture Behavioral of sim_labyrinthe_generator is

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
    
    component ifsr_generator
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               avance_pas : in STD_LOGIC;
               sortie_aleatoire : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    component labyrinthe_bram
        Port ( clk : in STD_LOGIC;
               we_a : in STD_LOGIC; 
               addr_a : in STD_LOGIC_VECTOR (7 downto 0);
               din_a : in STD_LOGIC_VECTOR (3 downto 0); 
               addr_b : in STD_LOGIC_VECTOR (7 downto 0); 
               dout_b : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    -- Définition des signaux tests à connecter au composant
    signal clk_test : STD_LOGIC := '0';
    signal rst_test : STD_LOGIC := '0';
    signal start_test : STD_LOGIC := '0';
    signal lfsr_val_test : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal lfsr_next_test : STD_LOGIC;
    signal gen_done_test : STD_LOGIC := '0';
    signal we_a_test : STD_LOGIC := '0';
    signal addr_wr_test : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal din_a_test : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal addr_rd_test : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal data_rd_test : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    
    --- On configure la période de la clock
    constant clk_period : time := 40 ns;
    
begin
    
    -- Instanciation des composants
    isfr_inst : ifsr_generator port map(
        clk => clk_test,
        rst => rst_test,
        avance_pas => lfsr_next_test,
        sortie_aleatoire => lfsr_val_test);
        
    bram_inst : labyrinthe_bram port map(
        clk => clk_test,
        we_a => we_a_test,
        addr_a => addr_wr_test,
        din_a => din_a_test,
        addr_b => addr_rd_test,
        dout_b => data_rd_test);
        
    uut : labyrinthe_generator port map(
        clk => clk_test,
        rst => rst_test,
        start => start_test,
        lfsr_val => lfsr_val_test,
        lfsr_next => lfsr_next_test,
        we_a => we_a_test,
        addr_wr => addr_wr_test,
        din_a => din_a_test,
        addr_rd => addr_rd_test,
        data_rd => data_rd_test,
        gen_done => gen_done_test);
    
    --- Génération de la clock pour la simulation
    clk_test <= not clk_test after clk_period/2;
    
    process
    begin
    
        -- Test 1 : Reset initial
        rst_test <= '1';
        start_test <= '0';
        wait for 80ns;
        rst_test <= '0';
        wait for 80ns;
        
        -- Test 2 : On lance ici la génération
        start_test <= '1';
        wait for 40ns;
        start_test <= '0';
        
        -- On attends que notre labyrinthe soit généré. 
        wait until gen_done_test = '1' for 5ms;
        assert gen_done_test = '1'
        report "Erreur : generation non terminee avant timeout"
        severity error;
        wait;
        
    end process;
    
end Behavioral;
