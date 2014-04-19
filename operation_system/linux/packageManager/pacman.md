# Take a look to
# https://wiki.archlinux.de/title/Pacman

# do not ask for confirmation (no good idea except you run pacman from a script)

--noconfirm

# cleare old/unused packages

pacman -Sc

# update local database

pacman -Sy

# update installed packages

pacman -Su

# update list and upgrade packages

pacman -Syu

# build up local database

pacman -Syuu

# search for package

pacman -Ss $name

# show installed packages

pacman -Q

# remove package

pacman -R $name

# remove package and all dependencies

pacman -Rs $name

# reinstall with force

pacman -Syy --force <package>