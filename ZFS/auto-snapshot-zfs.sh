#!/bin/bash
#
# Automatically create a snapshot and perform a backup of the TARGET
#
# Recovery
# (carefully) zfs recv the file, dataset will be created.
# do a tunefs.lustre with a writeconf od the new MGS
#

source /usr/local/bin/log-functions.sh

LOCKFILE=/tmp/azfssn.lock
TODAY=`date +"%Y-%d-%m-%H%M"`
SNAPSHOT_DIR=/data/snapshots
SNAP="snap-${TODAY}"

ZFS_POOL=""
ZFS_DATASET=""

function TakeSnapshot ()
{
        SNAPFILE=${SNAPSHOT_DIR}/${ZFS_DATASET}-SNAP-${TODAY}

        LogMsg "Creating Snaphost POOL/DATASET [ ${ZFS_POOL}/${ZFS_DATASET} ]"
        zfs snap ${ZFS_POOL}/${ZFS_DATASET}@${SNAP}
        LogMsg "Save Snap to [ ${SNAPFILE} ]"
        zfs send -p ${ZFS_POOL}/${ZFS_DATASET}@${SNAP} > ${SNAPFILE}
        LogMsg "Remove Snapshot"
        zfs destroy ${ZFS_POOL}/${ZFS_DATASET}@${SNAP}
}


#========================================

        SetDirectory "snapshots"
        SetFilename  "zfs-snapshot"
        LogInit
        LogStart
        LogMsg "Variable     LOCKFILE = ${LOCKFILE}"
        LogMsg "         Snapshot DIR = ${SNAPSHOT_DIR}"
        LogMsg "        Snapshot File = ${SNAPFILE}"
        LogMsg "                 Snap = ${SNAP}"
        LogMsg "               Script = $0"
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
        mkdir -p ${SNAPSHOT_DIR} > /dev/null 2>&1

        ZFS_POOL="mdspool"
        ZFS_DATASET="mdt-home"
        TakeSnapshot

        LogEnd
#
# End of file
