rm -f thr.col.q.4.dat
rm -f slots.col.q.4.dat
arquivo="thr.col.q.4.dat"
arquivo2="slots.col.q.4.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
