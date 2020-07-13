#!/bin/bash
# -not -path '*/\.*' will ignore hidden folders
# -not -path . will ignore current folders
# -not -path ./tar to ignore tar folders itself.
# -mindepth 1 -maxdepth 1 will only create first level of folder list.
find . -not -path . -not -path '*/\.*' -not -path ./tar -mindepth 1 -maxdepth 1 -type d > log-folder-list.csv

DIRECTORY=tar
if [ ! -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY doesn't exist.
    mkdir $DIRECTORY
fi

cat log-folder-list.csv | while read log_folder
do
    # tar the folder and files first, then using gzip to compress the tar file.
    # Specify the compression level. 1=Fastest (Worst), 9=Slowest (Best), Default level is 6
    tar cf - $log_folder/ | gzip -v -9 -c > tar/$log_folder.tar.gz
    # Using pigz to parallelize the gzip.
    # tar cf - $log_folder/ | pigz -v -9 -p 32 > $log_folder.tar.gz
done

rm log-folder-list.csv