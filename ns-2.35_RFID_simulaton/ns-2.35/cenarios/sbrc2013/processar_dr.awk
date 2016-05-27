BEGIN{
i=0;
cont=0;
}

{
   action=$1;
   cl1=$3;
   #cl2=$5;
   if( (action=="d")||(action=="r") ){
   	c1[i]=action;
	c2[i]=cl1;
   	i++;
   }
}

END {
   printf("%d\n",length(c1));
   for(j=0;j<length(c1);j++){
	 cont++
   }
   printf("%d\n",((cont)*8)/1000);
}
