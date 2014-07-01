galera-wizard
=============

Wizard Script for Galera Cluster

The script provided in the RPM will create a couple of sample config files for you. Once you've reviewed your file and renamed it accordingly, you'll be able to use the script to create and manage the cluster as well.  
All you have to do is to supply server-names and credentials in the config file: ```/root/galera_pamars.py```.    
It works with either *MariaDB Galera Cluster* and *Percona XtraDB Cluster*.  
It won't work on Debian systems (I didn't provide yet the proper package names in script. I need to use python ```apt``` module)


How To use the script:
======================

**All commands below are run as root.**  
```$ cp /root/galera_params.py.example /root/galera_params.py```  
edit the newly copied file ```galera_params.py``` and fill the proper data in.  
```galera-wizard.py --create-config```  
(with Percona) ```cp /etc/my.cnf.example /etc/my.cnf```  
(with MariaDB) ```cp /etc/my.cnf.d/server.cnf.example /etc/my.cnf.d/server.cnf```  
review this file (pay close attention to memory settings and other things, according to Percona/MariaDB recommendations)  
```galera-wizard.py -h```  will explain you how to bootstrap the first node and join the others.  

Bugs & Workaround:
==================

- Percona XtraBackup has a couple of bugs.  
The bug affecting Galera is: https://bugs.launchpad.net/percona-xtrabackup/+bug/1272329 (namely ```/var/lib/mysql/lost+found``` will crash SST: it's clearly OSError from Perl, as it cannot access the directory).  
A possible workaround is to to use incron to re-asssign ```/var/lib/mysql/lost+found``` to ```mysql:mysql``` (or whatever else comes to your mind).  


Prerequisites & Installation:
=============================

Red Hat:
- install Percona XtraBackup: http://www.percona.com/software/percona-xtrabackup/downloads
- ```yum install python-argparse MySQL-python```
- download and install the last RPM from ```rpms``` folder
- follow the steps described in **How To use the script**

other systems (untested):
- copy ```galera-wizard.py``` somewhere within your $PATH (i.e.: ```/usr/local/bin```)
- install Python argparse (some Linux distributions already have it)
- install MySQL for python (on Ubuntu is called *python-mysqldb*)
- follow the steps described in **How To use the script**


Variables in /root/galera_params.py:
====================================
imagine we have: 
 - three servers: galera-001.domain.com - galera-002.domain.com - galera-003.domain.com
 - DB root password: myrootpass | DB sst password: mysstpass | DB nagios password: mynagiospass

This is what we'll have in the file:
```python
all_nodes = [ "galera-001.domain.com", "galera-002.domain.com", "galera-003.domain.com" ]
credentials = {"root": "myrootpass", "sstuser": "mysstpass", "nagios": "mynagiospass"}
mydomain = "domain.com"
```

Variables in server.cnf/my.cnf:
===============================

Please check the documentation from Percona XtraDB Cluster / MariaDB Galera Cluster. 


Monitor:
========

I created a script to check the nodes: ```/usr/local/bin/galeracheck.sh``` (**leave it there:** it will be configurare by the main script ```galera-wizard.py```)  


Notes:
======

- Severalnines provides an online configurator (http://www.severalnines.com/configurator) which will assist you to create your own galera mysql configuration files and it works with different vendors:
    - codership
    - mariadb
    - percona


Acknowledgments:
================

- a big thanks goes to Codership (http://galeracluster.com), the Finnish company who created Galera and made it available under public license

