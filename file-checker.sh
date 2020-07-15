#!/bin/bash

S3_BUCKET="your-bucket-name"
BASE_PATH="/your/base/path"
AWS_PROFILE="checker"
TODAY="$(date +"%Y-%m-%d")"

# Using pypy envs
# export PYENV_ROOT="/opt/pypy3envs"
# export PATH="$PYENV_ROOT/bin:/usr/local/bin:$PATH"
# export PYENV_VERSION="file-checker"
# eval "$(pyenv init -)"

# In case you need some help to check python/aws version
#echo $(which python)
#echo $(python --version)
#echo $(which aws)
#echo $(python --version)

aws s3 ls s3://$S3_BUCKET$BASE_PATH --recursive --profile $AWS_PROFILE > checker.tmp
touch ${TODAY}_result.csv
cat checker.tmp | awk 'BEGIN{OFS=","} {print $1,$2,$3,$NF}' | awk -F/ 'BEGIN{OFS=","} {print $1,$(NF-1),$NF}' | awk -F. 'BEGIN{OFS=","} {print $1,$2}' >> ${TODAY}_result.csv
chmod 666 ${TODAY}_result.csv
rm -f checker.tmp

# unset PYENV_VERSION