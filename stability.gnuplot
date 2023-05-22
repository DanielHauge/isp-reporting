set title 'Stability report'                   
set xlabel 'Time'                            
set ylabel 'Ms'

set datafile separator ','
set timefmt '%Y-%m-%d %H:%M:%S'
set format x '%Y-%m-%d %H:%M:%S'
set xtics rotate by 25 right
set grid y
set xdata time
set xrange [from:to]
set xtics timeTicks

set terminal svg size 1280,720
set output out


plot file using 2:14 with lines title 'Download latency',\
    '' using 2:18 with lines title 'Upload latency',\
    '' using 2:5 with lines title 'Idle latency',\
