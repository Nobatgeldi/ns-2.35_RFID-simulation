rm -f thr.col.2.45.2.dat
rm -f slots.col.2.45.2.dat
arquivo="thr.col.2.45.2.dat"
arquivo2="slots.col.2.45.2.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
