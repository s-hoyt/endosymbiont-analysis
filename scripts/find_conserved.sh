#!/usr/bin/env bash
#Generates file with all orthogroups, indicating whether my assembly is present or absent in each of the conserved groups
#Meaning:
#   1. Figure out if a given orthogroup is conserved, by making sure it's represented by each reference assembly. If not conserved, done.
#   2. Check if my assembly has at least one protein in this orthogroup.
#   3. If so, print PRESENT to file, else print ABSENT

refs=$1
assembly=$2
num_genomes=$3

while IFS=$'\t' read -ra line; do
    unset IFS
    present="true"
    num=$(($num_genomes-1))
    for i in `seq 1 $num`; do
	if [ ${line[$i]} -eq 0 ]; then
	    present="false"
	fi
    done
    if [ $present = "true" ]; then
	match=$(grep "${line[0]}" "$assembly")
	IFS=$'\t' read -ra carsonella <<< "$match"
	if [ ${carsonella["$num_genomes"]} -eq 0 ]; then
	    echo -e "${line[0]}\tABSENT" >> conserved_orthogroups.txt
	else
	    echo -e "${line[0]}\tPRESENT" >> conserved_orthogroups.txt
	fi  
    fi
done < <(tail -n +2 "$refs"  | cut -f 1-$num_genomes)
