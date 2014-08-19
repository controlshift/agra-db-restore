#!/bin/bash

# Takes a single argument: an ISO-8601-formatted date, like 1964-07-02
retrieve_and_unpack_backups() {
  local TARGET_DATE=$1

  aws s3 cp s3://agra-db-backups/backups/db2.agra.managedmachine.com-data-${TARGET_DATE}.tar.gz /tmp/db2.agra.managedmachine.com-data-${TARGET_DATE}.tar.gz
  aws s3 cp s3://agra-db-backups/backups/db2.agra.managedmachine.com-xlog-${TARGET_DATE}.tar.gz /tmp/db2.agra.managedmachine.com-xlog-${TARGET_DATE}.tar.gz

  if [ ! -e /tmp/db2.agra.managedmachine.com-data-${TARGET_DATE}.tar.gz ] || [ ! -e /tmp/db2.agra.managedmachine.com-xlog-${TARGET_DATE}.tar.gz ]; then
    echo "Files not successfully retrieved from S3.  Have they been retrieved from glacier yet?"
    return 1
  fi

  sudo tar -zxvf /tmp/db2.agra.managedmachine.com-data-${TARGET_DATE}.tar.gz -C /var/lib/postgresql/9.2
  sudo tar -zxvf /tmp/db2.agra.managedmachine.com-xlog-${TARGET_DATE}.tar.gz -C /var/lib/postgresql/9.2
}

### Main script ###
USAGE="Usage: $0 DATE"

# Echo commands and expand variables
set -x

# Load environment variables
source /vagrant/.env

# Extract date parameter
if [ -z $1 ]; then
  echo $USAGE
  exit
fi
DATABASE_DATE=$1

# Make some edits to postgresql.conf
if [ -z $PG_CONF ]; then
  echo "Using default pg conf location"
  PG_CONF="/etc/postgresql/9.2/main/postgresql.conf"
fi
# change listen address to '*':
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"
# Decomment a couple options recommended by RM so pg will come up
sudo sed -i "s/#hot_standby = off/hot_standby = off/" "$PG_CONF"
sudo sed -i "s/#archive_mod = off/archive_mod = off/" "$PG_CONF"

# stop while we mess around
sudo service postgresql stop

# move aside the old pg files
sudo rm -rf /var/lib/postgresql/9.2/main.old
sudo mv /var/lib/postgresql/9.2/main /var/lib/postgresql/9.2/main.old

# get the backup file 
retrieve_and_unpack_backups $DATABASE_DATE
if [ $? -ne 0 ]; then
    exit 1
fi

# The backup_label file is broken due to a bug.  It confuses pg.  Get rid of it.
sudo rm /var/lib/postgresql/9.2/main/backup_label

# bring the db back up
sudo service postgresql start
