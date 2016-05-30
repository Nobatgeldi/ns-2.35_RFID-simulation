BEGIN{
i=0;
b=0;
k=0;
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
   #for(j=1; j in c1;j++){
   #	 printf("%d\n",c2[j]);
   #}
    for(a=1; a in c2;a++) 
      {
        b++;
      }
    for (j=1; j in c1; j++) 
      {
        k++;
      }
   printf("Number of identified tags: %d during %.9f seconds \n", j, c3[b-1]);
}