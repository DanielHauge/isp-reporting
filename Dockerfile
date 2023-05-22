FROM debian:stable-slim

RUN apt-get update
RUN apt-get install -y curl
RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash
RUN apt-get install -y speedtest 
RUN apt-get install -y jq
RUN apt-get install -y cron
RUN apt-get install -y gnuplot
RUN mkdir reports

COPY speedtest.sh speedtest.sh
COPY setup.sh setup.sh
RUN chmod +x speedtest.sh
RUN chmod +x setup.sh

COPY speed.gnuplot speed.gnuplot 
COPY stability.gnuplot stability.gnuplot 




ENTRYPOINT ["/setup.sh"]
# Default schedules: speedtest every 10 minutes, make graphs every hour
CMD ["*/10 * * * *", "0 * * * *"]
