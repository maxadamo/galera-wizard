# The following 3 lines come from Puppet
all_nodes = ["<%= @galera_hosts.join('", "') -%>"]
credentials = {"root": "<%= @galera_root_password %>", "sstuser": "<%= @galera_sst_password %>", "nagios": "<%= @galera_nagios_password %>"}
mydomain = ".<%= @domain -%>"
# The above 3 lines come from Puppet

