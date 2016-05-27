BEGIN{
i=0;
d=0;
r=0;
s=0;
media=0;
}

{
   action=$1;
   cl1=$3;
   #cl2=$5;
   if( (action=="d")|| (action=="s")|| (action=="r") ){
   	c1[i]=action;
	c2[i]=cl1;
   	i++;
   }
}

END {
   #printf("%d\n",length(c1));
   for(j=0;j<length(c1);j++){
	 if ((c1[j]=="s")){
		if ((d+r)!=0) {
			media = media + (d/((d+r)));
		}
		s++;
		r=0;
		d=0;
	 }
	 if(c1[j]=="r") {
		r++;
	 }
	 if (c1[j]=="d") {
	 	d++;
	 }
   }
   if (s!=0) {
	   printf("%f\n",media/s);
   }
   if (s==0) {
	   printf("%f\n",media);
   }
}
