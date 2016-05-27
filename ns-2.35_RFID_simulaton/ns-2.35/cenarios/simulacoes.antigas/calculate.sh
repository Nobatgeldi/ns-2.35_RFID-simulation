#!/bin/bash
#$1 - Initial nodes number
#$2 - Final nodes number
#$3 - Interval (tics)
#$4 - Iterations
rm -f *.tr
rm -f sample.dat
rm -f START
rm -f END
echo $(date) >> START
for ((j=$1; j<=$2; j=j+$3))
do
	for i in $(seq 1 $4)
	do
		ns rfid.tcl rfid.$j.$i.tr $j
		linhas=$(awk -f number.awk rfid.$j.$i.tr)
                echo $linhas >> $j.value
	done
done
arquivo="sample.dat"
caminho="."
perl ic.pl $caminho| sort -g > $arquivo
mv *.tr traces/
echo $(date) >> END
mv *.value START END traces/
mv sample.dat traces/
