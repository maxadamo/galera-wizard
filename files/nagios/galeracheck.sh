#!/bin/bash
#
# This script is installed on /usr/local/bin
# you can symlink it in your nagios directory. I.e.: /usr/lib64/nagios/plugins/
#
# Default settings, do not touch.
SCRIPT_INVOCATION_SHORT_NAME=`basename $0`
#set -e # exit on errors
#trap 'echo "${SCRIPT_INVOCATION_SHORT_NAME}: exit on error"; exit 3' ERR
set -u # disallow usage of unset variables

# Globals
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

CMD="/usr/bin/mysql --defaults-file=/etc/my_nagios.cnf --skip-column-names"

#
# Redirect everything to /dev/null
exec 6>&1              # Link file descriptor #6 with stdout
exec 7>&2              # Link file descriptor #7 with stderr
exec &> /dev/null 2>&1 # Redirect to /dev/null

#
# The number of the nodes in the cluster:
NODE_COUNT=3

# Here we go:
if ($CMD -e "UPDATE test.nagios SET id=("$RANDOM");"); then
   NODE_CONNECTED=$($CMD -B -e "SELECT VARIABLE_VALUE from information_schema.GLOBAL_STATUS where VARIABLE_NAME like 'WSREP_CLUSTER_SIZE';")
   if [ $NODE_CONNECTED -lt  $NODE_COUNT ]; then
      DESCRIPTION="WARNING: NOT all nodes are connected"
      STATUS=$STATE_WARNING
   else
      DESCRIPTION="DB write and cluster status passed"
      STATUS=$STATE_OK
   fi
else
   DESCRIPTION="CRITICAL: Error writing to DB"
   STATUS=$STATE_CRITICAL
fi

#
# Restore output
exec 2>&7 7>&-   # Restore stderr and close file descriptor #7
exec 1>&6 6>&-   # Restore stdout and close file descriptor #6

#
# say goodbye
echo $DESCRIPTION
exit $STATUS

