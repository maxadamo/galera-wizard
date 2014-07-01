galera-wizard
=============

Wizard Script for Galera Cluster

In the directory ```files``` you'll find a server.cnf example for MariaDB Cluster (working with either version 10 and 5.5) to be put inside ```/etc/my.cnf.d/```


Bugs & Workaround:
==================

- Percona XtraBackup has a couple of bugs. The bug affecting us it the following: ```/var/lib/mysql/lost+found``` will crash SST.  
https://bugs.launchpad.net/percona-xtrabackup/+bug/1272329 ```/var/lib/mysql/lost+found```  
A possible workaround can be to to use incron to re-asssign the directory to mysq:mysql (or whatever else comes yo your mind).  


Prerequisites & Installation:
=============================

Red Hat:
- install Percona XtraBackup: http://www.percona.com/software/percona-xtrabackup/downloads
- yum install python-argparse MySQL-python
- download and install the RPM from ```rpms``` folder
- check ```/root/galera_params.py.example``` and fill your data in ```/root/galera_params.py```

other systems:
- copy galera-wizard.py somewhere within your $PATH (i.e.: ```/usr/local/bin```)
- if you use MariaDB copy server.cnf under ```/etc/my.cnf.d/```
- if you use Percona create my.cnf accordingly and put it under ```/etc/```
- Python argparse (some Linux distributions already have it)
- MySQL for python (Ubuntu: python-mysqldb - Red Hat: MySQL-python)


Variables in /root/galera_params.py
============================================
imagine we have: 
 - three servers: galera-001.domain.com - galera-002.domain.com - galera-003.domain.com
 - DB root password: myrootpass | DB sst password: mysstpass | DB nagios password: mynagiospass

This is what we'll have in the file:
```python
all_nodes = [ "galera-001.domain.com", "galera-002.domain.com", "galera-003.domain.com" ]
credentials = {"root": "myrootpass", "sstuser": "mysstpass", "nagios": "mynagiospass"}
mydomain = "domain.com"
```

Variables in server.cnf:
=============================
```
wsrep_cluster_address=gcomm://galera-001.domain.com,galera-002.domain.com,galera-003.domain.com
```
- a comma separated list of the hosts belonging to the cluster. With MariaDB this row can be commented ouy, but with Percona, due to a bug, even if it will work, it will not show the servers connected to the cluster.  
  
----------------------  
```
wsrep_sst_receive_address=galera-001.domain.com
```
- Fully qualified domain name of the server running Galera Cluster


----------------------  
```ruby
wsrep_sst_auth=sstuser:mysstpass
```
- password for the user 'sstuser' used for the replication


Monitor:
========

I created a script to check the nodes. It contains only two parameter to set.  
- galeracheck.sh needs to know how many nodes we have in the cluster (minimum is 3):
```
    NODE_COUNT=3
```
- you need to copy my_nagios.cnf under ```/etc/``` and it will contain the password for nagios:
```
    password=mynagiospass
```


Notes:
======

- Severalnines provides an online configurator (http://www.severalnines.com/configurator) which will assist you to create your own galera mysql configuration files and it works with different vendors:
    - codership
    - mariadb
    - percona


Acknowledgments:
================

- a big thanks goes to Codership (http://galeracluster.com), the Finnish company who created Galera and made it available under public license

