#!/bin/bash

if [ ! -f "/etc/vsftpd.conf.bak" ]; then

    # create repo for secure chroot
    mkdir -p /var/run/vsftpd/empty
    # create repo for local root
    mkdir -p /var/www/html


    cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
    mv /tmp/vsftpd.conf /etc/vsftpd.conf

    # Add FTP_USER, change password and declare owner of wordpress folder
    adduser --disabled-password --gecos "" "$FTP_USER"
    echo "$FTP_USER:$FTP_PWD" | chpasswd
    chown -R "$FTP_USER:$FTP_USER" /var/www/html
    chmod 755 /var/www/html

    # Add the user to the vsftpd user list
    echo "$FTP_USER" | tee -a /etc/vsftpd.userlist > /dev/null

fi

echo "FTP server starting on port 21"

exec "$@"