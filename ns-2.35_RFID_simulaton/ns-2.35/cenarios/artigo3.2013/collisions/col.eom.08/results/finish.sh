rm -f thr.col.eom.8.dat
rm -f slots.col.eom.8.dat
arquivo="thr.col.eom.8.dat"
arquivo2="slots.col.eom.8.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
