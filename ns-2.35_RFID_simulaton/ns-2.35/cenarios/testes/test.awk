BEGIN{
i=0;
}

{
   action=$1;
   #cl1=$7;
   #cl2=$3;
   cl1=$13;
   cl2=$21;
   cl3=$23;
   cl4=$25;
   cl5=$27;
   if( (action=="s")&&(cl1==2) ){
        comando[i]=cl1;
        col[i]=cl2;
        idl[i]=cl3;
        suc[i]=cl4;
        ses[i]=cl5;
   	i++;
   }
}

END {
 #  sessao=ses[0];
 #  total=0;
   #printf("Ses: %d\n",sessao);
 #  for(j=0;j<length(col);j++){
   	 #printf("(%d)(%d)(%d)\n",col[j],idl[j],suc[j]);
#	 if (ses[j]>sessao) {
#		total=total + col[j-1] + idl[j-1] + suc[j-1];
                #resultado=suc[j-1]/total;
		#printf("%.4f\n",resultado);
#		sessao=ses[j];
   #	 }
   #}
   #total=total + col[length(col)-1] + idl[length(col)-1] + suc[length(col)-1];
   #resultado=suc[length(col)-1]/total;
   printf("%d\n",total);
}
