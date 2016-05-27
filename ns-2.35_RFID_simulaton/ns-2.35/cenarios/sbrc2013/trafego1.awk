BEGIN{
i=0;
cont=0;
}

{
   action=$1;
   #cl1=$33;
   #cl2=$9;
   #cl3=$3;
   if( ((action=="d")||(action=="r")) ){
   	c1[i]=action;
	#c2[i]=cl1;
	#c3[i]=cl2;
	#c4[i]=cl3;
   	i++;
   }
}

END {
   for(j=0;j<length(c1);j++){
   	 if (c1[j]=="r") { cont++; }
   }
   printf("%f\n",((length(c1)*8)/1000)+cont);
}
