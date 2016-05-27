#!/bin/bash
#$1 - Initial nodes number
#$2 - Final nodes number
#$3 - Interval (tics)
#$4 - Iterations
#rm -f *.tr
#rm -f traces/ns-2/*.dat
#rm -f traces/ns-2/*.tar.bz2
#rm -f traces/ns-2/*.thr
#rm -f traces/ns-2/*.col
#rm -f traces/ns-2/*.suc
#rm -f traces/ns-2/*.idl
#rm -f traces/ns-2/START
#rm -f traces/ns-2/END
#rm -f traces/ns-2/LOG

echo $(date) >> results/START
for ((j=$1; j<=$2; j=j+$3))
do
	for i in $(seq 1 $4)
	do
		echo "Inicio: $j.$i - " $(date +%d/%m/%y-%k:%M) >> results/LOG
		ns rfid_est.tcl rfid.$j.$i.tr $j
		thr=$(tail -n 1 rfid.$j.$i.tr | awk '{print $25/$19}')
                slots=$(tail -n 1 rfid.$j.$i.tr | awk '{print $19}')
                echo $thr >> results/$j.thr
                echo $slots >> results/$j.slots
		tar jcvf results/rfid.$j.$i.tar.bz2 rfid.$j.$i.tr
		rm -f rfid.$j.$i.tr
		echo "Fim   : $j.$i - " $(date +%d/%m/%y-%k:%M) >> results/LOG
	done
done
#arquivo="total_slots.shoute.dat"
#caminho="."
#perl slots.pl $caminho| sort -g > $arquivo
#cd results
#./finish.sh
echo "Fim   : $1.$2 - " $(date +%d/%m/%y-%k:%M) >> results/END
