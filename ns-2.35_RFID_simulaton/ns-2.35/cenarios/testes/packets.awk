BEGIN{
i=0;
}

{
   action=$1; #send or receive
   cl1=$13;  #command
   cl2=$5; #flow type (reader-tag or tag-reader)
   if( (action=="s")&&(cl2==1) ){
        comando[i]=cl1;
        flow[i]=cl2;
   	i++;
   }
}

END {
   total=length(comando);
   success=0;
   for(j=0;j<length(comando);j++){
	 if (comando[j]==5) { success++; }
   }
   printf("%.4f\n",success/total);
}
