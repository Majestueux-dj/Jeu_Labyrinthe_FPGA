----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2026 14:42:59
-- Design Name: 
-- Module Name: liste_bram - Behavioral
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

entity liste_bram is
    Port ( clk : in STD_LOGIC;
           we_a : in STD_LOGIC; -- Autorisation pour écrire ou pas
           addr_w : in STD_LOGIC_VECTOR (8 downto 0); -- Adresse où écrire (0 à 511) 
           din : in STD_LOGIC_VECTOR (9 downto 0); -- La cellule candidate à écrire
           addr_r : in STD_LOGIC_VECTOR (8 downto 0); -- Adresse à lire
           dout : out STD_LOGIC_VECTOR (9 downto 0)); -- le candidat lu
end liste_bram;

architecture Behavioral of liste_bram is

    -- On déclare ici un tablezu de 512 cases de 10 bits chacun pour stocker les candidats
    type liste_array is array(0 to 511) of STD_LOGIC_VECTOR(9 downto 0);
    signal liste_mem : liste_array := (others => (others => '0'));
    signal dout_reg : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
    
begin

    process(clk)
    begin
        if rising_edge (clk) then
            if we_a = '1' then
                liste_mem(TO_INTEGER(UNSIGNED(addr_w))) <= din;
            end if;
                dout_reg <= liste_mem(TO_INTEGER(unsigned(addr_r)));
        end if;
    end process;
    
    dout <= dout_reg;
    
end Behavioral;
