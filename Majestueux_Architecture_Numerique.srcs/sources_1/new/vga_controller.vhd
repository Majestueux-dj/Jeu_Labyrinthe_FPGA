----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2026 09:48:04
-- Design Name: 
-- Module Name: vga_controller - Behavioral
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

entity vga_controller is
    Port ( clk_carte : in STD_LOGIC;
           rst : in STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           h_compteur : out STD_LOGIC_VECTOR (9 downto 0);
           v_compteur : out STD_LOGIC_VECTOR (9 downto 0);
           h_active : out STD_LOGIC;
           v_active : out STD_LOGIC);
end vga_controller;

architecture Behavioral of vga_controller is

--- Déclaration des composants pour l'assemblage

--- Composant Horizontal compteur
    component horizontal_compteur
        Port ( clock : in STD_LOGIC;
               clk_ce : in STD_LOGIC; 
               rst : in STD_LOGIC;
               h_compteur : out STD_LOGIC_VECTOR (9 downto 0);
               hsync : out STD_LOGIC;
               h_active : out STD_LOGIC);
    end component;
    
--- Composant Vertical compteur
    component vertical_compteur
        Port ( clock : in STD_LOGIC;
               clk_ce : in STD_LOGIC;
               rst : in STD_LOGIC;
               hsync : in STD_LOGIC;
               v_compteur : out STD_LOGIC_VECTOR (9 downto 0);
               vsync : out STD_LOGIC;
               v_active : out STD_LOGIC);
    end component;

--- -- Clock enable 25MHz depuis 100MHz
    signal clk_ce : STD_LOGIC;
    signal div_cnt  : integer range 0 to 3 := 0;
    signal hsync_int : STD_LOGIC;
   
begin

-- Générateur de clock 100MHz pour 25MHz
    process(clk_carte)
    begin
        if rising_edge (clk_carte) then
            if rst = '1' then
                div_cnt <= 0;
                clk_ce <= '0';
            elsif div_cnt = 3 then
                div_cnt <= 0;
                clk_ce <= '1';
            else
                div_cnt <= div_cnt + 1;
                clk_ce <= '0';
            end if;
        end if;
   end process;
        
-- Instanciation du compteur horizontal
    h_compteur_inst: horizontal_compteur port map(
        clock => clk_carte,
        clk_ce => clk_ce,
        rst => rst,
        h_compteur => h_compteur,
        hsync => hsync_int,
        h_active => h_active);
        
 -- Instanciation du compteur vertical
    v_compteur_inst: vertical_compteur port map(
        clock => clk_carte,
        clk_ce => clk_ce,
        rst => rst,
        hsync => hsync_int,
        v_compteur => v_compteur,
        vsync => vsync,
        v_active => v_active);
        
-- On connecte mtn la sortie interne à la sortie
    hsync <= hsync_int;
      
end Behavioral;
