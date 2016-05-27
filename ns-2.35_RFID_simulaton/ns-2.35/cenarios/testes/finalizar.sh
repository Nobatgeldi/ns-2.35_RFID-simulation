arquivo="col_rate.dat"
arquivo2="idl_rate.dat"
arquivo3="suc_rate.dat"
arquivo4="thr_rate.dat"
#arquivo5="efi_rate.dat"
caminho="."
perl col.pl $caminho| sort -g > $arquivo
perl idl.pl $caminho| sort -g > $arquivo2
perl suc.pl $caminho| sort -g > $arquivo3
perl thr.pl $caminho| sort -g > $arquivo4
#perl efi.pl $caminho| sort -g > $arquivo5
#mv *.tar.bz2 traces/ns-2/
echo $(date) >> END
mv *.col *.idl *.suc *.thr START END LOG *.dat traces/ns-2/
