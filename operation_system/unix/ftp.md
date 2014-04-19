# connect to ftp

ftp $hostname

# upload filename to server

put $filename

# upload multiple files - use wildcards if needed

mput $filenames

# download file

get $filename [$localFilename]

# download multiple files - use wildcards if needed

mget $filenames

# change ftp directory

cd

# change local directory

lcd

# list fto directories

dir

# enable binary transferemode

binary

# enable text transferemode

ascii

# quit

quit