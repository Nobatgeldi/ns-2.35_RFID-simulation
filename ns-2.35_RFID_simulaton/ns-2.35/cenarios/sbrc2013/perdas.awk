#ENTRADA: (Id=0)||(Id=1)||(Id=2)
BEGIN{
i=0;
d=0;
r=0;
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
   	 if (c1[j]=="d") { d++; }
	 if (c1[j]=="r") { r++; }
   }
   if ((r+d)>0) {
   	printf("%f\n",d/(r+d)); 
   }
   else {
	printf("%f\n",0);
   }
}
