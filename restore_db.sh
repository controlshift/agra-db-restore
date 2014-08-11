source /vagrant/.env

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# stop while we mess around
sudo service postgresql stop

# move aside the old pg files
mv /var/lib/postgresql/9.2/main /var/lib/postgresql/9.2/main.old


# get the backup file 
aws s3 cp s3://agra-db-backups/backups/db2.agra.managedmachine.com-data-2014-03-24.tar.gz /tmp/db2.agra.managedmachine.com-data-2014-03-24.tar.gz
aws s3 cp s3://agra-db-backups/backups/db2.agra.managedmachine.com-xlog-2014-03-24.tar.gz /tmp/db2.agra.managedmachine.com-xlog-2014-03-24.tar.gz

sudo tar -zxvf /tmp/db2.agra.managedmachine.com-data-2014-03-24.tar.gz -C /var/lib/postgresql/9.2
sudo tar -zxvf /tmp/db2.agra.managedmachine.com-xlog-2014-03-24.tar.gz -C /var/lib/postgresql/9.2

service postgresql start