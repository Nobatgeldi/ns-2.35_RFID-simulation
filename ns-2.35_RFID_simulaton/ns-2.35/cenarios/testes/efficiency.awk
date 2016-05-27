BEGIN{
i=0;
}

{
   action=$1; #send or receive
   cl1=$13;  #command
   cl2=$5; #flow type (reader-tag or tag-reader)
   cl3=$21; #collisions counter
   cl4=$25; #success counter
   cl5=$23; #idle counter
   #if( (action=="r")&&(cl2==0)&&(cl1==2) ){
        comando[i]=cl1;
        flow[i]=cl2;
	col[i]=cl3;
	suc[i]=cl4;
	idl[i]=cl5;
   	i++;
   #}
}

END {
   success=suc[length(suc)-1];
   total=suc[length(suc)-1]+col[length(suc)-1]+idl[length(suc)-1];
   idle=idl[length(suc)-1];
   collisions=col[length(suc)-1];
   if (opt==0) printf("%.4f\n",success/total);
   if (opt==1) printf("%d\n",success);
   if (opt==2) printf("%d\n",collisions);
   if (opt==3) printf("%d\n",idle);

}
