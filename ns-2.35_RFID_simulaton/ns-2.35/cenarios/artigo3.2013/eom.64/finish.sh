#rm -f mean.02.3.dat
rm -f slots.02.3.dat
#arquivo="mean.02.3.dat"
arquivo2="slots.02.3.dat"
caminho="."
#perl ic_q.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
