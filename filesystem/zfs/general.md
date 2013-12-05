#Links

* http://docs.oracle.com/cd/E19253-01/819-5461/zfsover-1/index.html
* http://manpages.ubuntu.com/manpages/maverick/man1/zpool.1M.html
* http://hub.opensolaris.org/bin/download/Community+Group+zfs/docs/zfsadmin.pdf
* http://www.sysadmin-cookbook.net/zfs/
* http://www.solarisinternals.com/wiki/index.php/ZFS_Troubleshooting_Guide
* http://www.funtoo.org/ZFS_Fun

#Prepare empty disk and add gpt/efi lable

gdisk /dev/myDevice

#Create tank with name "myTank"

ls -lah /dev/disk/by-id
zpool create -f -m /my/mount/point pool-name  mirror|raidz id1[ id2[ id3]]

#Create filesystem

zfs create myTank/myFileSystem

#Set mountpoint (if needed)

zfs set mountpoint=/path/to/mountpoint myTank
zfs set mountpoint=/foo/bar myTank/myFileSystem

#set quota

zfs set quota=10G boo/bar
zfs set quota=none boo/bar

# Get all flags

zfs get all myTank

#Add compression to fileSystem

zfs set compression=on myTank/myFileSystem

#http://docs.oracle.com/cd/E19253-01/819-5461/gavwg/index.html

zpool events -v
zpool history $tank
zpool status -v
zpool status -x
zpool status $tank
zpool clear $tank

#List Available Pools

zpool import

#Import A Pool Under A Different Name

zpool import $pool $my-other-name

#try zpool import without mounting it

zpool import -N

#Import pool for current run (not permanently) with different root path

zpool import -R /path/to/mountpoint zpoolId

#Snapshot

zfs snapshot myTank/myFileSystem@mySnapshot

#Rollback

zfs rollback myTank/myFileSystem@mySnapshot

#Clone

zfs clone myTank/myFileSystem@mySnapshot myTank/myFileSystem/myClone

#Backup

zfs send [-D -R -I @snapshot | ssh backup.me.com zfs recv [-u -d -F]tank/backup

#Replace Unavailable Disk

* zpool status
* zpool detach $pool $dead-device

#Stop Scrub

zpool scrub -s $pool