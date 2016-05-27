#!/bin/bash
#media=0
#media_total=0
#rm -f *.csv
#rm -f *.txt
#rm -f *.png
#rm -f *.plt
rm -f dat/1/$5/*.traf
rm -f INICIO1
rm -f FIM1
echo $(date) >> INICIO1
for ((j=$1; j<=$2; j=j+$3))
do
	#media=0;
	#media_total=0;
	linhas_trafego=0
	for i in $(seq 1 $4)
	do
		#ns cenario1.tcl cenario1.$j.$i.$5.csv $j $5
		trace-filter "(Is=0)" > cenario1.$j.filtrado.$i.$5.csv < cenario1.$j.$i.$5.csv
		#linhas=$(awk -f processar_d.awk cenario1.$j.filtrado.$i.$5.csv)
		linhas_trafego=$(echo "scale=10; $(awk -f processar_dr1.awk cenario1.$j.filtrado.$i.$5.csv)"|bc -l)
		echo $linhas_trafego
		trace-filter "(Is=1)" > cenario1.$j.filtrado.$i.$5.csv < cenario1.$j.$i.$5.csv
                #linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario1.$j.filtrado.$i.$5.csv))" | bc -l)
		linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr1.awk cenario1.$j.filtrado.$i.$5.csv))"|bc -l)
		trace-filter "(Is=2)" > cenario1.$j.filtrado.$i.$5.csv < cenario1.$j.$i.$5.csv
		echo $linhas_trafego
		#linhas=$(echo "scale=10; ($linhas+$(awk -f processar_d.awk cenario1.$j.filtrado.$i.$5.csv))" | bc -l)
		linhas_trafego=$(echo "scale=10; ($linhas_trafego+$(awk -f processar_dr1.awk cenario1.$j.filtrado.$i.$5.csv))"|bc -l)
		echo $linhas_trafego
		#rm -f cenario1.$j.$i.$5.csv
		rm -f cenario1.$j.filtrado.$i.$5.csv
		#rm -f *.csv
		#linhas=$(echo "scale=10; ($linhas / 3)" | bc -l)
                #echo 0$linhas >> "dat/1/$5/"$j.$5.txt
		echo $linhas_trafego >> "dat/1/$5/"$j.$5.traf
                #media=$(echo "scale=10; ($media + $linhas)" | bc -l)
	done
	#media=$(echo "scale=10; ($media / $4)" | bc -l)
done
echo $(date) >> FIM1
#arquivo1="dat/1/$5/plot1_$5.dat"
#arquivo2="dat/1/$5/plot1_traf_$5.dat"
#caminho="dat/1/$5/"
#perl ic1.pl $caminho| sort -g > $arquivo1
#perl ic_trafego1.pl $caminho | sort -g > $arquivo2
