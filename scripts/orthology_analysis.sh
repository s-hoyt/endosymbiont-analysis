#!/usr/bin/env bash
#Writes to a file indicating whether my assembly is predicted to be missing proteins, have duplicates, or have the right number for each orthogroup
#Meaning:
#   1. Get the median number of proteins in a given orthogroup across all reference assemblies -> serves to establish expected number of proteins
#   2. Compare this median to the number of proteins from my assembly in this orthogroup and print MISSING, DUPLICATED, EQUAL as appropriate

refs=$1
assembly=$2
num_genomes=$3

while IFS=$'\t' read -ra line && IFS=$'\t' read -ra otherline <&3; do
    unset IFS
    orthogroup="${line[0]}"
    dcfl="${otherline[(($num_genomes))]}"
    declare -a genomes=()
    num=$(($num_genomes-1))
    for i in `seq 1 $num`; do
	genomes[$(($i-1))]=${line[i]}
    done

    IFS=$'\n' sorted=($(sort <<<"${genomes[*]}"))
    unset IFS

    if [ $(($(($num_genomes - 1)) % 2)) -eq 0 ]; then
	mid=$(($num_genomes / 2))
	echo "$mid"
	median=$((((${sorted[$mid]} + ${sorted[$(($mid-1))]})) / 2))
    else
	median=${sorted[$(($num_genomes / 2))]}
    fi
    if [ "$median" -gt "$dcfl" ]; then
	echo -e "$orthogroup\t$median\t$dcfl\tMISSING" >> medians.txt
    elif [ "$median" -lt "$dcfl" ]; then
	echo -e "$orthogroup\t$median\t$dcfl\tDUPLICATED">> medians.txt
    else
	echo -e "$orthogroup\t$median\t$dcfl\tEQUAL" >> medians.txt
    fi
    
done < <(tail -n +2 "$refs") 3< <(tail -n +2 "$assembly")
