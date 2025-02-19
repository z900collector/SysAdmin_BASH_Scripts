# Scripts

log-cleanup.sh 
A generic directory cleanup script that removes files older than the retension period.

Retension Period is specified on the command line using " -r <N>" where <N> is "days"
Directory to cleanup is specified using -d </path/to/log/directory>

The script wil lalso remove empty directories afer the retension period has exipred.


Typical usage is in CRON, typical entry shown below (as created by SaltStack):

Crontab entries:
# SALT_CRON_IDENTIFIER:TRIM_SALT_TAR_ARCHIVE
45 4 * * * /usr/local/bin/log-cleanup.sh -r 90 -d /data/archive  > /dev/null 2>&1

# SALT_CRON_IDENTIFIER:LOG_CLEANUP_beacon-data
1 0 * * * /usr/local/bin/log-cleanup.sh -r 7 -d /data/beacon-data > /dev/null 2>&1

# SALT_CRON_IDENTIFIER:LOG_CLEANUP_logs
56 23 * * * /usr/local/bin/log-cleanup.sh -r 60 -d /logs > /dev/null 2>&1

