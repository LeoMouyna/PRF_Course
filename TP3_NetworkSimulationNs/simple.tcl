# Create a simulator
set ns [new Simulator];

#generate multiple nodes
set nbNodes 2;
for {set i 0} {$i < $nbNodes} {incr i} {
    #Create network node
    set n$i [$ns node];
    #Add to a list
    lappend NodeList n$i;
};

#Create a symetric bidirectional link
$ns duplex-link $n0 $n1 2Mb 10ms DropTail;

#Create a new agent protocol
set udp [new Agent/UDP];
set sink [new Agent/Null];

#Attach a protocol to a node
$ns attach-agent $n0 $udp;
$ns attach-agent $n1 $sink;

#connect agents
$ns connect $udp $sink;

#Add an application
set cbr [new Application/Traffic/CBR];
$cbr attach-agent $udp;
#Démarage décalé de 10s
$ns at 10.0 "$cbr start";

