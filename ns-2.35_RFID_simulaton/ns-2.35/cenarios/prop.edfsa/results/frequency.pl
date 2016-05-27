#use strict;
use Statistics::PointEstimation;
	
	my @r=();
	open(MYFILE,"collisions.col") || die "Cannot open file \"$ARGV[0]\"";
	while($line = <MYFILE>)
	{
     		push @r,$line;
	}
	close(MYFILE);
	my $total = 0;
	my $stat = new Statistics::PointEstimation;
	#$stat->add_data(1,2,2,2,2,2,2,3,3,3,4,4,5,5,6,7,8);
	$stat->add_data(@r);
	%f = $stat->frequency_distribution(6);
	for (sort {$a <=> $b} keys %f) {
		#print "key = $_, count = $f{$_}\n";
		print "$_ $f{$_}\n";
		$total = $total + $f{$_};
	}
	print "$total\n";
