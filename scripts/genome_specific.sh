#!/usr/bin/env bash

orthogroups=$1
num_genomes=$2

while IFS=$'\t' read -ra line; do
    unset IFS
    total=$(($num_genomes + 1))

    for i in `seq 1 $num_genomes`; do
#	echo ${line[i]}
#	echo ${line[$total]}
	tot1=${line[$total]}
	tot2="${tot1//[$'\t\r\n ']}"
	if [ ${line[$i]} -eq $tot2 ]; then
	    echo -e "${line[0]}\t$i"
	fi
    done
    
done < <(tail -n +2 "$orthogroups")
