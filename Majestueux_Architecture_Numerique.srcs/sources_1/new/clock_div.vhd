----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2026 15:49:23
-- Design Name: 
-- Module Name: clock_div - clock_architecture
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

entity clock_div is
    Port ( clk_in : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clock_div;

architecture clock_architecture of clock_div is
    signal compteur : integer range 0 to 1 := 0;
    signal clk_tmp : STD_LOGIC := '0';
begin
    process(clk_in, rst)
    begin
    if rst = '1' then
    -- Alors le reset est actif et on met tout à 0
        compteur <= 0;
        clk_tmp <= '0';
        
    -- Sinon on agit uniquement que sur le front montant
    elsif rising_edge(clk_in) then
        if compteur = 1 then 
            compteur <= 0;
            clk_tmp <= not clk_tmp; -- On inverse ici (0 devient 1 et 1 devient 0)
            else
            -- Si le compteur n'a pas encore atteint 1 on fait juste une incrémentation
            compteur <= compteur + 1;
        end if;
    end if;  
    
    end process;
    -- On connecte la sortie à clk_tmp
    clk_out <= clk_tmp;
    
end clock_architecture;
