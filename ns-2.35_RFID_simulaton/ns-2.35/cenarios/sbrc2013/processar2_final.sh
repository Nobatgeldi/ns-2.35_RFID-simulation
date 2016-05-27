#!/bin/bash
rm -f INICIO2
rm -f FIM2
rm -f dat/2/$5/*.traf
#rm -f dat/2/1/*.traf
echo $(date) >> INICIO2
for ((j=$1; j<=$2; j=j+$3))
do
	for i in $(seq 1 $4)
	do
		trace-filter "(Id=0)||(Id=1)||(Id=2)||(Id=3)||(Id=4)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
		#linhas=$(awk -f perdas.awk cenario2.$j.filtrado.$i.$5.csv)
		linhas_trafego=$(echo "scale=10; $(awk -f trafego$5.awk cenario2.$j.filtrado.$i.$5.csv)"|bc -l)
		rm -f cenario2.$j.filtrado.$i.$5.csv
		#echo $linhas >> "dat/2/$5/"$j.$5.txt
		echo $linhas_trafego >> "dat/2/$5/"$j.$5.traf
	done
done
echo $(date) >> FIM2
