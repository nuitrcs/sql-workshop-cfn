#!/bin/bash

/bin/sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
/bin/sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
/sbin/service sshd restart

echo "export PGHOST=${PGHOST}" >>/etc/profile

/usr/bin/psql -d dvdrental -c "REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;"
/usr/bin/psql -d dvdrental -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO PUBLIC;"
/usr/bin/psql -d dvdrental -c "REVOKE ALL ON SCHEMA public FROM PUBLIC;"
/usr/bin/psql -d dvdrental -c "GRANT USAGE ON SCHEMA public TO PUBLIC;"
/usr/bin/psql -d template1 -c "REVOKE ALL ON SCHEMA public FROM PUBLIC;"

while read netid
do
    adduser $netid && echo "${netid}:$(echo ${netid} | rev)" | chpasswd
    /usr/bin/psql -d postgres -c "CREATE ROLE ${netid} WITH LOGIN PASSWORD '$(echo ${netid} | rev)'"
    /usr/bin/psql -d postgres -c "GRANT CONNECT ON DATABASE dvdrental TO ${netid};"
    /usr/bin/psql -d postgres -c "CREATE DATABASE ${netid};"
    /usr/bin/psql -d postgres -c "GRANT ALL ON DATABASE ${netid} to ${netid};"
    /usr/bin/psql -d $netid -c "GRANT ALL ON SCHEMA public to ${netid};"
done