agra-db-restore
===============

A quick vagrant config for provisioning machines to restore pg backups into. 

RailsMachine generates backups with OmniPTR. Vagrantfile automates provisioning machines for restoration. Machines can either be on AWS or VirtualBox. 

Requires: http://docs.vagrantup.com/v2/installation/index.html

Locally
-------
To install pg 9.2 and deps on a local virtualbox vm:

    vagrant up

In AWS
------
You may want to spin up the box in AWS, to facilitate retrieving backups from S3.  Here's how.

First, install some things:

    vagrant plugin install vagrant-aws
    vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
    
Then, update .env with the correct values, and source .env to get the environment variables.

Finally, spin up the box:

    vagrant up --provider=aws
