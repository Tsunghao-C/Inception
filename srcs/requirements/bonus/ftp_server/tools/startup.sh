#!/bin/bash

if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then

    mkdir -p /var/www/html

    cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
    mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

    # Add FTP_USER, change password and declare owner of wordpress folder
    adduser $FTP_USER --disabled-password
    echo "$FTP_USER:$FTP_PWD" | /usr/sbin/chpasswd &> /dev/null
    chown -R $FTP_USER:$FTP_USER /var/www/html

    echo $FTP_USER | tee -a /etc/vsftpd.userlist &> /dev/null

fi

echo "FTP started on :21"

exec "$@"