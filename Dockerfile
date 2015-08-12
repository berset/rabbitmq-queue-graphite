FROM rabbitmq:3.5.4

RUN apt-get update && apt-get install -y netcat-openbsd

COPY report_stats.pl /opt/

CMD ["/opt/report_stats.pl"]

