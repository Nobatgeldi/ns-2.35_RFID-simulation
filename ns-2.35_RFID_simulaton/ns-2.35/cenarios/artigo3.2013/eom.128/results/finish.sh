rm -f thr.eom..128.dat
rm -f slots.eom.128.dat
arquivo="thr.eom.128.dat"
arquivo2="slots.eom.128.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
