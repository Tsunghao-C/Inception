FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl https://packages.grafana.com/gpg.key | apt-key add - && \
    echo "deb https://packages.grafana.com/oss/deb stable main" > etc/apt/sources.list.d/grafana.list && \
    apt-get update && \
    apt-get install -y grafana && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3000

ENTRYPOINT [ "/usr/sbin/grafana-server", "--homepath=/usr/share/grafana" ]