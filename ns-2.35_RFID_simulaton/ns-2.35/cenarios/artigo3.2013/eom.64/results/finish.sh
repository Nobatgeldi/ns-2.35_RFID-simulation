rm -f thr.eom..64.dat
rm -f slots.eom.64.dat
arquivo="thr.eom.64.dat"
arquivo2="slots.eom.64.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
