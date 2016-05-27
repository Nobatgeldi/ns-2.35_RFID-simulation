#!/bin/bash
rm -f INICIO1
rm -f FIM1
rm -f dat/1/$5/*.txt
rm -f dat/1/$5/*.dat
echo $(date) >> INICIO1
for ((j=$1; j<=$2; j=j+$3))
do
	for i in $(seq 1 $4)
	do
		#ns cenario1.tcl cenario1.$j.$i.$5.csv $j $5
		trace-filter "(Is=0)" > cenario1.$j.filtrado.$i.$5.csv < cenario1.$j.$i.$5.csv
		linhas=$(awk -f processar_d.awk cenario1.$j.filtrado.$i.$5.csv)
		#linhas_trafego=$(echo "scale=10; $(awk -f processar_dr.awk cenario1.$j.filtrado.$i.$5.csv)"|bc -l)
		trace-filter "(Is=1)" > cenario1.$j.filtrado.$i.$5.csv < cenario1.$j.$i.$5.csv
                linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario1.$j.filtrado.$i.$5.csv))" | bc -l)
		#linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr.awk cenario1.$j.filtrado.$i.$5.csv))"|bc -l)
		trace-filter "(Is=2)" > cenario1.$j.filtrado.$i.$5.csv < cenario1.$j.$i.$5.csv
		linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario1.$j.filtrado.$i.$5.csv))" | bc -l)
		#linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr.awk cenario1.$j.filtrado.$i.$5.csv))"|bc -l)
		rm -f cenario1.$j.filtrado.$i.$5.csv
		linhas=$(echo "scale=10; ($linhas / 3)" | bc -l)
                echo 0$linhas >> "dat/1/$5/"$j.$5.txt
		#echo $linhas_trafego >> "dat/1/$5/"$j.$5.traf
	done
done
echo $(date) >> FIM1
