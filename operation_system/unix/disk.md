# show current harddrive layout

    /sbin/fdisk -l

# list disks and partitions

    lsblk

# delete disk content and layout

    shred -v /dev/<sda>
