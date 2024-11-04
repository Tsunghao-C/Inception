FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y vsftpd && \
    rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /tmp/vsftpd.conf

COPY tools/startup.sh /tmp/startup.sh

RUN chmod +x /tmp/startup.sh

ENTRYPOINT [ "/tmp/startup.sh" ]

CMD [ "/usr/sbin/vsftpd", "/etc/vsftpd.conf" ]