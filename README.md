agra-db-restore
===============

A quick vagrant config for provisioning machines to restore pg backups into. 

RailsMachine generates backups with OmniPTR. Vagrantfile automates provisioning machines for restoration. Machines can either be on AWS or VirtualBox. 

Requires: http://docs.vagrantup.com/v2/installation/index.html

To install pg 9.2 and deps on a local virtualbox vm:

    vagrant up

For AWS:

    vagrant plugin install vagrant-aws
    vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
