rm -f thr.prop.dat
rm -f slots.prop.dat
rm -f thr.norm.prop.dat
arquivo="thr.prop.dat"
arquivo2="slots.prop.dat"
arquivo3="thr.norm.prop.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
perl ic_thr.norm.pl $caminho| sort -g > $arquivo3
