# Define options
set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model: TwoRayGround/FreeSpace
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(nn) 5 ;# number of mobilenodes
set val(rp) DumbAgent ;# routing protocol
set val(x) 1000 ;# X dimension of topography
set val(y) 1000 ;# Y dimension of topography 
set val(stop) 10 ;# time of simulation end

set ns [new Simulator]
set tracefd [open rfid.tr w]
#set windowVsTime2 [open wintr w]
set namtrace [open rfid.nam w] 

#DEFININDO POTENCIA DO SINAL PARA LIMITAR ALCANCE DO LEITOR
$val(netif) set Pt_ 0.28
$val(netif) set RXThresh_ 2.12249e-07

#DESABILITANDO RTS/CTS POR NÃO FAZER PARTE DO PROTOCOLO RFID
$val(mac) set RTSThreshold_ 3000
#DEFININDO VELOCIDADE DOS CANAIS FORWARD(leitor-tag) E BACKWARD(tag-leitor)
$val(mac) set basicRate_ 80Kb
$val(mac) set dataRate_ 80Kb

$ns use-newtrace
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

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
#-channelType $val(chan) \
-topoInstance $topo \
-agentTrace OFF \
-routerTrace OFF \
-macTrace ON \
-movementTrace OFF \
-channel $chan_1_

for {set i 0} {$i < $val(nn) } { incr i } {
	set n($i) [$ns node] 
}

# Provide initial location of mobilenodes..
$n(0) set X_ 10
$n(0) set Y_ 10
$n(0) set Z_ 0.0

#$n(1) set X_ 82
#$n(1) set Y_ 202
#$n(1) set Z_ 0.0

#$n(2) set X_ 82.04
#$n(2) set Y_ 202.05
#$n(2) set Z_ 0.0

#LOCALIZAÇÃO ALEATÓRIA DAS TAGS
set rng1 [new RNG]
$rng1 seed 0
set rng2 [new RNG]
$rng2 seed 0

for {set i 1} {$i < $val(nn) } { incr i } {
      $n($i) set X_ [$rng1 uniform 0 20]
      #puts "[$rng1 uniform 0.5 2.5]"
      $n($i) set Y_ [$rng2 uniform 0 20]
      $n($i) set Z_ 0.0
      #$ns at 0.0 "$n($i) label TAG"
}

#defining heads
$ns at 0.0 "$n(0) label LEITOR"
#$ns at 0.0 "$n(1) label TAG"
#$ns at 0.0 "$n(2) label TAG"
#$ns at 0.0 "$n(2) label TAG"

#Definindo conexão
set reader1 [new Agent/RfidReader]
for {set i 1} {$i < $val(nn) } { incr i } {
        set tag($i) [new Agent/RfidTag]
	$tag($i) set tagEPC_ $i+10
}
#set tag1 [new Agent/RfidTag]
#set tag2 [new Agent/RfidTag]

#Definindo parametros dos agentes
$reader1 set id_ 200
$reader1 set singularization_ 1
$reader1 set service_ 1

#$tag1 set tagEPC_ 11
#$tag2 set tagEPC_ 12


#$ns attach-agent $n(0) $reader1
#$ns attach-agent $n(1) $tag1
#$ns attach-agent $n(2) $tag2

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


$ns at 1.0 "$reader1 query-tags"
$ns at 1.5 "$reader1 query-tags"

# Define node initial position in nam
$ns initial_node_pos $n(0) 20
for {set i 1} {$i < $val(nn)} { incr i } {
	# 30 defines the node size for nam
	$ns initial_node_pos $n($i) 5
}

# dynamic destination setting procedure..
#$ns at 0.0 "destination"
proc destination {} {
      global ns val n
      set time 1.0
      set now [$ns now]
      for {set i 1} {$i<$val(nn)} {incr i} {
            set xx [expr rand()*1000]
            set yy [expr rand()*1000]
	    set zz [expr rand()*60]
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
global ns tracefd namtrace
#global ns tracefd
$ns flush-trace
close $tracefd
#close $namtrace
#exec nam rfid.nam &
}
$ns run
