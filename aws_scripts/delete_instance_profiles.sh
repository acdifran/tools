#!/bin/bash

declare -a arr=("dcos-bootstrap" "dcos-deepcortex")
for i in "${arr[@]}"; do
    aws iam delete-instance-profile --instance-profile-name $i
done
