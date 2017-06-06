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
