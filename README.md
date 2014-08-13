agra-db-restore
===============

A quick vagrant config for provisioning machines to restore pg backups into. 

RailsMachine generates backups with OmniPTR. Vagrantfile automates provisioning machines for restoration. Machines can either be on AWS or VirtualBox. 

Requires: http://docs.vagrantup.com/v2/installation/index.html

Spinning up the VM
------------------
We'll spin up the box in AWS, to facilitate retrieving backups from S3.

First, install some things:

    vagrant plugin install vagrant-aws
    vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
    
Then, create a <code>.env</code> with appropriate values based on <code>.env.sample</code>.

Load those environment variables:

    source .env

Finally, spin up the box:

    vagrant up --provider=aws

Restoring the DB
----------------
SSH to the new VM:

    vagrant ssh

Go to the directory where Vagrant put the scripts:

    cd /vagrant

Run the <code>restore_db.sh</code> script, specifying a date in ISO 8601 format, like so:

    ./restore_db.sh 2014-03-24
