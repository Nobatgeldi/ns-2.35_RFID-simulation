rm -f thr.col.q.5.dat
rm -f slots.col.q.5.dat
arquivo="thr.col.q.5.dat"
arquivo2="slots.col.q.5.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
