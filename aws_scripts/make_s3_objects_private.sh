#!/bin/bash

S3_BUCKET=$1

aws s3 ls --recursive s3://$S3_BUCKET | awk '{print $NF}' | while read line; do
    echo "$line"
    aws s3api put-object-acl --acl private --bucket $S3_BUCKET --key "$line"
done
