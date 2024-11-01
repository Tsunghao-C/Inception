FROM alpine:3.13

RUN apk update && apk upgrade && apk add --no-cache \
    vsftpd

COPY conf/vsftpd.conf /tmp/vsftpd.conf

COPY tools/startup.sh /tmp/startup.sh

RUN chmod +x /tmp/startup.sh

ENTRYPOINT [ "/tmp/startup.sh" ]

CMD [ "/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf" ]