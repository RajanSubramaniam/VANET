

set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             12                          ;# number of mobilenodes
set val(rp)             DSDV                       ;# routing protocol


set ns_		[new Simulator]
set tracefd     [open simple.tr w]
set namtrace    [open simple.nam w]
$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace 1000 1000

#set up topography object
set topo       [new Topography]

$topo load_flatgrid 1000 1000

#
# Create God
#
create-god $val(nn)

#
#  Create the specified number of mobilenodes [$val(nn)] and "attach" them
#  to the channel. 
#  Here two nodes are created : node(0) and node(1)

# configure node

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
			 -routerTrace ON \
			 -macTrace OFF \
			 -movementTrace OFF			
			 
	for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 0		;# disable random motion
	}

#
# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
#
#$node_(0) set X_ 5.0
#$node_(0) set Y_ 2.0
#$node_(0) set Z_ 0.0

#$node_(1) set X_ 390.0
#$node_(1) set Y_ 385.0
#$node_(1) set Z_ 0.0

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
$node_(5) set Z_ 0.0


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


$ns_ at 5.0 "$node_(0)   setdest 80.0 310.0 24.0"
$ns_ at 10.0 "$node_(1)  setdest 180.0 360.0 23.0"
$ns_ at 15.0 "$node_(2)  setdest 280.0 130.0 22.0"
$ns_ at 20.0 "$node_(3)  setdest 290.0 460.0 21.0"
$ns_ at 25.0 "$node_(4)  setdest 270.0 610.0 20.0"
$ns_ at 30.0 "$node_(5)  setdest 310.0 740.0 25.0"
$ns_ at 35.0 "$node_(6)  setdest 260.0 930.0 25.0"
$ns_ at 40.0 "$node_(7)  setdest 380.0 430.0 24.0"
$ns_ at 45.0 "$node_(8)  setdest 360.0 619.0 23.0"
$ns_ at 50.0 "$node_(9)  setdest 600.0 460.0 22.0"
$ns_ at 55.0 "$node_(10) setdest 680.0 660.0 25.0"
$ns_ at 60.0 "$node_(11) setdest 790.0 430.0 25.0"

#
# Now produce some simple node movements
# Node_(1) starts to move towards node_(0)
#
#$ns_ at 50.0 "$node_(1) setdest 25.0 20.0 15.0"
#$ns_ at 10.0 "$node_(0) setdest 20.0 18.0 1.0"

# Node_(1) then starts to move away from node_(0)
#$ns_ at 100.0 "$node_(1) setdest 490.0 480.0 15.0" 

# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(1)

set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(4) $tcp
$ns_ attach-agent $node_(11) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 10.0 "$ftp start" 


for {set i 0} {$i < $val(nn)} {incr i}  {

$ns_ initial_node_pos $node_($i) 30
    
}

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 150.0 "$node_($i) reset";
}
$ns_ at 150.0 "stop"
$ns_ at 150.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
    
}

puts "Starting Simulation..."
$ns_ run

