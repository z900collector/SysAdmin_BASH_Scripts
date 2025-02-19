# Log & Debug BASH shell Scripts

## log-cleanup.sh

A generic directory cleanup script that removes files older than the retension period.

Retension Period is specified on the command line using **-r N where N is Days**

Directory to cleanup is specified using **-d /path/to/log/directory**

The script wil lalso remove empty directories afer the retension period has exipred.


### CRONTAB usage

Sample entries shown below are taken from a CRON file:

45 4 * * * /usr/local/bin/log-cleanup.sh -r 90 -d /data/archive  > /dev/null 2>&1

1 0 * * * /usr/local/bin/log-cleanup.sh -r 7 -d /data/beacon-data > /dev/null 2>&1

56 23 * * * /usr/local/bin/log-cleanup.sh -r 60 -d /logs > /dev/null 2>&1

## log-functions.sh

This shell script can be sourced from your script and provides convienient logging operations for logging shell script output to a daily log file. By defualt it logs all files output to **/logs/your-directory-here/**

### File Name Format
The log file name format is: **/logs/your_dir/your_file-YYYY-MM-DD.log**

### File Format

The log file format is as follows:

```
====== Log Start =========
Time: Wed Feb 19 10:28:46 AEST 2025

2025-02-19|10:28:46|406803|OK|Variables
2025-02-19|10:28:46|406803|OK|           TMP_FILE = /tmp/wp-ha-hosts.txt
2025-02-19|10:28:46|406803|OK|           LOCKFILE = /tmp/check-ha-capacity.lock
2025-02-19|10:28:46|406803|OK|             Script = /usr/local/bin/check-cluster-capacity.sh
2025-02-19|10:28:46|406803|OK|
2025-02-19|10:28:46|406803|OK|Check for Lock File.
2025-02-19|10:28:46|406803|OK|Set trap on exit.
2025-02-19|10:28:46|406803|OK|Extract servers
...
2025-02-19|10:28:46|406803|OK|M1=0.0  M5=0.0  M15=0.0
2025-02-19|10:28:46|406803|OK|NoLoad() - Do Nothing
2025-02-19|10:28:46|406803|OK|Not all servers are loaded

Time: Wed Feb 19 10:28:46 AEST 2025
====== Log End   =========
```
If you exclude the LogStart and LogEnd functions then you have a pure pipe formatted file that can be processed with other tools to extract and report on issues logged in the file.

Pipe format is:

YYYY-MM-DD|HH:MM:SS|PID|STATUS_CODE|Text Message - see LogMSG function


When used with the **log-cleanup.sh** shell script you have a uniform, convienient and self cleaning platform to log script activity each day.

### Functions
```
function LogInit
function SetDirectory
function SetFilename
function SetLog
function LogStart
function LogEnd
function LogMsg
function LogError
function LogCritical
```
### Usage

Add the following near the start of your script: **source /usr/local/bin/log-functions.sh**

Specify a directory

Specify a file name

Example (extract) :

```
#!/bin/bash
source /usr/local/bin/log-functions.sh

SetDirectory "cluster-capacity"
SetFilename  "check-every-minute"
LogInit
LogStart
LogMsg "Variables"
LogMsg "           TMP_FILE = ${TMP_FILE}"
LogMsg "           LOCKFILE = ${LOCKFILE}"
LogMsg "             Script = $0"
LogMsg " "
LogMsg "Check for Lock File."
set -C; 2>/dev/null > ${LOCKFILE}
if [ $? -eq 1 ]
then
   LogMsg "Lock [ ${LOCKFILE} ] exists - EXIT NOW."
   exit
fi
LogMsg "Set trap on exit."
trap "rm -f ${LOCKFILE} " EXIT

... rest of code

LogEnd
```

This creates a directory called /logs/cluster-capacity
and a date stamped file

   

