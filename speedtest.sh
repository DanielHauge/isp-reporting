#!/bin/bash

echo "$(date +"%Y-%m-%dT%H:%M:%SZ") | Speedtesting" >> /reports/log.txt

csv=$(echo "YES" | speedtest --accept-gdpr --accept-license -f csv)
# timestamp epoch,timestamp pretty,server name,server id,idle latency,idle jitter,packet lossdownload,upload,download bytes,upload bytes,share url,download server count,download latency,download latency jitter,download latency low,download latency high,upload latency,upload latency jitter,upload latency low,upload latency high,idle latency low,idle latency high
timestampD=$(date '+%d')
timestampM=$(date '+%m')
timestampY=$(date '+%Y')
timestampS=$(date "+%s")
timestampPretty=$(date "+%Y-%m-%d %H:%M:%S")
mkdir -p "/reports/$timestampY/$timestampM"
if [[ -n "$csv" ]]; then
    echo "\"$timestampS\",\"$timestampPretty\",$csv" >> "/reports/$timestampY/$timestampM/$timestampD.csv"
else
    echo "  " >> "/reports/$timestampY/$timestampM/$timestampD.csv"
fi


echo "$(date +"%Y-%m-%dT%H:%M:%SZ") | Generating plots" >> /reports/log.txt
# For each month
for M in /reports/*/*
do 
    echo "$(date +"%Y-%m-%dT%H:%M:%SZ") | Evaluation of: $M" >> /reports/log.txt

    # Continue if not directory.
    if [ ! -d "$M" ]; then
        echo "$(date +"%Y-%m-%dT%H:%M:%SZ") | Skipping: $M as it is not directory" >> /reports/log.txt
        continue
    fi

    monthChanged=false
    # For each day
    for D in "$M"/*.csv
    do
        echo "$(date +"%Y-%m-%dT%H:%M:%SZ") | Evauluation of: $D" >> /reports/log.txt
        csvFile=$(basename "$D")
        day=${csvFile%.*}
        lastGenerated=$(date -d @0 '+%s')
        if [[ -f "$M"/$day.png ]]; then
            lastGenerated=$(date -r "$M"/"$day"-speed.svg '+%s')
        fi
        length=${#D}
        end=$((length - 4 - 8 - 4))
        yearMonth=${D:9:$end}
        yearMonth=${yearMonth/\//-}
        nextDay=$((day+1))
        from="$yearMonth-$day"
        to="$yearMonth-$nextDay"
        lastModified=$(date -r "$D" '+%s')
        if [[ $lastModified -gt $lastGenerated ]]; then
            # Generate plots
            echo "$(date +"%Y-%m-%dT%H:%M:%SZ") | Generate day plot with range: $from - $to" >> /reports/log.txt

            rm -f "$M"/"$day"-speed.svg
            gnuplot -p -e "file='/$D';out='$M/$day-speed.svg';from='$from';to='$to';timeTicks=3600" /speed.gnuplot
            rm -f "$M"/"$day"-stability.svg
            gnuplot -p -e "file='/$D';out='$M/$day-stability.svg';from='$from';to='$to';timeTicks=3600" /stability.gnuplot
            monthChanged=true
        fi
    done

    if [[ $monthChanged = true ]]; then

        # Remove old files
        rm -f "$M".csv
        rm -f "$M"-speed.svg
        rm -f "$M"-stability.svg


        # Merge the csv's from each day in the month
        cat "$M"/*.csv > "$M".csv

        # Generate plots
        length=${#M}
        end=$((length-8))
        yearMonth=${M:9:$end}
        yearMonth=${yearMonth/\//-}
        from="$yearMonth-01"
        to="$yearMonth-32" # 32 is a largest value a date for a month can have 
        echo "$(date +"%Y-%m-%dT%H:%M:%SZ") | Generate month plot with range: $from - $to" >> /reports/log.txt

        gnuplot -p -e "file='/$M.csv';out='$M-speed.svg';from='$from';to='$to';timeTicks=86400" /speed.gnuplot
        gnuplot -p -e "file='/$M.csv';out='$M-stability.svg';from='$from';to='$to';timeTicks=86400" /stability.gnuplot
    fi

done

