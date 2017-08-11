#!/bin/bash

/bin/sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
/bin/sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
/sbin/service sshd restart

while read netid
do
    adduser $netid && echo "${netid}:$(echo ${netid} | rev)" | chpasswd
    /usr/bin/psql -c "CREATE ROLE ${netid} WITH LOGIN PASSWORD '$(echo ${netid} | rev)';"
    /usr/bin/psql -d dvdrental -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO ${netid};"
    /usr/bin/psql -c "CREATE DATABASE ${netid} OWNER ${netid};"
done