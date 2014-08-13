#!/bin/bash

# Takes a single argument: an ISO-8601-formatted date, like 1964-07-02
retrieve_and_unpack_backups() {
  local TARGET_DATE=$1

  aws s3 cp s3://agra-db-backups/backups/db2.agra.managedmachine.com-data-${TARGET_DATE}.tar.gz /tmp/db2.agra.managedmachine.com-data-${TARGET_DATE}.tar.gz
  aws s3 cp s3://agra-db-backups/backups/db2.agra.managedmachine.com-xlog-${TARGET_DATE}.tar.gz /tmp/db2.agra.managedmachine.com-xlog-${TARGET_DATE}.tar.gz

  sudo tar -zxvf /tmp/db2.agra.managedmachine.com-data-${TARGET_DATE}.tar.gz -C /var/lib/postgresql/9.2
  sudo tar -zxvf /tmp/db2.agra.managedmachine.com-xlog-${TARGET_DATE}.tar.gz -C /var/lib/postgresql/9.2
}

set -x  # Echo commands and expand variables

source /vagrant/.env

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# stop while we mess around
sudo service postgresql stop

# move aside the old pg files
mv /var/lib/postgresql/9.2/main /var/lib/postgresql/9.2/main.old

# get the backup file 
retrieve_and_unpack_backups 2014-03-24

# bring the db back up
sudo service postgresql start
