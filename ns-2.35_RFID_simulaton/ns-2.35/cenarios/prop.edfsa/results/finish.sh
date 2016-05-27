rm -f thr.prop.edfsa.0.67.3.dat
rm -f slots.prop.edfsa.0.67.3.dat
arquivo="thr.prop.edfsa.0.67.3.dat"
arquivo2="slots.prop.edfsa.0.67.3.dat"
arquivo3="thr.prop.edfsa.0.67.3.norm.dat"
caminho="."
perl ic_thr.pl $caminho| sort -g > $arquivo
perl ic_slots.pl $caminho| sort -g > $arquivo2
perl ic_thr.norm.pl $caminho| sort -g > $arquivo3
