galerakickoff
=============

KickOff Script for Galera Cluster

In the directory files you'll find a server.cnf example for MariaDB Cluster
(working with either version 10 and 5.5) to be put inside /etc/my.cnf.d/

The configuration files contain puppet variables. If you don't have puppet
you'll remove the 'erb' extension and fill the variables manually. 


Prologue:
=========

In the configuration files I use puppet variables, that you may re-use or just
disregard and fill in your values


Bugs & Workaround:
==================

- Percona XtraBackup has a couple of bugs. The bug affecting this script is the
  following: if you have /var/lib/mysql/lost+found the script will crash. To
  workaround the issue you may use incron to re-asssign the directory to mysq:mysql
  You can even delete lost+found but it will be created again during the boot
  Here is the bug: https://bugs.launchpad.net/percona-xtrabackup/+bug/1272329


Prerequisites: 
==============

- /var/lib/mysql must be a mount-point in fstab (lvm, btrfs, normal partion...)
- copy galera_params.py under /root/
- copy galerakickoff.py somewhere within your $PATH (i.e.: /usr/local/bin)
- if you use MariaDB copy server.cnf under /etc/my.cnf.d/
- if you use Percona create my.cnf accordingly and put it under /etc/

you need to install the following extra software:
- Percona XtraBackup: http://www.percona.com/software/percona-xtrabackup/downloads
- Python argparse (some Linux distributions already have it)
- MySQL for python (Ubuntu: python-mysqldb - Red Hat: MySQL-python)


Variables in /root/galera_params.py
============================================
```ruby
all_nodes = ["<%= @galera_hosts.join('", "') -%>"]
credentials = {"root": "<%= @galera_root_password %>", "sstuser": "<%= @galera_sst_password %>", "nagios": "<%= @galera_nagios_password %>"}
mydomain = ".<%= @domain -%>"
```
imagine we have: 
 - tre servers: galera-001.domain.com - galera-002.domain.com - galera-003.domain.com
 - database root password: myrootpass
 - database sst password: mysstpass
 - database nagios password: mynagiospass

Then you'll have the following lines in the file:
```python
all_nodes = [ "galera-001.domain.com", "galera-002.domain.com", "galera-003.domain.com" ]
credentials = {"root": "myrootpass", "sstuser": "mysstpass", "nagios": "mynagiospass"}
mydomain = ".domain.com"
```

Variables in server.cnf:
=============================
```ruby
<%= @galera_hosts.join(",") %> 
```
- a comma separated list of the hosts belonging to the cluster. With MariaDB
  this row can be commented ouy, but with Percona, due to a bug, even if it
  will work, it will not show the servers connected to the cluster.

```ruby
<% if @memorysize =~ /GB/ -%>
innodb-buffer-pool-size=<%= (@memorysize.gsub(' GB','').to_f * 1024 * @galera_total_memory_usage.to_f).floor %>M
<% elsif @memorysize =~ /MB/ -%>
innodb-buffer-pool-size=<%= (@memorysize.gsub(' MB','').to_f * @galera_total_memory_usage.to_f ).floor %>M
<% end -%>
```
- This is namely something like: innodb-buffer-pool-size=4096M 
  I use to assign 70% of the memory, but you'll do as you prefer.

```ruby
<% if @memorysize =~ /GB/ -%>
wsrep_provider_options="gcache.size=<%= (@memorysize.gsub(' GB','').to_f * 1024 * 0.15).floor %>M"
<% elsif @memorysize =~ /MB/ -%>
wsrep_provider_options="gcache.size=<%= (@memorysize.gsub(' MB','').to_f * 0.15).floor %>M"
<% end -%> 
```
- Similar as above said. In this case I give 15% of the whole memory

```ruby
wsrep_cluster_name="<%= @application %>_<%= @dtap_stage %>"
```
- This is the name of the cluster. It's a unique name in the network. In my case
  is automatically assigned using few parameters taken from our git branches

```ruby
innodb-log-file-size=<%= @innodb_log_file_size %>
innodb-log-buffer-size=<%= @innodb_log_buffer_size %>
innodb-buffer-pool-instances=<%= @innodb_buffer_pool_instances %>
max-connections=<%= @max_connections %>
```
- Please refer to MariaDB/Percona documentation to understand these variables.

wsrep_sst_receive_address=<%= @fqdn %>
- Fully qualified domain name of the server running Galera Cluster
```ruby
wsrep_sst_auth=sstuser:<%= @galera_sst_password %>
```
- password for the user 'sstuser' used for the replication


Monitor:
========

- I created a script to check the nodes.
- there are only two parameter to set:
  inside clustercheck.sh:
```ruby
    NODE_COUNT=<%= @galera_hosts.count %>
```
  will contain the number of nodes in your cluster (minimum is 3):
```
    NODE_COUNT=3
```
  you need to copy my_nagios.cnf under /etc/
```ruby
    password=<%= @galera_nagios_password %>
```
  will contain the nagios password already defined in /root/galera_params.py:
    password=mynagiospass


Notes:
======

- severalnines.com provides an online configurator to create your own galera
  mysql configuration files and it works with different vendors:
    - codership
    - mariadb
    - percona


Acknowledgments:
================

- a big thanks goes to Codership, the Finnish company who created Galera and
  made it available under public license.

