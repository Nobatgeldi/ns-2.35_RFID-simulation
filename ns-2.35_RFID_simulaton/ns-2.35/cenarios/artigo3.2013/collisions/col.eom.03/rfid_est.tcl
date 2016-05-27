# Define option
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
#set val(rp) DSDV ;# routing protocol
set val(x) 30 ;# X dimension of topography
set val(y) 30 ;# Y dimension of topography 
set val(stop) 60 ;# time of simulation end

set ns [new Simulator]
set tracefd [open [lindex $argv 0] w]
#set namtrace [open rfid.nam w] 

#DEFININDO POTENCIA DO SINAL PARA LIMITAR ALCANCE DO LEITOR
$val(netif) set Pt_ 0.28
$val(netif) set RXThresh_ 7.64097e-06

$ns use-newtrace
$ns trace-all $tracefd
#$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo [new Topography]

$topo load_flatgrid $val(x) $val(y)

#create-god $val(nn)
create-god [expr $val(nn)]

set chan_1_ [new $val(chan)]

# configure the nodes
$ns node-config -adhocRouting $val(rp) \
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
#-channel $chan_1_

for {set i 0} {$i < $val(nn) } { incr i } {
	set n($i) [$ns node] 
}

# Provide initial location of mobilenodes..
$n(0) set X_ 10
$n(0) set Y_ 10
$n(0) set Z_ 0.0

#LOCALIZAÇÃO ALEATÓRIA DAS TAGS
set rng1 [new RNG]
$rng1 seed 0
set rng2 [new RNG]
$rng2 seed 0

set rng3 [new RNG]
$rng3 seed 0

#puts "[$rng2 uniform 0 20]"
#puts "[$rng3 uniform 10 1000]"
for {set i 1} {$i < $val(nn) } { incr i } {
      $n($i) set X_ [$rng1 uniform 8 12]
      $n($i) set Y_ [$rng2 uniform 8 12]
      #puts "[$rng2 uniform 0 20]"
      $n($i) set Z_ 0.0
}

#defining heads
$ns at 0.0 "$n(0) label LEITOR"
#$ns at 0.0 "$n(1) label TAG"

#Definindo conexão
set reader1 [new Agent/RfidReader]
for {set i 1} {$i < $val(nn) } { incr i } {
        set tag($i) [new Agent/RfidTag]
	$tag($i) set tagEPC_ [expr $i*10]
	$tag($i) set time_ 1
	$tag($i) set messages_ 0
	$tag($i) set seed_ [$rng2 uniform 10 1000]
}

#Definindo parametros dos agentes
$reader1 set id_ 200
$reader1 set singularization_ 0
$reader1 set service_ 4
$reader1 set t2_ 0.09
$reader1 set c_ 1
$reader1 set qValue_ 3
$reader1 set Qfp_ 3.0
$reader1 set estConstant_ 3
$reader1 set messages_ 0
$reader1 set estMethod_ 2
$reader1 set iL_ 3

#CONECTANDO NOS AOS AGENTES
for {set i 1} {$i < $val(nn) } { incr i } {
        $ns attach-agent $n($i) $tag($i)
}
$ns attach-agent $n(0) $reader1

#conectando nos
#$ns connect $reader1 $tag1
#$ns connect $reader1 $tag2

for {set i 1} {$i < $val(nn) } { incr i } {
        $ns connect $reader1 $tag($i)
}

for {set i 0} {$i < $val(stop) } { incr i 101} {
        #$ns at $i "$reader1 standard-query-tags"
	$ns at $i "$reader1 edfsa-query"
}

#$ns at 1.0 "$reader1 query-tags"

# Define node initial position in nam
$ns initial_node_pos $n(0) 20
for {set i 1} {$i < $val(nn)} { incr i } {
	# 30 defines the node size for nam
	$ns initial_node_pos $n($i) 5
}

# dynamic destination setting procedure..
#$ns at 0.0 "destination"
#$ns at 600.0 "destination"
#$ns at 1200.0 "destination"
#$ns at 1800.0 "destination"
#$ns at 2100.0 "destination"
#$ns at 2400.0 "destination"
#$ns at 2700.0 "destination"
#for {set i 1} {$i < $val(stop) } { incr i 10} {
#        $ns at $i "destination"
#}

proc destination {} {
      set rng1 [new RNG]
      $rng1 seed 0
      global ns val n
      set time 1.0
      set now [$ns now]
      for {set i 1} {$i<$val(nn)} {incr i} {
            set rand1 [$rng1 uniform 0 20]
	    set rand2 [$rng1 uniform 0 20]
            set xx [$rng1 uniform 0 $rand1]
            set yy [$rng1 uniform 0 $rand2]
	    set zz [$rng1 uniform 0 2]
            $ns at $now "$n($i) setdest $xx $yy $zz"
      }
      $ns at [expr $now+$time] "destination"
}

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
$ns at $val(stop) "$n($i) reset";
}

# ending nam and the simulation 
#$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at $val(stop) "puts \"end simulation\" ; $ns halt"

proc stop {} {
#global ns tracefd namtrace
global ns tracefd
$ns flush-trace
close $tracefd
#close $namtrace
#exec nam rfid.nam &
}
$ns run
