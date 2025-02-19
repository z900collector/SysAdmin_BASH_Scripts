#!/bin/bash
#
# Recursively remove files as requested from the target directory.
# This script is run from CRON. Used to keep logs and backup files in check.
# usage:
# /usr/local/bin/cleanup-directories.sh -r 30 -d /logs
# /usr/local/bin/cleanup-directories.sh -r 21 -d /logs/cron
# /usr/local/bin/cleanup-directories.sh -r 21 -d /logs/db-backups
# /usr/local/bin/cleanup-directories.sh -r 21 -d /logs/magento-logs
#
# -r = retention period and
# -d = directory path
#
#
#
#
#
# History
# ——-
# 2008-12-22  Sid Young  Created script to clean up old files to reduce disk space

TARGET_DIR=/tmp
KEEP_DAYS=90
EMAIL=sid.young@tri.edu.au

#
# Common Logging Code
#
function LogStart
{
echo "====== Log Start =========" >> $LF
echo "Time: `date`" >> $LF
echo " " >> $LF
}
function LogEnd
{
echo " " >> $LF
echo "Time: `date`" >> $LF
echo "====== Log End   =========" >> $LF
}

function LogMsg
{
echo "`date '+%Y-%m-%d|%H:%M:%S|'`$$|OK|$1" >> $LF
}

function LogError
{
echo "`date '+%Y-%m-%d|%H:%M:%S|'`$$|ERROR|$1" >> $LF
}

function LogCritical
{
echo "`date '+%Y-%m-%d|%H:%M:%S|'`$$|CRITICAL|$1" >> $LF
}

#UMASK=002
FILE_DATE=`date '+%Y-%m-%d'`
LF_DIR=/logs/cron/cleanup
LF=$LF_DIR/dircleanup-$FILE_DATE.log
mkdir -p $LF_DIR
chmod 777 /logs
chmod 775 /logs/cron
chmod 775 /logs/cron/cleanup
touch $LF
chmod 644 $LF

#
# Process any command line parameters
#


LogStart
set — getopt dr: "$@"
while [ $# -gt 0 ]
do
   case "$1" in
      -d)     TARGET_DIR="$2" ;;
      -r)     KEEP_DAYS="$2" ;;
   esac
   shift
done

LogMsg "Target directory: $TARGET_DIR"
LogMsg "Retension Period: $KEEP_DAYS"
if [ -d "$TARGET_DIR" ]
then
   cd $TARGET_DIR
   LogMsg "$TARGET_DIR exists – Locating files to delete"
   CNT=`find $TARGET_DIR -type f -mtime +$KEEP_DAYS -print | wc -l`
#
# Find the files and list them to the log
#
   find $TARGET_DIR -type f -mtime +${KEEP_DAYS} -print > /tmp/cleanup-list-$$
   LogMsg "File list is:"
   LogMsg "-----"
   for file in `cat /tmp/cleanup-list-$$`
   do
      LogMsg $file
   done
   LogMsg " "
   for file in `cat /tmp/cleanup-list-$$`
   do
      rm $file > /dev/null 2>&1
      if [ $? -eq 1 ]
      then
         LogMsg "File ${file} Not Found?"
      fi
   done
   LogMsg "Done ${CNT} files removed"
   if [ "$TARGET_DIR" != "/tmp" ]
   then
      LogMsg "Remove Empty Directories"
      find $TARGET_DIR -type d -empty -delete -print >> $LF
      LogMsg "Done "
   fi
else
   LogCritical "Aborting – $TARGET_DIR does not exist"
   echo "ERROR – Target for cleanup [ $TARGET_DIR ] does not exist – aborting" | mailx -s "[CRON] Cleanup failed" $EMAIL
fi

rm -f /tmp/cleanup-list-$$
LogEnd
#
# End of file
