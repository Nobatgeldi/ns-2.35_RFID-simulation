#use strict;
use Statistics::PointEstimation;
	
	my @r=();
	open(MYFILE,"collisions.sorted.col") || die "Cannot open file \"$ARGV[0]\"";
	while($line = <MYFILE>)
	{
     		push @r,$line;
	}
	close(MYFILE);
	my $total = 0;
	my $stat = new Statistics::PointEstimation;
	#$stat->add_data(1,2,2,2,2,2,2,3,3,3,4,4,5,5,6,7,8);
	$stat->add_data(@r);
	%f = $stat->frequency_distribution(11);
	for (sort {$a <=> $b} keys %f) {
		#print "key = $_, count = $f{$_}\n";
		#print "$_ $f{$_}\n";
		$total = $total + $f{$_};
	}
	for (sort {$a <=> $b} keys %f) {
                #print "key = $_, count = $f{$_}\n";
                $percentual =($f{$_}/$total)*100;
		printf "%d %.4f %d\n",$_,$percentual,$f{$_};
                #$total = $total + $f{$_};
        }
	
