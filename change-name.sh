#!/bin/bash

bucket="s3://your-bucket-name"
cat filelist.csv | while read fileid
do
    for subfolder in abc/def/; do
        # aws s3 mv $bucket/$fileid/$subfolder$fileid.doc $bucket/$fileid/$subfolder$fileid-M.doc --dryrun
        aws s3 mv $bucket/$fileid/$subfolder$fileid.doc $bucket/$fileid/$subfolder$fileid-M.doc
    done
done