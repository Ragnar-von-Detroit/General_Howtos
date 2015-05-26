# set options via xorg.conf

```
# vim /etc/X11/xorg.conf.d/10-monitor.conf
"Section "ServerLayout"
    Identifier "ServerLayout0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
EndSection
```

# get options via xset

```
xset q
```

# set options via xset

```
# change blank time to 1 minute
xset s 60 60
# change dpms power saving blank time to 1 minute
xset dpms 60 60 60
```

# links

* https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling