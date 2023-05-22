#!/bin/bash

# Accepting terms etc.
echo "Making first report"
bash /speedtest.sh

# Setup cron scheduler
echo "Setup speedtest schedule: $1"
echo "$1 /bin/bash /speedtest.sh" >> /etc/cron.d/internet-reporting

chmod +x /etc/cron.d/internet-reporting
crontab /etc/cron.d/internet-reporting
echo "Registered cron job:"
cron -l

# To enable interactivity and preventing image to stop.
bash 