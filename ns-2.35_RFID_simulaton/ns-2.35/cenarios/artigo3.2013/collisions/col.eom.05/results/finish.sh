rm -f thr.col.eom.5.dat
rm -f slots.col.eom.5.dat
arquivo="thr.col.eom.5.dat"
arquivo2="slots.col.eom.5.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
