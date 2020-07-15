# HOWTO

* How to use change-name script to change s3 files' name?

Create a filelist.csv, each line is a file-id, and the script will loop through the filelist to move all files.

* How to use gzip-logs script to compress logs?

Execute the script on the root folder, and it will compress all subfolders for you,
the compressed files will be under tar/ folder.
If system already installed pigz, comment the gzip line and uncomment pigz line.

* How to use file-checker?

Add aws profile and change the S3_BUCKET/BASE_PATH/AWS_PROFILE, and the script will scan the folders and subfolders, and it will produce a csv file with all files.

If you have pypyenvs and want to use it, uncomment the lines of pypyenvs, and you can use that pypyenv.
