FROM    debian:bullseye

RUN apt-get update
RUN apt-get install -y redis && \
    rm -rf /var/lib/apt/lists/*

COPY    ./tools/startup.sh /tmp/startup.sh

RUN chmod +x /tmp/startup.sh

EXPOSE  6379

ENTRYPOINT [ "/tmp/startup.sh" ]

CMD ["redis-server", "--bind", "0.0.0.0", "--port", "6379", "--protected-mode no"]