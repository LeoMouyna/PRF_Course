# Create a simulator
puts "simple.tcl is starting";
set ns [new Simulator];
set file [open "trace.tr" w];
$ns trace-all $file;

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

#Plannification des events
$ns at 10.0 "$cbr start";
$ns at 30.0 "$cbr stop";
$ns at 30.1 "$ns flush-trace";
$ns at 30.2 "close $file";
$ns at 30.3 "$ns halt";

puts "simple.tcl is running";
$ns run;
puts "simple.tcl is finished";