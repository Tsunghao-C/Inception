FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Download Prometheus
RUN curl -LO https://github.com/prometheus/prometheus/releases/download/v2.32.1/prometheus-2.32.1.linux-amd64.tar.gz && \
    tar xvf prometheus-2.32.1.linux-amd64.tar.gz && \
    mv prometheus-2.32.1.linux-amd64/* /prometheus && \
    rm prometheus-2.32.1.linux-amd64.tar.gz

# Copy configuration file
COPY ./conf/prometheus.yml /prometheus/prometheus.yml

EXPOSE 9090

WORKDIR /prometheus

ENTRYPOINT [ "prometheus", "--config.file=/prometheus/prometheus.yml" ]