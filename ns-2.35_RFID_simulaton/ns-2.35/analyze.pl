#!/usr/bin/perl
$tracefile=$ARGV[0];
$granularity=$ARGV[1];

$ofile="simulation_result.csv";
open OUT, ">$ofile" or die "$0 cannot open output file $ofile: $!";

open (DR,STDIN);
$gclock=0;

#Data Packet Information
$dataSent = 0;
$dataRecv = 0;
$routerDrop = 0;

#AODV Packet Information
$aodvSent = 0;
$aodvRecv = 0;

$aodvSentRequest = 0;
$aodvRecvRequest = 0;
$aodvDropRequest = 0;

$aodvSentReply = 0;
$aodvRecvReply = 0;
$aodvDropReply = 0;

if ($granularity==0) {$granularity=30;}

while(<>){
	chomp;
	if (/^s/){
		if (/^s.*AODV/) {
			$aodvSent++;
			if (/^s.*REQUEST/) {
				$aodvSendRequest++;
			}
			elsif (/^s.*REPLY/) {
				$aodvSendReply++;
			}
		}
		elsif (/^s.*AGT/) {
			$dataSent++;			
		}		
		
	} elsif (/^r/){
		if (/^r.*AODV/) {
			$aodvRecv++;
			if (/^r.*REQUEST/) {
				$aodvRecvRequest++;
			}
			elsif (/^r.*REPLY/) {
				$aodvRecvReply++;
			}
			
		}
		elsif (/^r.*AGT/) {
			$dataRecv++;			
		}
		
	} elsif (/^D/) {
		if (/^D.*AODV/) {
			if (/^D.*REQUEST/) {
				$aodvDropRequest++;
			}
			elsif (/^D.*REPLY/) {
				$aodvDropReply++;
			}
			
		}
		if (/^D.*RTR/) {
			$routerDrop++;
		}
	}
	 
}

close DR;

$delivery_ratio = 100*$dataRecv/$dataSent;

print "AODV Sent		: $aodvSent\n";
print "AODV Recv		: $aodvRecv\n";
print "Data Sent		: $dataSent\n";
print "Data Recv		: $dataRecv\n";
print "Router Drop		: $routerDrop\n";
print "Delivery Ratio		: $delivery_ratio \n";

print OUT "Messages Sent,$dataSent\n";
print OUT "Messages Recieved,$dataRecv\n";
print OUT "Messages Dropped,$routerDrop\n";
print OUT "Delivery Rate,$delivery_ratio\n";

close OUT;

