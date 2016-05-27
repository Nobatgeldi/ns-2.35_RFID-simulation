#!/bin/bash
#$1 - Initial nodes number
#$2 - Final nodes number
#$3 - Interval (tics)
#$4 - Iterations
rm -f *.tr
rm -f trace/rate/*.dat
rm -f trace/rate/*.tar.bz2
rm -f trace/rate/*.thr
rm -f trace/rate/*.col
rm -f trace/rate/*.suc
rm -f trace/rate/*.idl
rm -f trace/rate/START_RATE
rm -f trace/rate/END_RATE
echo $(date) >> START_RATE
for ((j=$1; j<=$2; j=j+$3))
do
	for i in $(seq 1 $4)
	do
		#setdest -n $(expr $j - 3) -p 2.0 -M 1.5 -t 1800 -x 30 -y 15 > motion.$j.$i.mov
		ns tracking.tcl rfid.$j.$i.tr $j
		collisions=$(awk -v opt=1 -f slots.awk rfid.$j.$i.tr)
		idle=$(awk -v opt=2 -f slots.awk rfid.$j.$i.tr)
		success=$(awk -v opt=3 -f slots.awk rfid.$j.$i.tr)
		thr=$(awk -f packets.awk rfid.$j.$i.tr)
                echo $collisions >> $j.col #collisions
		echo $idle >> $j.idl
		echo $success >> $j.suc
		echo $thr >> $j.thr
		tar jcvf rfid.$j.$i.tar.bz2 rfid.$j.$i.tr motion.$j.$i.mov
		mv rfid.$j.$i.tar.bz2 traces/rate/
		rm -f rfid.$j.$i.tr 
		rm -f motion.$j.$i.mov
	done
done
arquivo="col_rate.dat"
arquivo2="idl_rate.dat"
arquivo3="suc_rate.dat"
arquivo4="thr_rate.dat"
caminho="."
perl col.pl $caminho| sort -g > $arquivo
perl idl.pl $caminho| sort -g > $arquivo2
perl suc.pl $caminho| sort -g > $arquivo3
perl thr.pl $caminho| sort -g > $arquivo4
#mv *.tar.bz2 traces/rate/
echo $(date) >> END_RATE
mv *.col *.idl *.suc *.thr START_RATE END_RATE *.dat traces/rate/
