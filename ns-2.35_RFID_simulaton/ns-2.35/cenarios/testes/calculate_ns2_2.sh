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

echo $(date) >> START
for ((j=$1; j<=$2; j=j+$3))
do
	for i in $(seq 1 $4)
	do
		echo "Inicio: $j.$i - " $(date +%d/%m/%y-%k:%M) >> LOG
		ns rfid_2.tcl rfid.$j.$i.tr $j
		collisions=$(awk -v opt=2 -f efficiency.awk rfid.$j.$i.tr)
		idle=$(awk -v opt=3 -f efficiency.awk rfid.$j.$i.tr)
		success=$(awk -v opt=1 -f efficiency.awk rfid.$j.$i.tr)
		thr=$(awk -v opt=0 -f efficiency.awk rfid.$j.$i.tr)
		#efi=$(awk -f packets.awk rfid.$j.$i.tr)
                echo $collisions >> $j.col #collisions
		echo $idle >> $j.idl
		echo $success >> $j.suc
		echo $thr >> $j.thr
		#echo $efi >> $j.efi
		tar jcvf rfid.$j.$i.tar.bz2 rfid.$j.$i.tr
		mv rfid.$j.$i.tar.bz2 traces/ns-2/
		rm -f rfid.$j.$i.tr
		echo "Fim   : $j.$i - " $(date +%d/%m/%y-%k:%M) >> LOG
		#mv *.col *.idl *.suc *.thr traces/ns-2
	done
done
#arquivo="col_rate.dat"
#arquivo2="idl_rate.dat"
#arquivo3="suc_rate.dat"
#arquivo4="thr_rate.dat"
#arquivo5="efi_rate.dat"
#caminho="."
#perl col.pl $caminho| sort -g > $arquivo
#perl idl.pl $caminho| sort -g > $arquivo2
#perl suc.pl $caminho| sort -g > $arquivo3
#perl thr.pl $caminho| sort -g > $arquivo4
#perl efi.pl $caminho| sort -g > $arquivo5
#mv *.tar.bz2 traces/ns-2/
#echo $(date) >> END
echo "Fim   : $1.$2 - " $(date +%d/%m/%y-%k:%M) >> END
#mv *.col *.idl *.suc *.thr START END LOG *.dat traces/ns-2/
