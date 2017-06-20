# Create a simulator
puts "network.tcl is starting";
set ns [new Simulator];
set file [open "onetcp_tracefile.tr" w];
set wndfile [open "wnd_tracefile.tr" w];
$ns trace-all $file;

#generate multiple nodes
set nbNodes 6;
for {set i 0} {$i < $nbNodes} {incr i} {
    #Create network node
    set n$i [$ns node];
    #Add to a list
    lappend NodeList n$i;
};

#Specify buffer size
Queue/DropTail set limit_ 50;

#Create a symetric bidirectional links
$ns duplex-link $n0 $n2 10Mb 10ms DropTail;
$ns duplex-link $n4 $n3 10Mb 10ms DropTail;

#Create simple links
$ns simplex-link $n1 $n2 2Mb 10ms DropTail;
$ns simplex-link $n2 $n3 2Mb 10ms DropTail;
$ns simplex-link $n3 $n2 500kb 100ms DropTail;
$ns simplex-link $n3 $n5 2Mb 10ms DropTail;

#Create a new agent protocol
set tcp1 [new Agent/TCP];
$tcp1 set packetSize_ 1460;
$tcp1 set fid_ 0;
$tcp1 set window_ 1000000;
set tcpsink [new Agent/TCPSink];

#Attach a protocol to a node
$ns attach-agent $n0 $tcp1;
$ns attach-agent $n4 $tcpsink;

#connect agents
$ns connect $tcp1 $tcpsink;

#Add an application
set stp1 [new Application/FTP];
$stp1 attach-agent $tcp1

#Add a dynamic window
proc wnd {src fid trfile} {
    global ns
    puts $trfile  "[$ns now] $fid [$src set cwnd_]"
    $ns at [expr [$ns now]+0.01] "wnd $src $fid $trfile"
}

#Plannification des events
$ns at 5.0 "$stp1 start";
$ns at 5.0 "wnd $tcp1 0 $wndfile"
$ns at 80.0 "$stp1 stop";
$ns at 80.1 "$ns flush-trace";
$ns at 80.2 "close $file";
$ns at 80.29999999 "close $wndfile";
$ns at 80.3 "$ns halt";

puts "network.tcl is running";
$ns run;
puts "network.tcl is finished";