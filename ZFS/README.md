
# ZFS Scripts

The ZFS directory has some scripts for working on the MGS/MDT and OST's in a Lustre Filesystem.

## Files

### auto-snapshot-zfs.sh

At the BASH promt (as root) type: ./auto-snapshot-zfs.sh
Output is logged to a log file in /logs/snapshots
Requires the log-functions.sh script in this github repo.

**If you don't want the logging**, substitute LogMsg with "echo" and remove all references to Log.... functions.

## Deploying with SaltStack

### Downlaoding to a Minion

```
download-zfs-script:
  file.managed:
    - source: salt://servers/{{pillar['server_name']}}/files/auto-snapshot-zfs.sh
    - name: /root/auto-snapshot-zfs.sh
    - user: root
    - group: root
    - mode: 0740
```

### Using in a CRON
```
zfs-snapshot:
  cron.present:
    - name: ' /root/auto-snapshot-zfs.sh > /dev/null 2>&1'
    - user: root
    - minute: '0'
    - hour: '6,12,18,0'
    - daymonth: '*'
    - month: '*'
    - dayweek: '*'
    - identifier: 'MGS-ZFS-SNAPSHOT'
```
