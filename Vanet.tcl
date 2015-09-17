

set val(chan)   	Channel/Wirelesschannel 	;#channel type
set val(prop) 		Propagation/TwoRayGround	;#radio-propagation
set val(netif) 		Phy/WirelessPhy         	;#network interface type
set val(mac)   		Mac/802_11              	;#Mac type
set val(ifq)   		Queue/DropTail/PriQueue 	;#interface queue type
set val(ll)     	LL                       	;#link layer type
set val(ant)   		Antenna/OmniAntenna     	;#antenna model
set val(ifqlen) 	50                      	;#max packet in ifq
set val(nn)    		12                      	;#number of mobilenodes
set val(rp)    		DSDV	                 	;#routing protocol
set val(x)      	1000                     	;#X dimension of topography
set val(y)      	1000                     	;#Y dimension of topography
set val(stop)   	150                     	;# time of simulation


set nv    [new Simulator]
set tracefd      [open vanet.tr w]
#set windowVsTime2 [open win.tr w]
set namtrace        [open vanet.nam w]

$nv trace-all $tracefd
$nv namtrace-all-wireless $namtrace $val(x) $val(y)
 
set topo   [new Topography]

$topo load_flatgrid $val(x) $val(y)


create-god $val(nn)

$nv node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqlen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -channelType $val(chan) \
                -topoInstance $topo \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF

for {set i 0} {$i < $val(nn) } {incr i} {
    set node_($i) [$nv node]	
    $node_($i) random-motion 0		
}

$node_(0) set X_ 100.0
$node_(0) set Y_ 320.0
$node_(0) set z_ 0.0


$node_(1) set X_ 200.0
$node_(1) set Y_ 350.0
$node_(1) set z_ 0.0


$node_(2) set X_ 300.0
$node_(2) set Y_ 150.0
$node_(2) set Z_ 0.0


$node_(3) set X_ 340.0
$node_(3) set Y_ 480.0
$node_(3) set Z_ 0.0


$node_(4) set X_ 320.0
$node_(4) set Y_ 630.0
$node_(4) set Z_ 0.0



$node_(5) set X_ 380.0
$node_(5) set Y_ 750.0
$node_(5) set Z_0.0


$node_(6) set X_ 330.0
$node_(6) set Y_ 900.0
$node_(6) set Z_ 0.0


$node_(7) set X_ 410.0
$node_(7) set Y_ 400.0
$node_(7) set Z_ 0.0


$node_(8) set X_ 380.0
$node_(8) set Y_ 630.0
$node_(8) set Z_ 0.0



$node_(9) set X_ 640.0
$node_(9) set Y_ 490.0
$node_(9) set Z_ 0.0


$node_(10) set X_ 700.0
$node_(10) set Y_ 700.0
$node_(10) set Z_ 0.0


$node_(11) set X_ 820.0
$node_(11) set Y_ 450.0
$node_(11) set Z_ 0.0


$nv_ at 5.0 "$node_(0) setdest 80.0 310.0 24.0"
$nv_ at 10.0 "$node_(1) setdest 180.0 360.0 23.0"
$nv_ at 15.0 "$node_(2) setdest 280.0 130.0 22.0"
$nv_ at 20.0 "$node_(3) setdest 290.0 460.0 21.0"
$nv_ at 25.0 "$node_(4) setdest 270.0 610.0 20.0"
$nv_ at 30.0 "$node_(5) setdest 310.0 740.0 25.0"
$nv_ at 35.0 "$node_(6) setdest 260.0 930.0 25.0"
$nv_ at 40.0 "$node_(7) setdest 380.0 430.0 24.0"
$nv_ at 45.0 "$node_(8) setdest 360.0 619.0 23.0"
$nv_ at 50.0 "$node_(9) setdest 600.0 460.0 22.0"
$nv_ at 55.0 "$node_(10)setdest 680.0 660.0 25.0"
$nv_ at 60.0 "$node_(11)setdest 790.0 430.0 25.0"


set tcp [new Agent/Tcp]
$tcp set class_ 2
set sink [new Agent/TCPsink]
$nv attach-agent $node_(4) $tcp
$nv attach-agent $node_(11) $sink
$nv connect $tcp $sink
set ftp [new Application/Traffic/FTP]
$ftp attach-agent $tcp
$nv at 5.0 "$ftp start"

#proc plotWindow {tcpSource file} {
#global nv
#set time 0.01
#set now [$ns now]
#set cwnd [$tcpSource set cwnd_]
#puts $file "$now $cwnd"
#$nv at [expr $now+$time] "plotWindow $tcpSource $file" }
#$nv at 10.1 "plotWindow $tcp $windowVstime2"    
    

for {set i 0} {$i < $val(nn)} {incr i}  {

$nv initial_node_pos $node_($i) 30
    
}

for {set i 0} {$i < $val(nn) } {incr i} {
    $nv at $val(stop) "$node_($i) reset";
}

proc stop {} {

    global nv tracefd namtrace
    $nv flush-trace
    close $tracefd
    close $namtrace
    
}

$nv run






 






