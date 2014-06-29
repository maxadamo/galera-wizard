#
# Comma separated list of all hosts in the cluster
all_nodes = ["test-server-001.domain.com", "test-server-001.domain.com", "test-server-001.domain.com",]

# Users and passwords
credentials = {"root": "myrootpass", "sstuser": "mysstpass", "nagios": "mynagiospass"}

# Domain name of your hosts
mydomain = "domain.com"

# Use "bootstrap" with MariaDB and use "boostrap-pxc" with Percona
bootstrap_cmd = "bootstrap"


