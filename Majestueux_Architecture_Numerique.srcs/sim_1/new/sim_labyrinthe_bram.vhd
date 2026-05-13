----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2026 14:42:38
-- Design Name: 
-- Module Name: sim_labyrinthe_bram - Behavioral
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

entity sim_labyrinthe_bram is
--  Port ( );
end sim_labyrinthe_bram;

architecture Behavioral of sim_labyrinthe_bram is
    component labyrinthe_bram
        Port ( clk : in STD_LOGIC;
               we_a : in STD_LOGIC; 
               addr_a : in STD_LOGIC_VECTOR (7 downto 0); 
               din_a : in STD_LOGIC_VECTOR (3 downto 0); 
               addr_b : in STD_LOGIC_VECTOR (7 downto 0); 
               dout_b : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    -- Signaux à connecter au composant test
    signal clk_test : STD_LOGIC := '0';
    signal we_a_test : STD_LOGIC := '0';
    signal addr_a_test : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal din_a_test : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal addr_b_test : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal dout_b_test : STD_LOGIC_VECTOR(3 downto 0);
    
    -- Déclaration du signal d'horloge
    constant clk_period : time := 40 ns;
     
begin
    -- Instanciation du composant à utiliser
    uut : labyrinthe_bram port map (
        clk => clk_test,
        we_a => we_a_test,
        addr_a => addr_a_test,
        din_a => din_a_test,
        addr_b => addr_b_test,
        dout_b => dout_b_test );
        
      -- Génération de l'horloge
      clk_test <= not clk_test after clk_period/2;
      
      process
      begin
        
       --- Test 1 : Je vérifie l'initialisation
       we_a_test <= '0';
       addr_b_test <= "00000000";
       wait for 80ns;
       
       addr_b_test <= "00100011";
       wait for 80ns;
       
        --- Test 2 : On test cette fois ci l'écriture dans le registre addr_a
        we_a_test <= '1';
        addr_a_test <= "00100011";
        din_a_test <= "1101";
        wait for 40ns;
        
        we_a_test <= '0';
        wait for 40ns;
        
        --- On fait une lecture pour vérifier dans le registre addr_b
        addr_b_test <= "00100011";
        wait for 80ns;
        
        --- Test 3 : On essaye d'écrire sans l'intervention de we_a
        we_a_test <= '0';
        addr_a_test <= "00100011";
        din_a_test <= "0000";
        wait for 80ns;
        
        --- On fait une lecture pour voir 
        addr_b_test <= "00100011";
        wait for 80 ns;
        
        --- Test 4 : On ecrit et on lit simultanément
        we_a_test <= '1';
        addr_a_test <= "00000000";
        din_a_test <= "1110";
        addr_b_test <= "00100011";
        wait for 40ns;
        we_a_test <= '0';
        wait for 40ns;
        
        -- On vérifie si la case est bien écrite
        addr_b_test <= "00000000";
        wait for 80ns;
        
        --- Dernier test : On fait une écriture simultanée dans plusieurs cellules
        we_a_test <= '1';
        
        addr_a_test <= "00000000";
        din_a_test <= "1011";
        wait for 40ns;
        
        addr_a_test <= "00010000";
        din_a_test <= "0111";
        wait for 40ns;
        
        addr_a_test <= "00000001";
        din_a_test <= "1110";
        wait for 40ns;
        
        we_a_test <= '0';
        
        -- On vérifie les écritures
        
        addr_b_test <= "00000000";
        wait for 80ns;
        
        addr_b_test <= "00010000";
        wait for 80ns;
        
        addr_b_test <= "00000001";
        wait for 80ns;
        
        wait;
        end process;       
end Behavioral;
