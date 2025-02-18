#!/bin/bash
#
# History
# ——-
# 2023-07-17  Sid Young  Created script to be used via the "source" command

TARGET_DIR=/tmp
KEEP_DAYS=90
EMAIL=sid.young@tri.edu.au
LOG_DIRECTORY="custom"
LOG_FILENAME="default"

function LogInit
{
UMASK=002
FILE_DATE=`date '+%Y-%m-%d'`
LF_DIR=/logs/${LOG_DIRECTORY}
LF=$LF_DIR/${LOG_FILENAME}-$FILE_DATE.log
mkdir -p ${LF_DIR}
chmod 777 ${LF_DIR}
touch ${LF}
chmod 644 ${LF}
}



function SetDirectory
{
   LOG_DIRECTORY=$1
}


function SetFilename
{
   LOG_FILENAME=$1
}


function SetLog
{
   LOG_DIRECTORY="$1"
   LOG_FILENAME="$2"
   LogInit
}

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

UMASK=002
FILE_DATE=`date '+%Y-%m-%d'`
LF_DIR=/logs/${LOG_DIRECTORY}
LF=$LF_DIR/${LOG_FILENAME}-$FILE_DATE.log
mkdir -p ${LF_DIR}
chmod 777 ${LF_DIR}
touch ${LF}
chmod 644 ${LF}

#
# End of file
