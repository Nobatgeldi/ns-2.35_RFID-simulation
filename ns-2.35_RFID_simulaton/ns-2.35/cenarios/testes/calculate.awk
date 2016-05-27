BEGIN {
   name=fn ".col" 
   while (getline < name > 0 ) {
	f1_counter++
	f1[f1_counter]=$1
    }
    name=fn ".idl" 
    while (getline < name > 0 ) {
        f2_counter++
        f2[f2_counter]=$1
    }

}
{
	#printf("%.4f\n",(f1[NR]+f2[NR])/(f1[NR]+f2[NR]+$1))
	printf("%d\n",(f1[NR]+f2[NR]))
	#print f1[NR],f2[NR],$1
}
