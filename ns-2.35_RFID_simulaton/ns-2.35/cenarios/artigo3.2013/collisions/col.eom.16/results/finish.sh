rm -f thr.col.eom.16.dat
rm -f slots.col.eom.16.dat
arquivo="thr.col.eom.16.dat"
arquivo2="slots.col.eom.16.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
