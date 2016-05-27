#!/bin/bash
media=0
media_total=0
#rm -f *.csv
#rm -f *.txt
rm -f *.png
rm -f *.plt
rm -f INICIO2
rm -f FIM2
echo $(date) >> INICIO2
for ((j=$1; j<=$2; j=j+$3))
do
	media=0;
	media_total=0;
	linhas_trafego=0
	for i in $(seq 1 $4)
	do
		linhas_trafego=0
		ns cenario2.tcl cenario2.$j.$i.$5.csv $j $5
		trace-filter "(Is=0)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
		linhas=$(awk -f processar_d.awk cenario2.$j.filtrado.$i.$5.csv)
		linhas_trafego=$(echo "scale=10; $(awk -f processar_dr.awk cenario2.$j.filtrado.$i.$5.csv)"|bc -l)
		trace-filter "(Is=1)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
                linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario2.$j.filtrado.$i.$5.csv))" | bc -l)
		linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr.awk cenario2.$j.filtrado.$i.$5.csv))"|bc -l)
		trace-filter "(Is=2)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
		linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario2.$j.filtrado.$i.$5.csv))" | bc -l)
		linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr.awk cenario2.$j.filtrado.$i.$5.csv))"|bc -l)
		trace-filter "(Is=3)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
		linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario2.$j.filtrado.$i.$5.csv))" | bc -l)
		linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr.awk cenario2.$j.filtrado.$i.$5.csv))"|bc -l)
		trace-filter "(Is=4)" > cenario2.$j.filtrado.$i.$5.csv < cenario2.$j.$i.$5.csv
		linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario2.$j.filtrado.$i.$5.csv))" | bc -l)
		linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr.awk cenario2.$j.filtrado.$i.$5.csv))"|bc -l)
		echo $linhas_trafego >> "dat/2/$5/"$j.$5.traf
		rm -f cenario2.$j.$i.csv
		rm -f cenario2.$j.filtrado.$i.csv
		#rm -f *.csv
		linhas=$(echo "scale=10; ($linhas / 5)" | bc -l)
		echo 0$linhas >> "dat/2/$5/"$j.$5.txt
		media=$(echo "scale=10; ($media + $linhas)" | bc -l)
	done
	media=$(echo "scale=10; ($media / $4)" | bc -l)
done
echo $(date) >> FIM2
arquivo1="dat/2/$5/plot1_$5.dat"
arquivo2="dat/2/$5/plot1_traf_$5.dat"
caminho="dat/2/$5/"
perl ic2.pl $caminho| sort -g > $arquivo1
perl ic_trafego2.pl $caminho| sort -g > $arquivo2
