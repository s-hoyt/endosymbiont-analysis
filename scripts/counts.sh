#!/usr/bin/env bash
#takes in $groups which is list of orthgroups, either conserved or unique
#takes in column, which is whichever species you are running this on
#so run it once for each species and it will append it to the file and at the end you have the counts of proteins in either conserved or unique orthogroups for each species.
#genecounts = /home/shh89/data/carsonella_contigs/orthofinder/references_and_cars/Results_Jul19/Orthogroups.GeneCount.csv

groups=$1
column=$2
genecount=$3

for i in `seq 2 $column`; do
    count=0
    strain=$(head -n 1 $genecount | cut -f $i)

    while read -r line; do
	temp=$(grep "$line" $genecount | cut -f $i)

	count=$(($count + $temp))
    done < <(cat $groups | cut -f 1)

    echo -e "$strain\t$count" >> counts.txt

 done
