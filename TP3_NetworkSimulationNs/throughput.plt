# set the terminal, i.e., the figure format (eps) and font (Helvetica, 20pt)
set term postscript eps enhanced "Helvetica" 20 

# reset all options to default, just for precaution
reset

# set the figure size
set size 0.7,0.7

# set the figure name
set output "throughput.eps"

# set the x axis
set xrange [10:30]
set xlabel "Simulation time (s)"
set xtics
set mxtics 2

# set the y axis
set yrange [0:2200]
set ylabel "Throughput"
set ytics
set mytics 2

# set the legend (boxed, on the left)
set key box left height 0.5

# set the grid (grid lines start from tics on both x and y axis)
set grid xtics ytics


# plot the data from the log file along with the theoretical curve
plot "< awk '$2 == 1 {print}' trace.log" u 1:4 t "cdr 1" w l  lc rgb "#AAAAAA",\
 "< awk '$2 == 2 {print}' trace.log" u 1:4 t "cdr 2" w l  lc rgb "#FFFFFF",