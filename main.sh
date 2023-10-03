#!/bin/bash

# Tableur Shell SAE Paul :DISCROD:, Victor DELCROIX

#\ De ce que je comprend, le tableau peut être infini, ce qui aide pas 
#\ Impossible de le stocker dans un array donc 
#\ Pas de liste possible en shell donc il va faloir faire les calculs a la mano
#\ et stoker le tout dans un fichier res
#\ Pour l'effet recursif du truc faudrai un fichier buffer qui est comparré au fichier "final"
#\ Si ils sont identique on a fini le tableur (HYPER CHIANT)

# Variables du programme utilisées pour les paramètres de la fonction
feuille_in="Null"
feuille_out="Null"
sep_colone="\t"
sep_ligne="\n"
sep_colone_out="$sep_colone"
sep_ligne_out="$sep_ligne"
inverse=0

colonne_out_spe=0
ligne_out_spe=0

# Variables programme non paramètres
#* Continuer : https://linux.developpez.com/faq/?page=Commandes-avancees#Comment-lire-parcourir-un-fichier

# Mise en place des paramètres de l'appel du tableur
while [ $# -ne 0 ]
do
    case "$1" in # Regarde le paramètre, shift va placer le paramètre n°2 en n°1 pour la prochaine boucle
        "-in")
            shift 
            feuille_in="$1"
            shift # Obligé de faire 2 shift car le -* compte pour une place dans les paramètres
            ;;
        "-out")
            shift
            feuille_out="$1"
            shift
            ;;
        "-scin")
            shift
            sep_colone="$1"
            shift
            ;;
        "-slin")
            shift
            sep_ligne="$1"
            shift
            ;;
        "-scout")
            shift
            colonne_out_spe=1 # Vérifier si colone et ligne out ont été modifié pour les replacer comme les in plus tard 
            sep_colone_out="$1"
            shift
            ;;
        "-slout")
            shift
            ligne_out_spe=1
            sep_ligne_out="$1"
            shift
            ;;
        "-inverse")
            shift
            inverse=1
            shift
            ;;
        *)
            echo "$1 indefini"
            ;;
        esac

        # Remplacement des out par les in si les out n'ont pas été modifié 
        if [ $colonne_out_spe -eq 0 ]; then sep_colone_out="$sep_colone"; fi
        if [ $ligne_out_spe -eq 0 ]; then sep_ligne_out="$sep_ligne"; fi
done


# Test des paramètres
echo "feuille_in     : $feuille_in"
echo "feuille_out    : $feuille_out"
echo "sep_colone     : $sep_colone"
echo "sep_ligne      : $sep_ligne"
echo "sep_colone_out : $sep_colone_out"
echo "sep_ligne_out  : $sep_ligne_out"
echo "inverse        : $inverse"