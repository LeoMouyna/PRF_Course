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
set udp1 [new Agent/UDP];
$udp1 set fid_ 1;
set udp2 [new Agent/UDP];
$udp2 set fid_ 2;
set sink [new Agent/Null];

#Attach a protocol to a node
$ns attach-agent $n0 $udp1;
$ns attach-agent $n0 $udp2;
$ns attach-agent $n1 $sink;

#connect agents
$ns connect $udp1 $sink;
$ns connect $udp2 $sink;

#Add an application
set cbr1 [new Application/Traffic/CBR];
$cbr1 attach-agent $udp1;
set cbr2 [new Application/Traffic/CBR];
$cbr2 set rate_ 1.8Mb;
$cbr2 set packetSize_ 450;
$cbr2 set maxpkts_ 5000;
$cbr2 attach-agent $udp2;

#Plannification des events
$ns at 10.0 "$cbr1 start";
$ns at 15.0 "$cbr2 start";
$ns at 30.0 "$cbr1 stop";
$ns at 30.0 "$cbr2 stop";
$ns at 30.1 "$ns flush-trace";
$ns at 30.2 "close $file";
$ns at 30.3 "$ns halt";

puts "simple.tcl is running";
$ns run;
puts "simple.tcl is finished";