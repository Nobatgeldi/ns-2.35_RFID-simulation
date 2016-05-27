rm -f thr.col.lb.3.dat
rm -f slots.col.lb.3.dat
arquivo="thr.col.lb.3.dat"
arquivo2="slots.col.lb.3.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
