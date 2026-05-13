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

## Structure du projet

\```
Majestueux_Architecture_Numerique.srcs/
├── sources_1/new/        → Sources VHDL principales
│   ├── top_vga.vhd           Top-level VGA
│   ├── top_labyrinthe.vhd    Top-level labyrinthe
│   ├── labyrinthe_generator.vhd
│   ├── labyrinthe_bram.vhd
│   ├── jeux_logique.vhd
│   ├── rendu_affichage.vhd
│   ├── ecran_load.vhd
│   ├── ecran_over.vhd
│   ├── ecran_win.vhd
│   ├── timer.vhd
│   ├── vga_controller.vhd
│   ├── horizontal_compteur.vhd
│   ├── vertical_compteur.vhd
│   ├── clock_div.vhd
│   ├── ifsr_generator.vhd
│   └── liste_bram.vhd
├── sim_1/new/            → Testbenches de simulation
│   ├── sim_clock_div.vhd
│   ├── sim_horizontal_compteur.vhd
│   ├── sim_vertical_compteur.vhd
│   ├── sim_ifsr_generator.vhd
│   ├── sim_labyrinthe_bram.vhd
│   └── sim_labyrinthe_generator.vhd
└── constrs_1/new/        → Contraintes XDC
    └── contraints.xdc
contraints.xdc            → Contraintes XDC (racine)
top_vga.bit               → Bitstream généré
top_vga.mcs               → Fichier de programmation flash
Majestueux_Architecture_Numerique.xpr  → Fichier projet Vivado
\```

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
