#!/bin/bash

# Tableur Shell SAE Paul Sangnier, Victor DELCROIX

#\ De ce que je comprends, le tableau peut être infini, ce qui aide pas 
#\ Impossible de le stocker dans un array donc 
#\ Pas de liste possible en shell donc il va faloir faire les calculs a la mano
#\ et stocker le tout dans un fichier res
#\ Pour l'effet recursif du truc faudrai un fichier buffer qui est comparré au fichier "final"
#\ Si ils sont identique on a fini le tableur

#* Liens Utiles
#* https://linuxize.com/post/bash-if-else-statement/
#* https://linuxize.com/post/bash-increment-decrement-variable/
#* https://linuxhint.com/bash_operator_examples/#:~:text=Different%20types%20of%20operators%20exist,string%20operators%2C%20and%20file%20operators.

# Commandes possibles dans le tableur

# Paul
# Fonction récupérant la valeur d'une case
getValue(){
	lig=`echo $1 | sed -E 's/^l([0-9]+)c[0-9]+$/\1/g'`
	col=`echo $1 | sed -E 's/^l[0-9]+c([0-9]+)$/\1/g'`
	recup_lig=`cat "$file_in" | cut -d"$sep_lig" -f"$lig"`
	res=`echo "$recup_lig" | cut -d"$sep_col" -f"$col"`
}

# Paul
# Fonction calculant l'exponentiel
exp(){
	res=`echo "scale=2;e($1)" | bc -l`	
}

# Paul
# Fonction calculant la racine carrée
sqrt(){
	res=`echo "scale=2;sqrt($1)" | bc -l`
}

# Paul
# Fonction calculant le logarithme népérien
ln(){
	res=`echo "scale=2;l($1)" | bc -l`
}

# Victor
# Fonction calculant la somme de l'intervalle passé en paramètre
sommeIntervale(){
	var1a=`echo $1 | sed -E 's/^l([0-9]+)c[0-9]+$/\1/g'`
	var2a=`echo $1 | sed -E 's/^l[0-9]+c([0-9]+)$/\1/g'`
	var1b=`echo $2 | sed -E 's/^l([0-9]+)c[0-9]+$/\1/g'`
	var2b=`echo $2 | sed -E 's/^l[0-9]+c([0-9]+)$/\1/g'`
	i="$var1a"
	somme=0
	while [ "$i" -le "$var2a" ]
	do
  		j="$var1b"
  		while [ "$j" -le "$var2b" ]
  		do
			param="l${i}c${j}"
    			getValue "$param"
    			somme=`expr $somme + $res`
			j=`expr $j + 1`
  		done
		i=`expr $i + 1`
	done

	res="$somme"
}

# Victor
# Fonction calculant la moyenne de l'intervalle passé en paramètre
moyenneIntervale(){
	sommeIntervale "$1" "$2"
	var1a=`echo $1 | sed -E 's/^l([0-9]+)c[0-9]+$/\1/g'`
	var2a=`echo $1 | sed -E 's/^l[0-9]+c([0-9]+)$/\1/g'`
	var1b=`echo $2 | sed -E 's/^l([0-9]+)c[0-9]+$/\1/g'`
	var2b=`echo $2 | sed -E 's/^l[0-9]+c([0-9]+)$/\1/g'`
	nb_col=`expr "$var2b" - "$var2a"`
	nb_col=`expr $nb_col + 1`
	nb_lig=`expr "$var1b" - "$var1a"`
	nb_lig=`expr $nb_lig + 1`
	nb_elt=`expr $nb_lig \* $nb_col`
	res=`echo "scale=2;$res / $nb_elt" | bc -l` 
}

# Victor
# Fonction recherchant le minimum de l'intervalle passé en paramètre
minIntervale(){
    var1a=`echo $1 | sed -E 's/^l([0-9]+)c[0-9]+$/\1/g'`
	var2a=`echo $1 | sed -E 's/^l[0-9]+c([0-9]+)$/\1/g'`
	var1b=`echo $2 | sed -E 's/^l([0-9]+)c[0-9]+$/\1/g'`
    var2b=`echo $2 | sed -E 's/^l[0-9]+c([0-9]+)$/\1/g'`
    i="$var1a"
    getValue "l${var1a}c${var2a}"
    min="$res"
	while [ "$i" -le "$var2a" ]
	do
  		j="$var1b"
        while [ "$j" -le "$var2b" ]
        do
			getValue "l${i}c${j}"
        if [ $min -gt "$res" ]; then min="$res"; fi
        j=`expr $j + 1`
        done
        i=`expr $i + 1`
    done
    res="$min"   
}

# Victor
# Fonction recherchant le maximum de l'intervalle passé en paramètre
maxIntervale(){
    var1a=`echo $1 | sed -E 's/^l([0-9]+)c[0-9]+$/\1/g'`
	var2a=`echo $1 | sed -E 's/^l[0-9]+c([0-9]+)$/\1/g'`
	var1b=`echo $2 | sed -E 's/^l([0-9]+)c[0-9]+$/\1/g'`
    var2b=`echo $2 | sed -E 's/^l[0-9]+c([0-9]+)$/\1/g'`
    i="$var1a"
    getValue "l${var1a}c${var2a}"
    max="$res"
	while [ "$i" -le "$var2a" ]
	do
  		j="$var1b"
        while [ "$j" -le "$var2b" ]
        do
			getValue "l${i}c${j}"
        if [ $max -lt "$res" ]; then min="$res"; fi
        j=`expr $j + 1`
        done
        i=`expr $i + 1`
    done
    res="$min"   
}

# Victor & Paul
# Concatène deux paramètres
concat(){
	res="$1$2"
}

# Victor & Paul
# Donne la taille du mot passé en paramètre
length(){
	res=`expr length "$1"`
}

# Victor & Paul
# Donne la taille du fichier passé en paramètre
size(){
	res=`wc -c < "$1"`
}

# Victor & Paul
# Donne le nombre de ligne du fichier passé en paramètre
lines(){
	res=`sed -n '$=' $1`
}


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
lignes_table=()

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

# Lecture du fichier, mise en place dans l'array ligne_table
while IFS="$sep_colone" read -r line
do
    lignes_table+=("$line")
done < "$feuille_in"


# Affichage du fichier
afficher_table(){
    reading_file_index=0
    echo "-----------------------------"
    for line in "${lignes_table[@]}"
    do
        line_array=()
        readarray -d "$sep_colone" -t line_array <<< "$line"
        for ((n=0; n < ${#line_array[*]}; n++))
        do
            if [ "$n" -ne "$(("${#line_array[*]}"-1))" ]
            then 
                echo -n "|${line_array[n]}"
            else 
                echo "|"
            fi
        done
        echo "-----------------------------"
    done
}

afficher_table


# Test des paramètres
# echo "feuille_in     : $feuille_in"
# echo "feuille_out    : $feuille_out"
# echo "sep_colone     : $sep_colone"
# echo "sep_ligne      : $sep_ligne"
# echo "sep_colone_out : $sep_colone_out"
# echo "sep_ligne_out  : $sep_ligne_out"
# echo "inverse        : $inverse"