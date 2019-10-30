#!/usr/bin/env bash
#Writes to a file a list of all the orthogroups for which my assembly is a unique member
#Specific to profftella, because there is not a file of conserved orthogroups for profftella (meaningless given only 2 other assemblies)
#So instead just base it on gene counts directly
#Thought: Should we change the 'unique' defn for profftella since we changed the 'conserved' defn?
#Meaning:
#   1. checks that my assembly has a protein in this orthogroup
#   2. checks to see if this orthogroup is conserved (ie if at least 50% of other assemblies have it)
#   3. If not, then my assembly is within the minority of assemblies that have this orthogroup & it is then considered 'unique' to my assembly (or to this group)  

gene_counts=$1

while IFS=$'\t' read -ra line; do
    unset IFS
    if [ ${line[3]} -ne 0 ]; then
	count=0
	for i in `seq 1 2`; do
	    if [ ${line[i]} -eq 0 ]; then
	       ((count+=1))
	    fi
	done
	if [ $count -ge 1 ]; then
	    echo -e "${line[0]}" >> unique.txt
	fi
    fi

done < <(tail -n +2 "$gene_counts")
