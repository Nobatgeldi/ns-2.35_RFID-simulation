#use strict;
use Statistics::PointEstimation;

opendir(DIR,$ARGV[0]);
#opendir(DIR, ".");
@files = grep(/\.slots$/,readdir(DIR));
closedir(DIR);

for(my $i= 0; $i < @files; $i++) {
	$ponto = index(@files[$i],".");
	$numero = substr(@files[$i],0,$ponto);
	$numero = $numero -1;
	my @r=();
	open(MYFILE,$files[$i]) || die "Cannot open file \"$ARGV[0]\"";
	while($line = <MYFILE>)
	{
    		#print "${line}";
     		push @r,$line;
	}
	close(MYFILE);
	my $stat = new Statistics::PointEstimation;
	$stat->set_significance(95);
	$stat->add_data(@r);
	#print $numero," ",$stat->mean()," ",$stat->lower_clm()," ",$stat->upper_clm()," ",$stat->standard_deviation(),"\n";
	printf "$numero %.0f %.0f %.0f %.2f\n", $stat->mean(), $stat->lower_clm(), $stat->upper_clm(), $stat->standard_deviation();
}
