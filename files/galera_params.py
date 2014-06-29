# The following lines come from Puppet
#
# Comma separated list of all hosts in the cluster
all_nodes = ["<%= @galera_hosts.join('", "') -%>"]

# Users and passwords
credentials = {"root": "<%= @galera_root_password %>", "sstuser": "<%= @galera_sst_password %>", "nagios": "<%= @galera_nagios_password %>"}

# Domain name of your hosts
domain = ".<%= @domain -%>"

<% if @galera_vendor == 'mariadb' -%>
#This command is used with MariaDB
ootstrap_cmd = "bootstrap"
<% else -%>
# This command is used with Percona
bootstrap_cmd = "bootstrap-pxc
<% end -%>
# The above lines come from Puppet

