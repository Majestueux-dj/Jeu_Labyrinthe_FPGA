----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2026 13:46:45
-- Design Name: 
-- Module Name: labyrinthe_bram - Behavioral
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

entity labyrinthe_bram is
    Port ( clk : in STD_LOGIC; -- clock 100 Mhz
           we_a : in STD_LOGIC; -- Si on doit écrire ou pas ( 1 ou 0 )
           addr_a : in STD_LOGIC_VECTOR (7 downto 0); -- L'adresse du registre où on écrit
           din_a : in STD_LOGIC_VECTOR (3 downto 0); -- Les 4 mûrs d'une cellule
           addr_b : in STD_LOGIC_VECTOR (7 downto 0); -- L'adresse mirroir de addr_a où on vient lire (lecture)
           dout_b : out STD_LOGIC_VECTOR (3 downto 0); -- Retourne les 4 mûrs d'une cellule qui sera demandés (lecture)
           
           addr_c : in STD_LOGIC_VECTOR(7 downto 0); -- L'adresse pour lire la position du joueur
           dout_c : out STD_LOGIC_VECTOR (3 downto 0)); -- Données pour la lecture du joueur
end labyrinthe_bram;

architecture Behavioral of labyrinthe_bram is

--- On crée au départ notre grille de 256 cellules de 4 bits chacun
    type grille_array is array(0 to 255) of STD_LOGIC_VECTOR(3 downto 0);
--- Toute les cellules sont à 1 au départ
    signal cell_mem : grille_array := (others => "1111");
    signal dout_b_reg : STD_LOGIC_VECTOR(3 downto 0) := "1111";
    signal dout_c_reg : STD_LOGIC_VECTOR(3 downto 0) := "1111";

begin

--- Ecriture et lecture
    process(clk)
    begin
        if rising_edge(clk) then
            if we_a = '1' then
                cell_mem(TO_INTEGER(unsigned(addr_a))) <= din_a;
            end if;
                -- Lecture du port b
                dout_b_reg <= cell_mem(to_integer(unsigned(addr_b)));
                
                -- Lecture du port c
                dout_c_reg <= cell_mem(to_integer(unsigned(addr_c)));
        end if;
    end process;
    
    dout_b <= dout_b_reg;
    dout_c <= dout_c_reg;
    
end Behavioral;
