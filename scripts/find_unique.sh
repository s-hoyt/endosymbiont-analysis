#!/usr/bin/env bash
#Writes to a file a list of all the orthogroups for which my assembly is a unique member
#Meaning:
#   1. checks that my assembly has a protein in this orthogroup
#   2. checks to see if this orthogroup is conserved (ie if at least 50% of other assemblies have it)
#   3. If not, then my assembly is within the minority of assemblies that have this orthogroup & it is then considered 'unique' to my assmebly (or to this group)

gene_count=$1
conserved=$2
num_col=$3

while IFS=$'\t' read -ra line; do
    unset IFS
    num=$((num_col-1))
    if [ ${line[$num]} -ne 0 ]; then
	check=0
	for i in `seq 1 $(($num-1))`; do
	    if [ ${line[$i]} -gt 0 ]; then
		check=$(($check + 1))
	    fi
	done
	if [ $check -lt $(($(($num-1)) / 2)) ]; then
	    echo -e "${line[0]}" >> unique.txt
	fi
    fi

done < <(tail -n +2 "$gene_count" | cut -f 1-$num_col)
