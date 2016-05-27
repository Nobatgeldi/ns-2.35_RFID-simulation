#!/bin/bash
rm -f INICIO2
rm -f FIM2
rm -f dat/2/1/*.txt
rm -f dat/2/0/*.txt
rm -f dat/2/1/*.dat
rm -f dat/2/0/*.dat
echo $(date) >> INICIO2
for ((j=$1; j<=$2; j=j+$3))
do
	for i in $(seq 1 $4)
	do
		#ns cenario2.tcl cenario2.$j.$i.$5.csv $j $5
		trace-filter "(Is=0)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
		linhas=$(awk -f processar_d.awk cenario2.$j.filtrado.$i.$5.csv)
		#linhas_trafego=$(echo "scale=10; $(awk -f processar_dr.awk cenario2.$j.filtrado.$i.$5.csv)"|bc -l)
		trace-filter "(Is=1)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
                linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario2.$j.filtrado.$i.$5.csv))" | bc -l)
		#linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr.awk cenario2.$j.filtrado.$i.$5.csv))"|bc -l)
		trace-filter "(Is=2)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
		linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario2.$j.filtrado.$i.$5.csv))" | bc -l)
		#linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr.awk cenario2.$j.filtrado.$i.$5.csv))"|bc -l)
		trace-filter "(Is=3)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
		linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario2.$j.filtrado.$i.$5.csv))" | bc -l)
		#linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr.awk cenario2.$j.filtrado.$i.$5.csv))"|bc -l)
		trace-filter "(Is=4)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
		linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario2.$j.filtrado.$i.$5.csv))" | bc -l)
		#linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr.awk cenario2.$j.filtrado.$i.$5.csv))"|bc -l)
		#echo $linhas_trafego >> "dat/2/$5/"$j.$5.traf
		rm -f cenario2.$j.filtrado.$i.csv
		linhas=$(echo "scale=10; ($linhas / 5)" | bc -l)
		echo 0$linhas >> "dat/2/$5/"$j.$5.txt
	done
done
echo $(date) >> FIM2
