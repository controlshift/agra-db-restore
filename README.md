agra-db-restore
===============

A quick vagrant config for provisioning machines to restore pg backups into. 

RailsMachine generates backups with OmniPTR. Vagrantfile automates provisioning machines for restoration. Machines can either be on AWS or VirtualBox. 

Requires: http://docs.vagrantup.com/v2/installation/index.html

To install pg 9.2 and deps:
   vagrant up

