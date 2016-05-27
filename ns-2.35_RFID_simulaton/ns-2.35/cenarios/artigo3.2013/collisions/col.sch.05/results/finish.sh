rm -f thr.col.sch.5.dat
rm -f slots.col.sch.5.dat
arquivo="thr.col.sch.5.dat"
arquivo2="slots.col.sch.5.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
