rm -f thr.2.39.64.dat
rm -f slots.2.39.64.dat
arquivo="thr.2.39.64.dat"
arquivo2="slots.2.39.64.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
