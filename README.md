# Jeu Labyrinthe FPGA — Architecture Numérique

Projet réalisé dans le cadre du cours d'Architecture Numérique à l'UBS.  
Implémentation d'un jeu de labyrinthe sur FPGA en VHDL, avec affichage VGA.

## Description

Le joueur se déplace dans un labyrinthe généré aléatoirement affiché sur écran VGA.  
Le projet tourne sur carte FPGA et inclut :

- Génération procédurale du labyrinthe (LFSR)
- Affichage VGA (640x480)
- Gestion du timer, écran de victoire et game over
- Stockage du labyrinthe en BRAM

## Prérequis

- Vivado 2024.x (ou version compatible)
- Carte FPGA compatible (Basys3 / Nexys4)
- Écran avec entrée VGA

## Utilisation

1. Ouvrir `Majestueux_Architecture_Numerique.xpr` dans Vivado
2. Synthétiser et implémenter le projet
3. Flasher `top_vga.bit` sur la carte FPGA via le Hardware Manager
4. Connecter un écran VGA
5. Utiliser les boutons de la carte pour naviguer dans le labyrinthe

## Auteur

Djossou — UBS, 2026
