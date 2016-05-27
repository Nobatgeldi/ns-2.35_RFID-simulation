# DEFINIÇÃO DE OPÇÕES WIRELESS. Fonte: Manual ns-2 em
#http://www.isi.edu/nsnam/ns/doc/index.html
if {$argc!=3} {
        #set tracefd [open cenario3a.csv w]
        puts "Erro! Indique o nome do arquivo e a quantidade de nós"
        exit
}
set val(chan) Channel/WirelessChannel ;# tipo de canal
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# modelo de antena
set val(ifqlen) 55 ;# max packet in ifq
set val(nn) [lindex $argv 1] ;# número de nós
set val(rp) DumbAgent ;# protocolo de roteamento (não existe roteamento)
set val(x) 1000 ;# X dimension of topography (metros)
set val(y) 1000 ;# Y dimension of topography (metros)
set val(stop) 1800 ;# time of simulation end (segundos) - 30 minutos

#PREPARANDO O SIMULADOR E OS TRACES
set ns [new Simulator]
set tracefd [open [lindex $argv 0] w]
#set windowVsTime2 [open cenario2a_wintr w]
#set namtrace [open cenario2.nam w] 

#DEFININDO POTENCIA DO SINAL PARA LIMITAR ALCANCE DO LEITOR
$val(netif) set Pt_ 0.28
$val(netif) set RXThresh_ 2.12249e-07

#DESABILITANDO RTS/CTS POR NÃO FAZER PARTE DO PROTOCOLO RFID
$val(mac) set RTSThreshold_ 3000
#DEFININDO VELOCIDADE DOS CANAIS FORWARD(leitor-tag) E BACKWARD(tag-leitor)
$val(mac) set basicRate_ 9Kb
$val(mac) set dataRate_ 128Kb

#DEFININDO TRACES
$ns use-newtrace
$ns trace-all $tracefd
#$ns namtrace-all-wireless $namtrace $val(x) $val(y)

#DEFININDO TOPOLOGIA 20x20: Sala de aula
set topo [new Topography]

$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

set chan_1_ [new $val(chan)]

# CONFIGURANDO OS NÓS
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
-agentTrace OFF \
-routerTrace OFF \
-macTrace ON \
-movementTrace OFF

for {set i 0} {$i < $val(nn) } { incr i } {
	set n($i) [$ns node] 
}

# LOCALIZAÇÃO INICIAL DOS LEITORES
$n(0) set X_ 2
$n(0) set Y_ 2
$n(0) set Z_ 0.0

$n(1) set X_ 45
$n(1) set Y_ 45
$n(1) set Z_ 0.0

$n(2) set X_ 85
$n(2) set Y_ 90
$n(2) set Z_ 0.0

$n(3) set X_ 110
$n(3) set Y_ 150
$n(3) set Z_ 0.0

$n(4) set X_ 175
$n(4) set Y_ 150
$n(4) set Z_ 0.0



#LOCALIZAÇÃO ALEATÓRIA DAS TAGS
set rng1 [new RNG]
$rng1 seed 0
set rng2 [new RNG]
$rng2 seed 0

for {set i 5} {$i < $val(nn) } { incr i } {
      $n($i) set X_ [$rng1 uniform 0 200]
      $n($i) set Y_ [$rng2 uniform 0 200]
      $n($i) set Z_ 0.0
      #$ns at 0.0 "$n($i) label TAG"
}

#DEFININDO LABELS

$ns at 0.0 "$n(0) label LEITOR1"
$ns at 0.0 "$n(1) label LEITOR2"
$ns at 0.0 "$n(2) label LEITOR3"
$ns at 0.0 "$n(3) label LEITOR4"
$ns at 0.0 "$n(4) label LEITOR5"

#Definindo conexão
set reader1 [new Agent/RfidReader]
set reader2 [new Agent/RfidReader]
set reader3 [new Agent/RfidReader]
set reader4 [new Agent/RfidReader]
set reader5 [new Agent/RfidReader]

for {set i 5} {$i < $val(nn) } { incr i } {
        set tag($i) [new Agent/RfidTag]
}


#DEFININDO IDENTIFICADORES DOS AGENTES
$reader1 set id_ 200
$reader1 set singularization_ 1
$reader2 set id_ 210
$reader2 set singularization_ 1
$reader3 set id_ 220
$reader3 set singularization_ 1
$reader4 set id_ 230
$reader4 set singularization_ 1
$reader5 set id_ 240
$reader5 set singularization_ 1
$reader1 set service_ [lindex $argv 2]
$reader2 set service_ [lindex $argv 2]
$reader3 set service_ [lindex $argv 2]
$reader4 set service_ [lindex $argv 2]
$reader5 set service_ [lindex $argv 2]

for {set i 5} {$i < $val(nn) } { incr i } {
        $tag($i) set tagEPC_ $i+10
}

#CONECTANDO NOS AOS AGENTES
for {set i 5} {$i < $val(nn) } { incr i } {
        $ns attach-agent $n($i) $tag($i)
}
$ns attach-agent $n(0) $reader1
$ns attach-agent $n(1) $reader2
$ns attach-agent $n(2) $reader3
$ns attach-agent $n(3) $reader4
$ns attach-agent $n(4) $reader5

#conectando nos

for {set i 5} {$i < $val(nn) } { incr i } {
        $ns connect $reader1 $tag($i)
	$ns connect $reader2 $tag($i)
	$ns connect $reader3 $tag($i)
	$ns connect $reader4 $tag($i)
	$ns connect $reader5 $tag($i)
}

#CONSULTANDO TAGS A CADA SEGUNDO
for {set i 1} {$i < $val(stop) } {incr i 10} {
	$ns at $i "$reader1 query-tags"
	$ns at $i "$reader2 query-tags"
	$ns at $i "$reader3 query-tags"
	$ns at $i "$reader4 query-tags"
	$ns at $i "$reader5 query-tags"
}

#DEFININDO TAMANHO DOS NOS PARA O NAM
$ns initial_node_pos $n(0) 40
$ns initial_node_pos $n(1) 40
$ns initial_node_pos $n(2) 40
$ns initial_node_pos $n(3) 40
$ns initial_node_pos $n(4) 40

for {set i 5} {$i < $val(nn)} { incr i } {
	$ns initial_node_pos $n($i) 10
}

#DEFININDO MOVIMENTAÇÃO DOS NÓS (ALEATÓRIA)
$ns at 0.0 "destination"
proc destination {} {
      global ns val n
      set time 1.0
      set rng3 [new RNG]
      $rng3 seed 0
      set rng4 [new RNG]
      $rng4 seed 0
      set rng5 [new RNG]
      $rng5 seed 0
      set now [$ns now]
      for {set i 5} {$i<$val(nn)} {incr i} {
            set xx [$rng3 uniform 0 200]
            set yy [$rng4 uniform 0 200]
	    set zz [$rng5 uniform 0 1.5]
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
global ns tracefd
$ns flush-trace
close $tracefd
#close $namtrace
#exec nam cenario2.nam &
}
$ns run
