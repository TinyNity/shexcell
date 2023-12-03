#!/bin/sh

# Auteurs :
#   Sagnier Paul
#   Delcroix Victor

# L3 Informatique

messageError="Utilisation : ./tableur [-in feuille] [-out resultat] [-scin sep] [-scout sep] [-slin sep] [-slout sep] [-inverse]"
test $# -eq 0 && echo "Veuillez vérifier les paramètres entrés.\n$messageError" && exit 1


special_calcul() {
  test $# -ne 2 && echo "La fonction special_calcul() demande 2 arguments.\n <$i>" && exit 1
  analyseur $2
  local arg="$analyseur_resultat"
  test $1 = "ln" && analyseur_resultat="`echo "l($arg)" | bc -l`" && return 0
  analyseur_resultat="`echo "$1($arg)" | bc -l`"
}

moyenne() {
  test $# -ne 2 && echo "La fonction moyenne() a besoin de 2 arguments. <$i>" && exit 1
  somme $1 $2
  analyseur_resultat=`echo "$analyseur_resultat / $somme_loopLength" | bc -l`
}

somme() {
  test $# -ne 2 && echo "La fonction somme() a besoin de 2 arguments. <$i>" && exit 1
  local lineOfArg1=`echo "$1" | grep -o -E '[0-9]+' | head -n1`
  local colOfArg1=`echo "$1" | grep -o -E '[0-9]+' | tail -n1`
  local lineOfArg2=`echo "$2" | grep -o -E '[0-9]+' | head -n1`
  local colOfArg2=`echo "$2" | grep -o -E '[0-9]+' | tail -n1`
  local current_lineSize=`head -n$lineOfArg1 "$source" | tail -n1 | grep -o "[^$scin]*" | wc -l`
  local somme=0
  somme_loopLength=0

  while test $lineOfArg1 -ne $lineOfArg2 -o $colOfArg1 -ne $colOfArg2
  do
    getValue "l$lineOfArg1 c$colOfArg1"
    somme=`expr "$somme" + "$analyseur_resultat"`
    if test $colOfArg1 -ge $current_lineSize
    then
      lineOfArg1=`expr $lineOfArg1 + 1`
      colOfArg1=1
      current_lineSize=`head -n$lineOfArg1 "$source" | tail -n1 | grep -o "[^$scin]*" | wc -l`
    else
      colOfArg1=`expr $colOfArg1 + 1`
    fi
    somme_loopLength=`expr $somme_loopLength + 1`
  done
  getValue "l$lineOfArg1 c$colOfArg1"

  analyseur_resultat=`expr "$somme" + "$analyseur_resultat"`
}

variance(){
  test $# -ne 2 && echo "La fonction variance() a besoin de 2 arguments. <$i>" && exit 1
  moyenne $1 $2
  local moyenne="$analyseur_resultat"
  local lineOfArg1=`echo "$1" | grep -o -E '[0-9]+' | head -n1`
  local colOfArg1=`echo "$1" | grep -o -E '[0-9]+' | tail -n1`
  local lineOfArg2=`echo "$2" | grep -o -E '[0-9]+' | head -n1`
  local colOfArg2=`echo "$2" | grep -o -E '[0-9]+' | tail -n1`
  local current_lineSize=`head -n$lineOfArg1 "$source" | tail -n1 | grep -o "[^$scin]*" | wc -l`
  local somme_variance=0
  somme_loopLength=0

  while test $lineOfArg1 -ne $lineOfArg2 -o $colOfArg1 -ne $colOfArg2
  do
    getValue "l$lineOfArg1 c$colOfArg1"
    somme_variance="`echo "("$analyseur_resultat" - "$moyenne") * ("$analyseur_resultat" - "$moyenne") + $somme_variance" | bc -l`"
    if test $colOfArg1 -ge $current_lineSize
    then
      lineOfArg1="`expr $lineOfArg1 + 1`"
      colOfArg1=1
      current_lineSize="`head -n$lineOfArg1 "$source" | tail -n1 | grep -o "[^$scin]*" | wc -l`"
    else
      colOfArg1="`expr $colOfArg1 + 1`"
    fi
    somme_loopLength="`expr $somme_loopLength + 1`"
  done
  getValue "l$lineOfArg1 c$colOfArg1"

  somme_variance="`echo "("$analyseur_resultat" - "$moyenne") * ("$analyseur_resultat" - "$moyenne") + $somme_variance" | bc -l`"
  analyseur_resultat="`echo "$somme_variance / ($somme_loopLength + 2)" | bc -l`"
}

ecarttype() {
  test $# -ne 2 && echo "La fonction ecarttype() a besoin de 2 arguments.\n <$i>" && exit 1
  variance $1 $2
  local variance="$analyseur_resultat"
  analyseur_resultat=`echo "sqrt("$analyseur_resultat")" | bc -l`
}

max() {
  test $# -ne 2 && echo "La fonction max() a besoin de 2 arguments.\n <$i>" && exit 1
  local lineOfArg1=`echo "$1" | grep -o -E '[0-9]+' | head -n1`
  local colOfArg1=`echo "$1" | grep -o -E '[0-9]+' | tail -n1`
  local lineOfArg2=`echo "$2" | grep -o -E '[0-9]+' | head -n1`
  local colOfArg2=`echo "$2" | grep -o -E '[0-9]+' | tail -n1`
  local current_lineSize=`head -n$lineOfArg1 "$source" | tail -n1 | grep -o "[^$scin]*" | wc -l`
  max_loopLength=0

  getValue $1
  local max="$analyseur_resultat"

  while test $lineOfArg1 -ne $lineOfArg2 -o $colOfArg1 -ne $colOfArg2
  do

    if test $colOfArg1 -ge $current_lineSize
    then
      lineOfArg1=`expr $lineOfArg1 + 1`
      colOfArg1=1
      current_lineSize=`head -n$lineOfArg1 "$source" | tail -n1 | grep -o "[^$scin]*" | wc -l`
    else
      colOfArg1=`expr $colOfArg1 + 1`
    fi
    getValue "l$lineOfArg1 c$colOfArg1"

    test $max -lt $analyseur_resultat && max="$analyseur_resultat"

    somme_loopLength=`expr $somme_loopLength + 1`
  done

  analyseur_resultat="$max"
}

min() {
  test $# -ne 2 && echo "La fonction max() a besoin de 2 arguments.\n <$i>" && exit 1
  local lineOfArg1=`echo "$1" | grep -o -E '[0-9]+' | head -n1`
  local colOfArg1=`echo "$1" | grep -o -E '[0-9]+' | tail -n1`
  local lineOfArg2=`echo "$2" | grep -o -E '[0-9]+' | head -n1`
  local colOfArg2=`echo "$2" | grep -o -E '[0-9]+' | tail -n1`
  local current_lineSize=`head -n$lineOfArg1 "$source" | tail -n1 | grep -o "[^$scin]*" | wc -l`
  min_loopLength=0

  getValue $1
  local min="$analyseur_resultat"

  while test $lineOfArg1 -ne $lineOfArg2 -o $colOfArg1 -ne $colOfArg2
  do

    if test $colOfArg1 -ge $current_lineSize
    then
      lineOfArg1=`expr $lineOfArg1 + 1`
      colOfArg1=1
      current_lineSize=`head -n$lineOfArg1 "$source" | tail -n1 | grep -o "[^$scin]*" | wc -l`
    else
      colOfArg1=`expr $colOfArg1 + 1`
    fi
    getValue "l$lineOfArg1 c$colOfArg1"

    test $min -gt $analyseur_resultat && min="$analyseur_resultat"
    somme_loopLength=`expr $somme_loopLength + 1`
  done

  analyseur_resultat="$min"
}

shell() {
  test $# -ne 1 && echo "shell() a besoin de 1 argument.\n <$i>" && exit 1
  
  shell_Arg=`echo $1 | tr '_' ' '`
  analyseur_resultat="`$shell_Arg`"
}

getValue() {
  test $# -ne 1 && echo "getValue() a besoin de 1 argument.\n <$i>" && exit 1

  local line=`echo "$1" | grep -o -E '[0-9]+' | head -n1`
  local col=`echo "$1" | grep -o -E '[0-9]+' | tail -n1`

  analyseur_resultat=`head -n"$line" "$source" | tail -n1 | cut -d"$scin" -f"$col"`
  analyseur `echo "$analyseur_resultat" | tr ' ' '_' | sed -e "s/\r//g"`
}

size() {
  test $# -ne 1 && echo "size() a besoin de 1 argument.\n <$i>" && exit 1
  local arg1="$1"

  if ! test -e "$1"
  then
    analyseur "$1"
    arg1=`echo "$analyseur_resultat" | sed "s|\(.*\)$slin.*|\1|"`
    ! test -e $arg1 && echo "! <$arg1> ou <$1> n'est pas un fichier" && return 1
  fi

  analyseur_resultat=`wc -c $arg1 | cut -d' ' -f1`
}

lines() {
  test $# -ne 1 && echo "size() a besoin de 1 argument.\n <$i>" && exit 1
  local arg1=$1

  if ! test -e $1
  then
    analyseur $1

    arg1=`echo "$analyseur_resultat" | sed "s|\(.*\)"$slin".*|\1|"`
    ! test -e $arg1 && echo "<$arg1> n'est pas un fichier" && return 1
  fi

  analyseur_resultat=`wc -l $arg1 | cut -d' ' -f1`
}

length() {
  test $# -ne 1 && echo "length() a besoin de 1 argument.\n <$i>" && exit 1
  local arg1
  analyseur $1
  arg1="$analyseur_resultat"

  analyseur_resultat=`echo -n $arg1 | wc -m`
}

concat() {
  test $# -ne 2 && echo "concat() a besoin de 2 arguments.\n <$i>" && exit 1
  local arg1
  local arg2
  analyseur $1
  arg1="$analyseur_resultat"
  analyseur $2
  arg2="$analyseur_resultat"

  analyseur_resultat="$arg1$arg2"
}

substitute() {
  test $# -ne 3 && echo "subsitute() a besoin de 3 arguments.\n <$i>" && exit 1
  local target
  local arg1
  local arg2

  analyseur $1
  target="$analyseur_resultat"
  analyseur $2
  arg1="$analyseur_resultat"
  analyseur $3
  arg2="$analyseur_resultat"

  analyseur_resultat=`echo "$target" | sed -e "s/"$arg1"/"$arg2"/g"`
}

calcul() {
  test $# -ne 3 && echo "calcul() a besoin de 3 arguments.\n <$i>" && exit 1
  local arg1
  local arg2
  analyseur $2
  arg1="$analyseur_resultat"
  analyseur $3
  arg2="$analyseur_resultat"

  test $1 = "x" && analyseur_resultat=`echo "$arg1 * $arg2" | bc -l` && return 0
  test $1 = "/" -a $arg2 -eq 0 && echo "Division par 0." && exit 1

  analyseur_resultat=`echo "$arg1 $1 $arg2" | bc -l`
}

analyseur() {
  test $# -ne 1 && echo "analyseur() a besoin de 1 argument.\n <$i>" && exit 1
  test -e $1 && analyseur_resultat="$1" && return 0
  analyseur_funName=`echo $1 | cut -d'=' -f2 | cut -d'(' -f1`

  if test -z "`echo $analyseur_funName | grep -o -e "\[*l[0-9]*\c[0-9]*\]*"`"
  then
    analyseur_funArg=`echo "$1" | cut -d'(' -f2- | sed 's|\(.*\)).*|\1|'`
    case $analyseur_funName in
    "shell")
      shell $analyseur_funArg;;
    "+"|"-"|"x"|"/"|"^")
      calcul $analyseur_funName `echo "$analyseur_funArg" | tr ',' ' '`;;
    "ln"|"e"|"sqrt")
      special_calcul $analyseur_funName "`echo "$analyseur_funArg" | tr ',' ' '`";;
    "somme")
      somme `echo "$analyseur_funArg" | tr ',' ' '`;;
    "moyenne")
      moyenne `echo "$analyseur_funArg" | tr ',' ' '`;;
    "variance")
      variance `echo "$analyseur_funArg" | tr ',' ' '`;;
    "ecarttype")
      ecarttype `echo "$analyseur_funArg" | tr ',' ' '`;;
    "max")
      max `echo "$analyseur_funArg" | tr ',' ' '`;;
    "min")
      min `echo "$analyseur_funArg" | tr ',' ' '`;;
    "concat")
      concat `echo "$analyseur_funArg" | tr ',' ' '`;;
    "length")
      length "`echo "$analyseur_funArg" | tr ',' ' '`";;
    "size")
      size "`echo "$analyseur_funArg" | tr ',' ' '`";;
    "substitute")
      substitute `echo "$analyseur_funArg" | tr ',' ' '`;;
    *)
      analyseur_resultat="$1";;
    esac
  else
    getValue $1
  fi
}


while test $# -ge 1
do
  case $1 in
  "-in")
    source="$2";;

  "-out")
    dest="$2";;

  "-scin")
    scin="$2";;

  "-slin")
    slin="$2";;

  "-scout")
    scout="$2";;

  "-slout")
    slout="$2";;

  "-inverse")
    inverse=1;;

  *) echo "Arg <$1 $2> non reconnue. Arrêt du script.\n$messageError" && exit 1;;

  esac
  if test "$1" != "-inverse"; then shift && shift; else shift; fi
done

# les arguments non spécifiés #
test -z "$scin" && scin="\t" 
test -z "$slin" && slin="\n" 
test -z "$scout" && scout="$scin"
test -z "$slout" && slout="$slin"
test -z $inverse && inverse=0
# ---------------- #
# test du fichier en arg '-in' #
if test -z $source || ! test -f $source
then
  # echo "On lira la sortie standard"
  stdin=1
  source_buffer=""
  ! test -f $source && echo "$source n'est pas accepté par le script."
  echo "Veuillez saisir les valeurs de votre tableur : \n"

  while read line && test -n "$line"
  do
    source_buffer="$source_buffer$line$slin"
  done

  random=`shuf -i 1-10000 -n 1`
  source="source_tmp_$random.csv"
  echo "`echo "$source_buffer" | sed "s|\(.*\)\n.*|\1|"`" > "$source"
else
  # echo "On lira <$source> plus tard"
  ! test -f $source && echo "$source n'existe pas." && exit 1
  stdin=0
fi

# Test de l'existances des fichier
if test -z $dest
then
  stdout=1
  echo "Le résultat sera affiché sur la sortie standard"
else
  stdout=0
  echo "Le résultat sera redirigé vers <$dest>"
fi

echo "\n"

nbLine=`wc -l < $source`
destBuffer=""

echo "Traitement en cours..."
while IFS=$slin read line
do

  for i in `echo $line | grep -o -e "[^$scin]*" | tr ' ' '_'`
  do
    i=`echo "$i" | sed -e "s/\r//g"`
    # echo "<$i>"
    if test -z `echo "$i" | grep -o -E "="`
    then
      destBuffer="$destBuffer$i"
    else
      analyseur $i
      destBuffer="$destBuffer$analyseur_resultat"
    fi

    destBuffer="$destBuffer$scout"
  done

  destBuffer=`echo $destBuffer | sed "s|\(.*\)[$scout].*|\1|"`

  destBuffer="$destBuffer$slout"
  destRes="$destRes$destBuffer"
  destBuffer=""
done < $source


echo "Traitement terminé ! \n"
# Inversion des lignes et colones #
if test $inverse -eq 1
then
  echo "Transposition de la feuille..."
  i=0
  while read IFS="$slin" line
  do
    nbLine=`echo "$line" | tr "$scin" "$slin" | wc -l`
    test "$i" -lt "$nbLine" && i="$nbLine"
  done < "$source"
  tmp_i=1
  test "$slout" != '\n' && destRes="`echo "$destRes" | tr "$slout" '\n'`"
  destRes_tmp="$destRes"
  destRes=""
  i="`expr $i + 1`"
  while test "$tmp_i" -le "$i"
  do
    destBuffer=""
    destBuffer=`echo "$destRes_tmp" | cut -d"$scout" -f"$tmp_i" -s | tr '\r' '\n' | tr '\n' "$scout" | sed "s|\(.*\)["$scout"].*|\1|"`
    destRes="$destRes$destBuffer$slout"
    tmp_i=`expr $tmp_i + 1`
  done
  echo "Transposition terminé !\n"
fi

# Supprimer le fichier tampon
test $stdin -eq 1 && rm $source

if test $stdout -eq 0
then
  echo "$destRes" > "$dest"
  echo "Votre tableur calculé est disponible dans le fichier $dest !"
else
  destRes=`echo "$destRes" | tr '\r' $slout`
  echo "$destRes" | cat -v
fi