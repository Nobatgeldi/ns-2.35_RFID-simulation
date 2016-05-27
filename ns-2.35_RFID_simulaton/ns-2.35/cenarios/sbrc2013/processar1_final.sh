#!/bin/bash
rm -f INICIO1
rm -f FIM1
rm -f dat/1/0/*.txt
rm -f dat/1/0/*.traf
rm -f dat/1/1/*.txt
rm -f dat/1/1/*.traf
echo $(date) >> INICIO1
for ((j=$1; j<=$2; j=j+$3))
do
	for i in $(seq 1 $4)
	do
		trace-filter "(Id=0)||(Id=1)||(Id=2)" > cenario1.$j.filtrado.$i.$5.csv < cenario1.$j.$i.$5.csv
		linhas=$(awk -f perdas.awk cenario1.$j.filtrado.$i.$5.csv)
		linhas_trafego=$(echo "scale=10; $(awk -f trafego$5.awk cenario1.$j.filtrado.$i.$5.csv)"|bc -l)
		rm -f cenario1.$j.filtrado.$i.$5.csv
		echo 0$linhas >> "dat/1/$5/"$j.$5.txt
		echo $linhas_trafego >> "dat/1/$5/"$j.$5.traf
	done
done
echo $(date) >> FIM1
