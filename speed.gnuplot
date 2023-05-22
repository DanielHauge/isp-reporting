set title 'Bandwidth report'                   
set xlabel 'Time'                            
set ylabel 'Mpbs'

set datafile separator ','
set timefmt '%Y-%m-%d %H:%M:%S'
set format x '%Y-%m-%d %H:%M:%S'
set xtics rotate by 25 right
set ytics 100
set grid y
set xdata time
set xrange [from:to]
set xtics timeTicks

set yrange [0 to 1000]
set terminal svg size 1280,720
set output out



plot file using 2:($8/125000) with lines title "Download",\
     '' using 2:($9/125000) with lines title "Upload"