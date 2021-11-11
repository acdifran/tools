#!/usr/bin/env bash

# When sourced, this script will export the AWS_ACCESS_KEY_ID and
# AWS_SECRET_ACCESS_KEY credentials from the a specific profile in
# ~/.aws/credentials.
#
# Usage:
#
#    export-aws-credentials [PROFILE]
#
# If PROFILE is not given, the "default" profile will be exported. The
# output of this script is intended to be fed into `eval`.
#
# Examples:
#
#    eval $(export-aws-credentials)
#    eval $(export-aws-credentials other-profile)

[[ -z "$1" ]] && profile="default" || profile="$1"

credentials=$(grep -A 2 "\[$profile\]" ~/.aws/credentials | grep -v "$profile")

if [[ "$credentials" == "" ]]; then
    echo "Error: profile '$profile' not found in ~/.aws/credentials" >&2
    exit 1
fi

echo "Exporting profile: $profile" >&2
for key in AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY; do
    val=$(echo "$credentials" | grep -i $key | awk '{print $3}')
    if [[ "$val" == "" ]]; then
        echo " Error: missing $key" >&2
        exit 1
    fi
    echo "export $key='$val'"
    export "$key='$val'"
done
