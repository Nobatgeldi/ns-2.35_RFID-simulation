# Define options
#if {$argc!=1} {
#        puts "Error! Number of nodes missing!"
#        exit
#}
set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model: TwoRayGround/FreeSpace
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 1000 ;# max packet in ifq
set val(nn) [lindex $argv 1] ;# number of mobilenodes
set val(rp) DumbAgent ;# routing protocol
set val(x) 30 ;# X dimension of topography
set val(y) 15 ;# Y dimension of topography 
set val(stop) 1800 ;# time of simulation end
set val(scen) [lindex $argv 2]
set ns_ [new Simulator]
set tracefd [open [lindex $argv 0] w]
set namtrace [open rfid.nam w] 

#Transmission power (range: 5m)
$val(netif) set Pt_ 0.28
$val(netif) set RXThresh_ 7.64097e-06

$ns_ use-newtrace
$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo [new Topography]

$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]
set chan_1_ [new $val(chan)]

# configure the nodes
$ns_ node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace OFF \
-macTrace OFF \
-movementTrace OFF

set nreaders 3

#Creating nodes
for {set i 0} {$i < $val(nn) } { incr i } {
	set node_($i) [$ns_ node] 
}

#Loading nodes movements
source $val(scen)

# Provide initial location of RFID reader
$node_([expr $val(nn)-$nreaders]) set X_ 5
$node_([expr $val(nn)-$nreaders]) set Y_ 5
$node_([expr $val(nn)-$nreaders]) set Z_ 0.0

$node_([expr $val(nn)-$nreaders+1]) set X_ 16
$node_([expr $val(nn)-$nreaders+1]) set Y_ 5
$node_([expr $val(nn)-$nreaders+1]) set Z_ 0.0

$node_([expr $val(nn)-$nreaders+2]) set X_ 27
$node_([expr $val(nn)-$nreaders+2]) set Y_ 5
$node_([expr $val(nn)-$nreaders+2]) set Z_ 0.0

#LOCALIZAÇÃO ALEATÓRIA DAS TAGS
#set rng1 [new RNG]
#$rng1 seed 0
#set rng2 [new RNG]
#$rng2 seed 0

#set rng3 [new RNG]
#$rng3 seed 0

#puts "[$rng2 uniform 0 20]"
#puts "[$rng3 uniform 10 1000]"
#for {set i 1} {$i < $val(nn) } { incr i } {
#      $n($i) set X_ [$rng1 uniform 0 100]
#      $n($i) set Y_ [$rng2 uniform 0 100]
      #puts "[$rng2 uniform 0 20]"
#      $n($i) set Z_ 0.0
#}

#Setting readers ID and number of readers
set n1 [expr $val(nn)-$nreaders]
set n2 [expr $val(nn)-$nreaders+1]
set n3 [expr $val(nn)-$nreaders+2]

#defining nam heads
$ns_ at 0.0 "$node_($n1) label READER1"
$ns_ at 0.0 "$node_($n2) label READER2"
$ns_ at 0.0 "$node_($n3) label READER3"


#Setting conections
set reader1 [new Agent/RfidReader]
set reader2 [new Agent/RfidReader]
set reader3 [new Agent/RfidReader]
for {set i 0} {$i < [ expr $val(nn)-$nreaders] } { incr i } {
        set tag($i) [new Agent/RfidTag]
	$tag($i) set tagEPC_ [expr $i*10]
	$tag($i) set time_ 1
	$tag($i) set messages_ 0
	#$tag($i) set seed_ [$rng2 uniform 10 100]
}

#Setting reader parameters
$reader1 set id_ 8000
$reader1 set singularization_ 0
$reader1 set service_ 2
$reader1 set t2_ 0.001
$reader1 set c_ 0.3
$reader1 set messages_ 0

$reader2 set id_ 8001
$reader2 set singularization_ 0
$reader2 set service_ 2
$reader2 set t2_ 0.001
$reader2 set c_ 0.3
$reader2 set messages_ 0

$reader3 set id_ 8002
$reader3 set singularization_ 0
$reader3 set service_ 2
$reader3 set t2_ 0.001
$reader3 set c_ 0.3
$reader3 set messages_ 0

#Connecting agents to nodes
for {set i 0} {$i < [expr $val(nn)-$nreaders] } { incr i } {
        $ns_ attach-agent $node_($i) $tag($i)
}
$ns_ attach-agent $node_([expr $val(nn)-$nreaders]) $reader1
$ns_ attach-agent $node_([expr $val(nn)-$nreaders+1]) $reader2
$ns_ attach-agent $node_([expr $val(nn)-$nreaders+2]) $reader3

#Conecting readers to tags
for {set i 0} {$i < [expr $val(nn)-$nreaders] } { incr i } {
        $ns_ connect $reader1 $tag($i)
	$ns_ connect $reader2 $tag($i)
	$ns_ connect $reader3 $tag($i)

}

#Schedulling events

for {set i 0} {$i < $val(stop) } { incr i 60} {
        $ns_ at $i "$reader1 standard-query-tags"
}

for {set i 30} {$i < $val(stop) } { incr i 60} {
        $ns_ at $i "$reader2 standard-query-tags"
}

for {set i 60} {$i < $val(stop) } { incr i 60} {
       $ns_ at $i "$reader3 standard-query-tags"
}


# Define node initial position in nam
$ns_ initial_node_pos $node_([expr $val(nn)-$nreaders]) 11
$ns_ initial_node_pos $node_([expr $val(nn)-$nreaders+1]) 11
$ns_ initial_node_pos $node_([expr $val(nn)-$nreaders+2]) 11

for {set i 0} {$i < [expr $val(nn)-$nreaders]} { incr i } {
	# 30 defines the node size for nam
	$ns_ initial_node_pos $node_($i) 1
}

# dynamic destination setting procedure..
#$ns at 0.0 "destination"
#$ns at 600.0 "destination"
#$ns at 1200.0 "destination"
#$ns at 1800.0 "destination"
#$ns at 2100.0 "destination"
#$ns at 2400.0 "destination"
#$ns at 2700.0 "destination"
#for {set i 1} {$i < $val(stop) } { incr i 600} {
#        $ns at $i "destination"
#}

#proc destination {} {
#      set rng1 [new RNG]
#      $rng1 seed 0
#      global ns val n
#      set time 1.0
#      set now [$ns_ now]
#      for {set i 1} {$i<$val(nn)} {incr i} {
#            set rand1 [$rng1 uniform 0 30]
#	    set rand2 [$rng1 uniform 0 30]
#            set xx [$rng1 uniform 0 100]
#            set yy [$rng1 uniform 0 100]
#	    set zz [$rng1 uniform 0 0]
#            $ns_ at $now "$n($i) setdest $xx $yy $zz"
#      }
#      $ns_ at [expr $now+$time] "destination"
#}

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
$ns_ at $val(stop) "$node_($i) reset";
}

# ending nam and the simulation 
#$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns_ at $val(stop) "stop"
$ns_ at $val(stop) "puts \"end simulation\" ; $ns_ halt"

proc stop {} {
global ns_ tracefd namtrace
#global ns tracefd
$ns_ flush-trace
close $tracefd
close $namtrace
#exec nam rfid.nam &
}
$ns_ run
