#!/bin/sh

# Fonction récupérant la valeur d'une case
getValue(){
	lig=`echo $1 | sed -E 's/^l([0-9]+)c[0-9]+$/\1/g'`
	col=`echo $1 | sed -E 's/^l[0-9]+c([0-9]+)$/\1/g'`
	recup_lig=`cat "$file_in" | cut -d"$sep_lig" -f"$lig"`
	res=`echo "$recup_lig" | cut -d"$sep_col" -f"$col"`
}

# Fonction calculant l'exponentiel
exp(){
	res=`echo "scale=2;e($1)" | bc -l`	
}

# Fonction calculant la racine carrée
sqrt(){
	res=`echo "scale=2;sqrt($1)" | bc -l`
}

# Fonction calculant le logarithme népérien
ln(){
	res=`echo "scale=2;l($1)" | bc -l`
}

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

# Concatène deux paramètres
concat(){
	res="$1$2"
}

# Donne la taille du mot passé en paramètre
length(){
	res=`expr length "$1"`
}

# Donne la taille du fichier passé en paramètre
size(){
	res=`wc -c < "$1"`
}

# Donne le nombre de ligne du fichier passé en paramètre
lines(){
	res=`sed -n '$=' $1`
}

# Initialisation des variables principaux du programme (délimite les séparateurs, les fichiers utilisés etc ...)
i=0
file_in="Null"
file_out="Null"
sep_col="\t"
sep_lig="
"
sep_lig_ret=0
sep_col_ret=0
inverse=0

est_col_ret=0
est_lig_ret=0

# Evaluation des options passés en param
while [ $# -ne 0 ]
do
	case "$1" in 
		"-in")
			shift
			file_in="$1"
			shift
			;;
		"-out")
			shift
			file_out="$1"
			shift
			;;
		"-scin")
			shift
			sep_col="$1"
			shift
			;;

		"-slin")
			shift
			sep_lig="$1"
			shift
			;;
		"-scout")
			shift
			est_col_ret=1
			sep_col_ret="$1"
			shift
			;;
		"-slout")
			shift
			est_lig_ret=1
			sep_lig_ret="$1"
			shift
			;;
		"-inverse")
			inverse=1
			;;
		*)
			echo "$1 indéfini ou ne trouve pas de correspondance."
			shift
			;;
		esac

		# Si les options -slout et -scout ne sont pas spécifiés alors ils sont 
		# identiques au séparateur de lignes/colonnes
		if [ $est_lig_ret -eq 0 ]; then sep_lig_ret="$sep_lig"; fi
		if [ $est_col_ret -eq 0 ]; then sep_col_ret="$sep_col"; fi
done

moyenneIntervale l1c1 l1c3
echo "Résultat : $res"

#echo "calcul dans la feuille stockée dans le fichier $file_in où le spérateur de colonnes est $sep_col, le séparteur del igne est $sep_lig. La feuille calculée sera affiché sur $file_out avec comme séparateur de colonne le symbole $sep_col_ret"


