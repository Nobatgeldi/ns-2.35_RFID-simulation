BEGIN{
i=0;
}

{
   action=$1;
   cl1=$7;
   cl2=$3;
   cl3=$13;
   if( (action=="r")&&(cl1==0)&&(cl3==5) ){
   	c1[i]=action;
	c2[i]=cl1;
	c3[i]=cl2;
	c4[i]=cl3;
   	i++;
   }
}

END {
   #for(j=1;j<=length(c1);j++){
   #	 printf("%d\n",c2[j]);
   #}
printf("%.9f\n",c3[length(c1)-1]*1000);
#printf("Descartados: %d\n",d);
}
