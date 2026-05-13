----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2026 17:20:43
-- Design Name: 
-- Module Name: sim_vertical_compteur - Behavioral
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

entity sim_vertical_compteur is
--  Port ( );
end sim_vertical_compteur;

architecture Behavioral of sim_vertical_compteur is

    --  Déclaration du composant à utiliser
    component vertical_compteur
        Port ( clock : in STD_LOGIC;
               clk_ce : in STD_LOGIC;
               rst : in STD_LOGIC; 
               hsync : in STD_LOGIC; -- hsync venant du compteur vertical
               v_compteur : out STD_LOGIC_VECTOR (9 downto 0); -- Valeur du compteur de 0 à 520
               vsync : out STD_LOGIC; 
               v_active : out STD_LOGIC);
    end component;
    
    component horizontal_compteur
        Port ( clock : in STD_LOGIC;
               clk_ce : in STD_LOGIC;
               rst : in STD_LOGIC;
               h_compteur : out STD_LOGIC_VECTOR (9 downto 0); -- Valeur du compteur de 0 à 799
               hsync : out STD_LOGIC;
               h_active : out STD_LOGIC); -- Si h_active = 1 alors nous sommes dans la zone affichée (de 0 à 639)
    end component;
    
    -- Signaux pour connecter au composant
    signal clock_test : STD_LOGIC := '0';
    signal clk_ce_test : STD_LOGIC := '0';
    signal rst_test : STD_LOGIC := '0';
    signal hsync_test : STD_LOGIC;
    signal v_compteur_test: STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
    signal h_compteur_test: STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
    signal vsync_test : STD_LOGIC;
    signal v_active_test : STD_LOGIC;
    signal h_active_test : STD_LOGIC;
    
    -- On configure la période de la clock (Ici 25 Mhz)
    constant clk_period : time := 40 ns;
    
begin
    -- Instanciation du composant
    v_inst : vertical_compteur port map (
        clock => clock_test,
        clk_ce => clk_ce_test,
        rst => rst_test,
        v_compteur => v_compteur_test,
        hsync => hsync_test,
        vsync => vsync_test,
        v_active => v_active_test );
     
     h_inst : horizontal_compteur port map (
        clock => clock_test,
        clk_ce => clk_ce_test,
        rst => rst_test,
        h_compteur => h_compteur_test,
        hsync => hsync_test,
        h_active => h_active_test );
        
    -- Génération de la clock pour la simulation
    clock_test <= not clock_test after clk_period/2;
    
    process
    begin
    -- Test 1 : On test le reset (reset = 1)
    rst_test <= '1';
    wait for 80ns;
    rst_test <= '0';
    wait;
  end process;
  
end Behavioral;
