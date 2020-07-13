# HOWTO

* How to use change-name script to change s3 files' name?

Create a filelist.csv, each line is a file-id, and the script will loop through the filelist to move all files.

* How to use gzip-logs script to compress logs?

Execute the script on the root folder, and it will compress all subfolders for you,
the compressed files will be under tar/ folder.
If system already installed pigz, comment the gzip line and uncomment pigz line.

