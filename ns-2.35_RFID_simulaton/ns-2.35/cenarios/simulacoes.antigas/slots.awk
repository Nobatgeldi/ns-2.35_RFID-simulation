BEGIN{
i=0;
}

{
   action=$1;
   cl1=$13;
   cl2=$21;
   cl3=$23;
   cl4=$25;
   cl5=$27;
   cl6=$7;
   if( (action=="s")&&(cl1==2)&&(cl5>=1) ){
        comando[i]=cl1;
        col[i]=cl2;
        idl[i]=cl3;
        suc[i]=cl4;
        ses[i]=cl5;
	id[i]=cl6;
   	i++;
   }
}

END {
   sessao=ses[0];
   ident=id[0];
   total=0;
   #for(j=0;j<length(col);j++){
   #	printf("%d %d %d\n",col[j],idl[j],suc[j]);
   #}
   for(j=0;j<length(col);j++){
	 #if ( (ses[j]!=sessao)||(id[j]!=ident) ) {
	 if (ses[j]>sessao) {
		if (opt==1) { #Collisions count
			total=total + col[j-1];
		}
		if (opt==2) { #Idle count
                        total=total + idl[j-1];
                }
		if (opt==3) { #Success count
                        total=total + suc[j-1];
                }
		sessao=ses[j];
		ident=id[j];
	 }
   }
   if (opt==1) { #Collisions count
               total=total + col[j-1];
   }
   if (opt==2) { #Idle count
               total=total + idl[j-1];
   }
   if (opt==3) { #Success count
               total=total + suc[j-1];
   }
   printf("%d\n",total);
}
